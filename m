From: akpm@linux-foundation.org
Subject: [folded] remove-put_cpu_no_resched-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:04:51 -0700
Message-ID: <200906162204.n5GM4qJk001202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbZFPWFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Trond.Myklebust@netapp.com, bfields@fieldses.org, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     remove-put_cpu_no_resched-fix
has been removed from the -mm tree.  Its filename was
     remove-put_cpu_no_resched-fix.patch

This patch was dropped because it was folded into remove-put_cpu_no_resched.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove-put_cpu_no_resched-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from fs/nfs/client.c:46:
fs/nfs/iostat.h: In function 'nfs_add_fscache_stats':
fs/nfs/iostat.h:74: error: implicit declaration of function 'put_cpu_no_resched'

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/iostat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/iostat.h~remove-put_cpu_no_resched-fix fs/nfs/iostat.h
--- a/fs/nfs/iostat.h~remove-put_cpu_no_resched-fix
+++ a/fs/nfs/iostat.h
@@ -71,7 +71,7 @@ static inline void nfs_add_fscache_stats
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
 	iostats->fscache[stat] += addend;
-	put_cpu_no_resched();
+	put_cpu();
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

