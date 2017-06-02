From: akpm@linux-foundation.org
Subject: [patch 13/15] mm/hugetlb: report -EHWPOISON not -EFAULT when
 FOLL_HWPOISON is specified
Date: Fri, 02 Jun 2017 14:46:46 -0700
Message-ID: <5931dcc6.TA6aEQyaInMq97w1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, james.morse@arm.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, stable@vger.kernel.org

From: James Morse <james.morse@arm.com>
Subject: mm/hugetlb: report -EHWPOISON not -EFAULT when FOLL_HWPOISON is specified

KVM uses get_user_pages() to resolve its stage2 faults.  KVM sets the
FOLL_HWPOISON flag causing faultin_page() to return -EHWPOISON when it
finds a VM_FAULT_HWPOISON.  KVM handles these hwpoison pages as a special
case.  (check_user_page_hwpoison())

When huge pages are involved, this doesn't work so well.  get_user_pages()
calls follow_hugetlb_page(), which stops early if it receives
VM_FAULT_HWPOISON from hugetlb_fault(), eventually returning -EFAULT to
the caller.  The step to map this to -EHWPOISON based on the FOLL_ flags
is missing.  The hwpoison special case is skipped, and -EFAULT is returned
to user-space, causing Qemu or kvmtool to exit.

Instead, move this VM_FAULT_ to errno mapping code into a header file and
use it from faultin_page() and follow_hugetlb_page().

With this, KVM works as expected.

This isn't a problem for arm64 today as we haven't enabled MEMORY_FAILURE,
but I can't see any reason this doesn't happen on x86 too, so I think this
should be a fix. This doesn't apply earlier than stable's v4.11.1 due to
all sorts of cleanup.

[james.morse@arm.com: add vm_fault_to_errno() call to faultin_page()]
suggested.
  Link: http://lkml.kernel.org/r/20170525171035.16359-1-james.morse@arm.com
[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170524160900.28786-1-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.11.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +++++++++++
 mm/gup.c           |   20 ++++++++------------
 mm/hugetlb.c       |    5 +++++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified
+++ a/include/linux/mm.h
@@ -2327,6 +2327,17 @@ static inline struct page *follow_page(s
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 
+static inline int vm_fault_to_errno(int vm_fault, int foll_flags)
+{
+	if (vm_fault & VM_FAULT_OOM)
+		return -ENOMEM;
+	if (vm_fault & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+		return (foll_flags & FOLL_HWPOISON) ? -EHWPOISON : -EFAULT;
+	if (vm_fault & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV))
+		return -EFAULT;
+	return 0;
+}
+
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
diff -puN mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified mm/gup.c
--- a/mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified
+++ a/mm/gup.c
@@ -407,12 +407,10 @@ static int faultin_page(struct task_stru
 
 	ret = handle_mm_fault(vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
-		if (ret & VM_FAULT_OOM)
-			return -ENOMEM;
-		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
-			return *flags & FOLL_HWPOISON ? -EHWPOISON : -EFAULT;
-		if (ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV))
-			return -EFAULT;
+		int err = vm_fault_to_errno(ret, *flags);
+
+		if (err)
+			return err;
 		BUG();
 	}
 
@@ -723,12 +721,10 @@ retry:
 	ret = handle_mm_fault(vma, address, fault_flags);
 	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
-		if (ret & VM_FAULT_OOM)
-			return -ENOMEM;
-		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
-			return -EHWPOISON;
-		if (ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV))
-			return -EFAULT;
+		int err = vm_fault_to_errno(ret, 0);
+
+		if (err)
+			return err;
 		BUG();
 	}
 
diff -puN mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified
+++ a/mm/hugetlb.c
@@ -4170,6 +4170,11 @@ long follow_hugetlb_page(struct mm_struc
 			}
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
 			if (ret & VM_FAULT_ERROR) {
+				int err = vm_fault_to_errno(ret, flags);
+
+				if (err)
+					return err;
+
 				remainder = 0;
 				break;
 			}
_
