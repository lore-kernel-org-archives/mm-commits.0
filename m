From: akpm@linux-foundation.org
Subject: [folded] mm-add-proc-controls-for-pdflush-threads-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:02:15 -0700
Message-ID: <200904062202.n36M2FnA004859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbZDFWFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pmorreale@novell.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-add-proc-controls-for-pdflush-threads-fix
has been removed from the -mm tree.  Its filename was
     mm-add-proc-controls-for-pdflush-threads-fix.patch

This patch was dropped because it was folded into mm-add-proc-controls-for-pdflush-threads.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-proc-controls-for-pdflush-threads-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix comment

- futz with whitespace a bit

- use __read_mostly on the globals

Cc: Peter W Morreale <pmorreale@novell.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pdflush.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN mm/pdflush.c~mm-add-proc-controls-for-pdflush-threads-fix mm/pdflush.c
--- a/mm/pdflush.c~mm-add-proc-controls-for-pdflush-threads-fix
+++ a/mm/pdflush.c
@@ -59,10 +59,10 @@ int nr_pdflush_threads = 0;
 
 /*
  * The max/min number of pdflush threads. R/W by sysctl at
- * /proc/sys/vm/nr_pdflush_threads_max
+ * /proc/sys/vm/nr_pdflush_threads_max/min
  */
-int nr_pdflush_threads_max = MAX_PDFLUSH_THREADS;
-int nr_pdflush_threads_min = MIN_PDFLUSH_THREADS;
+int nr_pdflush_threads_max __read_mostly = MAX_PDFLUSH_THREADS;
+int nr_pdflush_threads_min __read_mostly = MIN_PDFLUSH_THREADS;
 
 
 /*
@@ -142,15 +142,13 @@ static int __pdflush(struct pdflush_work
 		 * To throttle creation, we reset last_empty_jifs.
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads <
-						nr_pdflush_threads_max) {
-					last_empty_jifs = jiffies;
-					nr_pdflush_threads++;
-					spin_unlock_irq(&pdflush_lock);
-					start_one_pdflush_thread();
-					spin_lock_irq(&pdflush_lock);
-				}
+			if (list_empty(&pdflush_list) &&
+			    (nr_pdflush_threads < nr_pdflush_threads_max) {
+				last_empty_jifs = jiffies;
+				nr_pdflush_threads++;
+				spin_unlock_irq(&pdflush_lock);
+				start_one_pdflush_thread();
+				spin_lock_irq(&pdflush_lock);
 			}
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

