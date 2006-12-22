From: akpm@osdl.org
Subject: + proc-zoneinfo-fix-vm-stats-display.patch added to -mm tree
Date: Fri, 22 Dec 2006 00:33:40 -0800
Message-ID: <200612220833.kBM8XegK018064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56597 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945989AbWLVIdu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 03:33:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, clameter@engr.sgi.com


The patch titled
     /proc/zoneinfo: fix vm stats display
has been added to the -mm tree.  Its filename is
     proc-zoneinfo-fix-vm-stats-display.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: /proc/zoneinfo: fix vm stats display
From: Andrew Morton <akpm@osdl.org>

This early break prevents us from displaying info for the vm stats thresholds
if the zone doesn't have any pages in its per-cpu pagesets.

So my 800MB i386 box says:

Node 0, zone      DMA
  pages free     2365
        min      16
        low      20
        high     24
        active   0
        inactive 0
        scanned  0 (a: 0 i: 0)
        spanned  4096
        present  4044
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 868, 868)
  pagesets
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     199713
        min      934
        low      1167
        high     1401
        active   10215
        inactive 4507
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  222420
    nr_anon_pages 2685
    nr_mapped    1110
    nr_file_pages 12055
    nr_slab_reclaimable 2216
    nr_slab_unreclaimable 1527
    nr_page_table_pages 213
    nr_dirty     0
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 152
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 13
              high:  62
              batch: 15
  vm stats threshold: 16
    cpu: 1 pcp: 0
              count: 34
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 10
              high:  62
              batch: 15
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096

Just nuke all that search-for-the-first-non-empty-pageset code.  Dunno why it
was there in the first place..

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmstat.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmstat.c~proc-zoneinfo-fix-vm-stats-display mm/vmstat.c
--- a/mm/vmstat.c~proc-zoneinfo-fix-vm-stats-display
+++ a/mm/vmstat.c
@@ -563,12 +563,6 @@ static int zoneinfo_show(struct seq_file
 
 			pageset = zone_pcp(zone, i);
 			for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
-				if (pageset->pcp[j].count)
-					break;
-			}
-			if (j == ARRAY_SIZE(pageset->pcp))
-				continue;
-			for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
 				seq_printf(m,
 					   "\n    cpu: %i pcp: %i"
 					   "\n              count: %i"
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
truncate-dirty-memory-accounting-fix.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch
build-compileh-earlier.patch
proc-zoneinfo-fix-vm-stats-display.patch

