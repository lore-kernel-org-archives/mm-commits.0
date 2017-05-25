From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch added to -mm tree
Date: Thu, 25 May 2017 15:32:47 -0700
Message-ID: <59275b8f.ptLzIg1kx9BesjR2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946288AbdEYWcs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2
has been added to the -mm tree.  Its filename is
     mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch

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
Subject: mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2

Added vm_fault_to_errno() call to faultin_page() as Naoya Horiguchi
suggested.

Link: http://lkml.kernel.org/r/20170525171035.16359-1-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |   10 ++++------
 mm/hugetlb.c |    3 ++-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2 mm/gup.c
--- a/mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2
+++ a/mm/gup.c
@@ -795,12 +795,10 @@ retry:
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
 
diff -puN mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2
+++ a/mm/hugetlb.c
@@ -4192,9 +4192,10 @@ long follow_hugetlb_page(struct mm_struc
 			if (ret & VM_FAULT_ERROR) {
 				int err = vm_fault_to_errno(ret, flags);
 
-				remainder = 0;
 				if (err)
 					return err;
+
+				remainder = 0;
 				break;
 			}
 			if (ret & VM_FAULT_RETRY) {
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch

