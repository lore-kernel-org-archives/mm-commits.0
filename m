From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:48:43 -0800
Message-ID: <528d3c4b.aEySX+tV9aGlA6eW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3KTWso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: + mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch added to -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:48:43 -0800


The patch titled
     Subject: mm: hugetlbfs: use __compound_tail_refcounted in __get_page_tail too
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN mm/swap.c~mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix mm/swap.c
--- a/mm/swap.c~mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix
+++ a/mm/swap.c
@@ -31,7 +31,6 @@
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
-#include <linux/hugetlb.h>
 
 #include "internal.h"
 
@@ -240,7 +239,7 @@ bool __get_page_tail(struct page *page)
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
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
mm-hugetlbfs-fix-hugetlbfs-optimization.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch

