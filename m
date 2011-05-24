From: akpm@linux-foundation.org
Subject: [folded] vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:58:21 -0700
Message-ID: <201105242358.p4ONwLmD024069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1EXX61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, swhiteho@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix
has been removed from the -mm tree.  Its filename was
     vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch

This patch was dropped because it was folded into vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

update gfs2

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/quota.c |   12 +++++++-----
 fs/gfs2/quota.h |    4 +++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/gfs2/quota.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix
+++ a/fs/gfs2/quota.c
@@ -38,6 +38,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
@@ -77,19 +78,20 @@ static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(qd_lru_lock);
 
-int gfs2_shrink_qd_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+int gfs2_shrink_qd_memory(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_sbd *sdp;
+	int nr_to_scan = sc->nr_to_scan;
 
-	if (nr == 0)
+	if (nr_to_scan == 0)
 		goto out;
 
-	if (!(gfp_mask & __GFP_FS))
+	if (!(sc->gfp_mask & __GFP_FS))
 		return -1;
 
 	spin_lock(&qd_lru_lock);
-	while (nr && !list_empty(&qd_lru_list)) {
+	while (nr_to_scan && !list_empty(&qd_lru_list)) {
 		qd = list_entry(qd_lru_list.next,
 				struct gfs2_quota_data, qd_reclaim);
 		sdp = qd->qd_gl->gl_sbd;
@@ -110,7 +112,7 @@ int gfs2_shrink_qd_memory(struct shrinke
 		spin_unlock(&qd_lru_lock);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
 		spin_lock(&qd_lru_lock);
-		nr--;
+		nr_to_scan--;
 	}
 	spin_unlock(&qd_lru_lock);
 
diff -puN fs/gfs2/quota.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix fs/gfs2/quota.h
--- a/fs/gfs2/quota.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix
+++ a/fs/gfs2/quota.h
@@ -12,6 +12,7 @@
 
 struct gfs2_inode;
 struct gfs2_sbd;
+struct shrink_control;
 
 #define NO_QUOTA_CHANGE ((u32)-1)
 
@@ -51,7 +52,8 @@ static inline int gfs2_quota_lock_check(
 	return ret;
 }
 
-extern int gfs2_shrink_qd_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask);
+extern int gfs2_shrink_qd_memory(struct shrinker *shrink,
+				 struct shrink_control *sc);
 extern const struct quotactl_ops gfs2_quotactl_ops;
 
 #endif /* __QUOTA_DOT_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

