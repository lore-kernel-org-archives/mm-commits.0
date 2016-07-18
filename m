From: akpm@linux-foundation.org
Subject: + mm-show-node_pages_scanned-per-node-not-zone-fix.patch added to -mm tree
Date: Mon, 18 Jul 2016 14:14:42 -0700
Message-ID: <578d46c2.yjQE4DTSPGXXYDiy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcGRVOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2016 17:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix node_pages_scanned
has been added to the -mm tree.  Its filename is
     mm-show-node_pages_scanned-per-node-not-zone-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show-node_pages_scanned-per-node-not-zone-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-node_pages_scanned-per-node-not-zone-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix node_pages_scanned

Use pgdat for node stat instead of zone->pgdat.

Link: http://lkml.kernel.org/r/20160716101431.GA10305@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone-fix
+++ a/mm/page_alloc.c
@@ -4336,7 +4336,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
-			node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED),
+			node_page_state(pgdat, NR_PAGES_SCANNED),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch
mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch

