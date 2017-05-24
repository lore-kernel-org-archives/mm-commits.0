From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch added to -mm tree
Date: Wed, 24 May 2017 14:25:08 -0700
Message-ID: <5925fa34.P2osq8HZjOt8HLUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033246AbdEXVZJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: report -EHWPOISON not -EFAULT when FOLL_HWPOISON is specified
has been added to the -mm tree.  Its filename is
     mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20170524160900.28786-1-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[4.11.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ++++++++++
 mm/gup.c           |    9 +++------
 mm/hugetlb.c       |    3 +++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified
+++ a/include/linux/mm.h
@@ -2327,6 +2327,16 @@ static inline struct page *follow_page(s
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 
+static inline int vm_fault_to_errno(int vm_fault, int foll_flags) {
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
@@ -481,12 +481,9 @@ static int faultin_page(struct task_stru
 
 	ret = handle_mm_fault(vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
-		if (ret & VM_FAULT_OOM)
-			return -ENOMEM;
-		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
-			return *flags & FOLL_HWPOISON ? -EHWPOISON : -EFAULT;
-		if (ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV))
-			return -EFAULT;
+		int err = vm_fault_to_errno(ret, *flags);
+		if (err)
+			return err;
 		BUG();
 	}
 
diff -puN mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified
+++ a/mm/hugetlb.c
@@ -4186,7 +4186,10 @@ long follow_hugetlb_page(struct mm_struc
 			}
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
 			if (ret & VM_FAULT_ERROR) {
+				int err = vm_fault_to_errno(ret, flags);
 				remainder = 0;
+				if (err)
+					return err;
 				break;
 			}
 			if (ret & VM_FAULT_RETRY) {
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch

