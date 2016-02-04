From: akpm@linux-foundation.org
Subject: +
 mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch added
 to -mm tree
Date: Thu, 04 Feb 2016 12:51:03 -0800
Message-ID: <56b3b9b7.q84zXJBHIJhshkXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcBDUvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 15:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, aaron.lu@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix invalid free_pfn and compact_cached_free_pfn
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/compaction: fix invalid free_pfn and compact_cached_free_pfn

free_pfn and compact_cached_free_pfn are the pointer that remember restart
position of freepage scanner.  When they are reset or invalid, we set them
to zone_end_pfn because freepage scanner works in reverse direction.  But,
because zone range is defined as [zone_start_pfn, zone_end_pfn),
zone_end_pfn is invalid to access.  Therefore, we should not store it to
free_pfn and compact_cached_free_pfn.  Instead, we need to store
zone_end_pfn - 1 to them.  There is one more thing we should consider. 
Freepage scanner scan reversely by pageblock unit.  If free_pfn and
compact_cached_free_pfn are set to middle of pageblock, it regards that
sitiation as that it already scans front part of pageblock so we lose
opportunity to scan there.  To fix-up, this patch do round_down() to
guarantee that reset position will be pageblock aligned.

Note that thanks to the current pageblock_pfn_to_page() implementation,
actual access to zone_end_pfn doesn't happen until now.  But, following
patch will change pageblock_pfn_to_page() so this patch is needed from now
on.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn
+++ a/mm/compaction.c
@@ -200,7 +200,8 @@ static void reset_cached_positions(struc
 {
 	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
 	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
-	zone->compact_cached_free_pfn = zone_end_pfn(zone);
+	zone->compact_cached_free_pfn =
+			round_down(zone_end_pfn(zone) - 1, pageblock_nr_pages);
 }
 
 /*
@@ -1371,11 +1372,11 @@ static int compact_zone(struct zone *zon
 	 */
 	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
-	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
-		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
+	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
+		cc->free_pfn = round_down(end_pfn - 1, pageblock_nr_pages);
 		zone->compact_cached_free_pfn = cc->free_pfn;
 	}
-	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
+	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
 		cc->migrate_pfn = start_pfn;
 		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

