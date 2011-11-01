From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memoryc-quiet-sparse-noise.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:47 -0700
Message-ID: <201111012111.pA1LBlLB005812@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, aarcange@redhat.com, hsweeten@visionengravers.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: mm/huge_memory.c: quiet sparse noise

Quiet the sparse noise:

warning: symbol 'khugepaged_scan' was not declared. Should it be static?
warning: context imbalance in 'khugepaged_scan_mm_slot' - unexpected unlock

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-quiet-sparse-noise mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-quiet-sparse-noise
+++ a/mm/huge_memory.c
@@ -89,7 +89,8 @@ struct khugepaged_scan {
 	struct list_head mm_head;
 	struct mm_slot *mm_slot;
 	unsigned long address;
-} khugepaged_scan = {
+};
+static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
@@ -2069,6 +2070,8 @@ static void collect_mm_slot(struct mm_sl
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 					    struct page **hpage)
+	__releases(&khugepaged_mm_lock)
+	__acquires(&khugepaged_mm_lock)
 {
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
ceph-mds_clientc-quiet-sparse-noise.patch
mm-page_cgroupc-quiet-sparse-noise.patch

