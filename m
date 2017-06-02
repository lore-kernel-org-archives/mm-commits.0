From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch removed from -mm tree
Date: Fri, 02 Jun 2017 14:42:22 -0700
Message-ID: <5931dbbe.kdBBjTDQlkfh6P1t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVmX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch

This patch was dropped because it was folded into mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch

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
@@ -721,12 +721,10 @@ retry:
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
@@ -4172,9 +4172,10 @@ long follow_hugetlb_page(struct mm_struc
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
mm-hwpoison-use-compound_head-flags-for-huge-pages.patch

