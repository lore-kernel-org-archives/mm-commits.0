From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 15 Apr 2009 12:37:07 -0700
Message-ID: <200904151937.n3FJb7Gn021581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbZDOTjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 15:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, tiwai@suse.de


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Some origin-vs-linux-next muckup.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c  |   91 -----------------------------------------
 sound/pci/intel8x0.c |   24 ----------
 2 files changed, 115 deletions(-)

diff -puN block/cfq-iosched.c~linux-next-git-rejects block/cfq-iosched.c
--- a/block/cfq-iosched.c~linux-next-git-rejects
+++ a/block/cfq-iosched.c
@@ -928,16 +928,8 @@ static struct cfq_queue *cfq_get_next_qu
 static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 					      struct cfq_queue *cfqq)
 {
-<<<<<<< HEAD:block/cfq-iosched.c
-	if (!cfqq) {
-		cfqq = cfq_get_next_queue(cfqd);
-		if (cfqq)
-			cfq_clear_cfqq_coop(cfqq);
-	}
-=======
 	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
->>>>>>> FETCH_HEAD:block/cfq-iosched.c
 
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
@@ -964,64 +956,6 @@ static inline int cfq_rq_close(struct cf
 
 static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 				    struct cfq_queue *cur_cfqq)
-<<<<<<< HEAD:block/cfq-iosched.c
-{
-	struct rb_root *root = &cfqd->prio_trees[cur_cfqq->ioprio];
-	struct rb_node *parent, *node;
-	struct cfq_queue *__cfqq;
-	sector_t sector = cfqd->last_position;
-
-	if (RB_EMPTY_ROOT(root))
-		return NULL;
-
-	/*
-	 * First, if we find a request starting at the end of the last
-	 * request, choose it.
-	 */
-	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
-				      sector, &parent, NULL);
-	if (__cfqq)
-		return __cfqq;
-
-	/*
-	 * If the exact sector wasn't found, the parent of the NULL leaf
-	 * will contain the closest sector.
-	 */
-	__cfqq = rb_entry(parent, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, __cfqq->next_rq))
-		return __cfqq;
-
-	if (__cfqq->next_rq->sector < sector)
-		node = rb_next(&__cfqq->p_node);
-	else
-		node = rb_prev(&__cfqq->p_node);
-	if (!node)
-		return NULL;
-
-	__cfqq = rb_entry(node, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, __cfqq->next_rq))
-		return __cfqq;
-
-	return NULL;
-}
-
-/*
- * cfqd - obvious
- * cur_cfqq - passed in so that we don't decide that the current queue is
- * 	      closely cooperating with itself.
- *
- * So, basically we're assuming that that cur_cfqq has dispatched at least
- * one request, and that cfqd->last_position reflects a position on the disk
- * associated with the I/O issued by cur_cfqq.  I'm not sure this is a valid
- * assumption.
- */
-static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
-					      struct cfq_queue *cur_cfqq,
-					      int probe)
-{
-	struct cfq_queue *cfqq;
-
-=======
 {
 	struct rb_root *root = &cfqd->prio_trees[cur_cfqq->ioprio];
 	struct rb_node *parent, *node;
@@ -1075,7 +1009,6 @@ static struct cfq_queue *cfq_close_coope
 static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 					      struct cfq_queue *cur_cfqq)
 {
->>>>>>> FETCH_HEAD:block/cfq-iosched.c
 	/*
 	 * A valid cfq_io_context is necessary to compare requests against
 	 * the seek_mean of the current cfqq.
@@ -1088,20 +1021,7 @@ static struct cfq_queue *cfq_close_coope
 	 * working closely on the same area of the disk. In that case,
 	 * we can group them together and don't waste time idling.
 	 */
-<<<<<<< HEAD:block/cfq-iosched.c
-	cfqq = cfqq_close(cfqd, cur_cfqq);
-	if (!cfqq)
-		return NULL;
-
-	if (cfq_cfqq_coop(cfqq))
-		return NULL;
-
-	if (!probe)
-		cfq_mark_cfqq_coop(cfqq);
-	return cfqq;
-=======
 	return cfqq_close(cfqd, cur_cfqq);
->>>>>>> FETCH_HEAD:block/cfq-iosched.c
 }
 
 
@@ -1258,11 +1178,7 @@ static struct cfq_queue *cfq_select_queu
 	 * cooperators and put the close queue at the front of the service
 	 * tree.
 	 */
-<<<<<<< HEAD:block/cfq-iosched.c
-	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
-=======
 	new_cfqq = cfq_close_cooperator(cfqd, cfqq);
->>>>>>> FETCH_HEAD:block/cfq-iosched.c
 	if (new_cfqq)
 		goto expire;
 
@@ -2247,19 +2163,12 @@ static void cfq_completed_request(struct
 		 * mean seek distance, give them a chance to run instead
 		 * of idling.
 		 */
-<<<<<<< HEAD:block/cfq-iosched.c
-		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
-		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
-			 sync && !rq_noidle(rq))
-=======
 		if (cfqq_empty && cfqd->busy_queues) {
 			if (cfq_close_cooperator(cfqd, cfqq))
 				cfq_slice_expired(cfqd, 1);
 		} else if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && !rq_noidle(rq) && cfqq_empty)
->>>>>>> FETCH_HEAD:block/cfq-iosched.c
 			cfq_arm_slice_timer(cfqd);
 	}
 
diff -puN sound/pci/intel8x0.c~linux-next-git-rejects sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c~linux-next-git-rejects
+++ a/sound/pci/intel8x0.c
@@ -2676,11 +2676,7 @@ static void __devinit intel8x0_measure_a
 	struct ichdev *ichdev;
 	unsigned long port;
 	unsigned long pos, pos1, t;
-<<<<<<< HEAD:sound/pci/intel8x0.c
-	int civ, timeout = 1000, attempt = 1;
-=======
 	int civ, timeout = 1000;
->>>>>>> FETCH_HEAD:sound/pci/intel8x0.c
 	struct timespec start_time, stop_time;
 
 	if (chip->ac97_bus->clock != 48000)
@@ -2754,14 +2750,6 @@ static void __devinit intel8x0_measure_a
 
 	if (pos == 0) {
 		snd_printk(KERN_ERR "intel8x0: measure - unreliable DMA position..\n");
-<<<<<<< HEAD:sound/pci/intel8x0.c
-	      __retry:
-		if (attempt < 2) {
-			attempt++;
-			goto __again;
-		}
-=======
->>>>>>> FETCH_HEAD:sound/pci/intel8x0.c
 		return;
 	}
 
@@ -2772,29 +2760,17 @@ static void __devinit intel8x0_measure_a
 	printk(KERN_INFO "%s: measured %lu usecs (%lu samples)\n", __func__, t, pos);
 	if (t == 0) {
 		snd_printk(KERN_ERR "intel8x0: ?? calculation error..\n");
-<<<<<<< HEAD:sound/pci/intel8x0.c
-		goto __retry;
-=======
 		return;
->>>>>>> FETCH_HEAD:sound/pci/intel8x0.c
 	}
 	pos *= 1000;
 	pos = (pos / t) * 1000 + ((pos % t) * 1000) / t;
 	if (pos < 40000 || pos >= 60000) {
 		/* abnormal value. hw problem? */
 		printk(KERN_INFO "intel8x0: measured clock %ld rejected\n", pos);
-<<<<<<< HEAD:sound/pci/intel8x0.c
-		goto __retry;
-	} else if (pos > 40500 && pos < 41500)
-		/* first exception - 41000Hz reference clock */
-		chip->ac97_bus->clock = 41000;
-	else if (pos > 43600 && pos < 44600)
-=======
 	else if (pos > 40500 || pos < 41500)
 		/* first exception - 41000Hz reference clock */
 		chip->ac97_bus->clock = 41000;
 	else if (pos > 43600 || pos < 44600)
->>>>>>> FETCH_HEAD:sound/pci/intel8x0.c
 		/* second exception - 44100HZ reference clock */
 		chip->ac97_bus->clock = 44100;
 	else if (pos < 47500 || pos > 48500)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

