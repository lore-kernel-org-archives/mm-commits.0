From: akpm@linux-foundation.org
Subject: + hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:06 -0700
Message-ID: <200807111845.m6BIjkD3030976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbYGKSqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     hugetlb: quota is not freed for unused reserved private huge pages
has been added to the -mm tree.  Its filename is
     hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: quota is not freed for unused reserved private huge pages
From: Adam Litke <agl@us.ibm.com>

With shared reservations (and now also with private reservations), we reserve
huge pages at mmap time.  We also account for the mapping against fs quota to
prevent a reservation from being preempted by quota exhaustion.

When testing with the libhugetlbfs test suite, I found a problem with quota
accounting.  FS quota for allocated pages is handled correctly but we are not
releasing quota for private pages that were reserved but never allocated.  Do
this in hugetlb_vm_op_close() at the same time as unused page reservations are
released.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages
+++ a/mm/hugetlb.c
@@ -1564,8 +1564,10 @@ static void hugetlb_vm_op_close(struct v
 
 		kref_put(&reservations->refs, resv_map_release);
 
-		if (reserve)
+		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
+			hugetlb_put_quota(vma->vm_file->f_mapping, reserve);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

linux-next.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
x86-support-gb-hugepages-on-64-bit.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch

