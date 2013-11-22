From: akpm@linux-foundation.org
Subject: + mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 15:53:45 -0800
Message-ID: <528fee89.7UUwSSzz01C2zn+N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3KVXxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 18:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steve.capper@linaro.org, riel@redhat.com, mgorman@suse.de, marc.zyngier@arm.com, hughd@google.com, aarcange@redhat.com, andreas@sandberg.pp.se

Subject: + mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch added to -mm tree
To: andreas@sandberg.pp.se,aarcange@redhat.com,hughd@google.com,marc.zyngier@arm.com,mgorman@suse.de,riel@redhat.com,steve.capper@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 15:53:45 -0800


The patch titled
     Subject: mm/hugetlb.c: call MMU notifiers when copying a hugetlb page range
has been added to the -mm tree.  Its filename is
     mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Sandberg <andreas@sandberg.pp.se>
Subject: mm/hugetlb.c: call MMU notifiers when copying a hugetlb page range

When copy_hugetlb_page_range() is called to copy a range of hugetlb
mappings, the secondary MMUs are not notified if there is a protection
downgrade, which breaks COW semantics in KVM.

This patch adds the necessary MMU notifier calls.

Signed-off-by: Andreas Sandberg <andreas@sandberg.pp.se>
Acked-by: Steve Capper <steve.capper@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range mm/hugetlb.c
--- a/mm/hugetlb.c~mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range
+++ a/mm/hugetlb.c
@@ -2346,17 +2346,27 @@ int copy_hugetlb_page_range(struct mm_st
 	int cow;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
+	int ret = 0;
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
+	mmun_start = vma->vm_start;
+	mmun_end = vma->vm_end;
+	if (cow)
+		mmu_notifier_invalidate_range_start(src, mmun_start, mmun_end);
+
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr);
 		if (!src_pte)
 			continue;
 		dst_pte = huge_pte_alloc(dst, addr, sz);
-		if (!dst_pte)
-			goto nomem;
+		if (!dst_pte) {
+			ret = -ENOMEM;
+			break;
+		}
 
 		/* If the pagetables are shared don't copy or take references */
 		if (dst_pte == src_pte)
@@ -2377,10 +2387,11 @@ int copy_hugetlb_page_range(struct mm_st
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
 	}
-	return 0;
 
-nomem:
-	return -ENOMEM;
+	if (cow)
+		mmu_notifier_invalidate_range_end(src, mmun_start, mmun_end);
+
+	return ret;
 }
 
 static int is_hugetlb_entry_migration(pte_t pte)
_

Patches currently in -mm which might be from andreas@sandberg.pp.se are

mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch

