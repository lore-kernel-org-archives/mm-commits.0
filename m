From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-support-section-unaligned-zone_device-memory-ranges-fix.patch removed
 from -mm tree
Date: Wed, 15 Feb 2017 13:50:17 -0800
Message-ID: <58a4cd19.1Q+jHb8AEtjVw1+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdBOVuS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:50:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix maybe-uninitialized warning in section_deactivate()
has been removed from the -mm tree.  Its filename was
     mm-support-section-unaligned-zone_device-memory-ranges-fix.patch

This patch was dropped because it was folded into mm-support-section-unaligned-zone_device-memory-ranges.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: fix maybe-uninitialized warning in section_deactivate()

gcc cannot track the combined state of the 'mask' variable across the
barrier in pgdat_resize_unlock() at compile time, so it warns that we
can run into undefined behavior:

mm/sparse.c: In function 'section_deactivate':
mm/sparse.c:802:7: error: 'early_section' may be used uninitialized in this function [-Werror=maybe-uninitialized]

We know that this can't happen because the spin_unlock() doesn't
affect the mask variable, so this is a false-postive warning, but
rearranging the code to bail out earlier here makes it obvious
to the compiler as well.

Fixes: mmotm ("mm: support section-unaligned ZONE_DEVICE memory ranges")
Link: http://lkml.kernel.org/r/20170123165156.854464-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN mm/sparse.c~mm-support-section-unaligned-zone_device-memory-ranges-fix mm/sparse.c
--- a/mm/sparse.c~mm-support-section-unaligned-zone_device-memory-ranges-fix
+++ a/mm/sparse.c
@@ -807,23 +807,24 @@ static void section_deactivate(struct pg
 	unsigned long mask = section_active_mask(pfn, nr_pages), flags;
 
 	pgdat_resize_lock(pgdat, &flags);
-	if (!ms->usage) {
-		mask = 0;
-	} else if ((ms->usage->map_active & mask) != mask) {
-		WARN(1, "section already deactivated active: %#lx mask: %#lx\n",
-				ms->usage->map_active, mask);
-		mask = 0;
-	} else {
-		early_section = is_early_section(ms);
-		ms->usage->map_active ^= mask;
-		if (ms->usage->map_active == 0) {
-			usage = ms->usage;
-			ms->usage = NULL;
-			memmap = sparse_decode_mem_map(ms->section_mem_map,
-					section_nr);
-			ms->section_mem_map = 0;
-		}
+	if (!ms->usage ||
+	    WARN((ms->usage->map_active & mask) != mask,
+		 "section already deactivated active: %#lx mask: %#lx\n",
+			ms->usage->map_active, mask)) {
+		pgdat_resize_unlock(pgdat, &flags);
+		return;
 	}
+
+	early_section = is_early_section(ms);
+	ms->usage->map_active ^= mask;
+	if (ms->usage->map_active == 0) {
+		usage = ms->usage;
+		ms->usage = NULL;
+		memmap = sparse_decode_mem_map(ms->section_mem_map,
+				section_nr);
+		ms->section_mem_map = 0;
+	}
+
 	pgdat_resize_unlock(pgdat, &flags);
 
 	/*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix.patch

