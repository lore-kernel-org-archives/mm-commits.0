From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:26 -0800
Message-ID: <52e0262a.SPlMPsZ34iKrXnUD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: [merged] mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch removed from -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:26 -0800


The patch titled
     Subject: mm: hugetlbfs: use __compound_tail_refcounted in __get_page_tail too
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: hugetlbfs: use __compound_tail_refcounted in __get_page_tail too

Also remove hugetlb.h which isn't needed anymore as PageHeadHuge is
handled in mm.h.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swap.c~mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too mm/swap.c
--- a/mm/swap.c~mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too
+++ a/mm/swap.c
@@ -31,7 +31,6 @@
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
-#include <linux/hugetlb.h>
 
 #include "internal.h"
 
@@ -261,7 +260,7 @@ bool __get_page_tail(struct page *page)
 	struct page *page_head = compound_trans_head(page);
 
 	/* Ref to put_compound_page() comment. */
-	if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+	if (!__compound_tail_refcounted(page_head)) {
 		smp_rmb();
 		if (likely(PageTail(page))) {
 			/*
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

