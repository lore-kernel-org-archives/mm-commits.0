From: akpm@linux-foundation.org
Subject: - md-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:53 -0700
Message-ID: <200804282159.m3SLxrO6018625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965497AbYD1V76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     md-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-uevent.c |   22 +++++++++++-----------
 drivers/md/raid5.c     |   28 ++++++++++++++--------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff -puN drivers/md/dm-uevent.c~md-replace-remaining-__function__-occurrences drivers/md/dm-uevent.c
--- a/drivers/md/dm-uevent.c~md-replace-remaining-__function__-occurrences
+++ a/drivers/md/dm-uevent.c
@@ -78,7 +78,7 @@ static struct dm_uevent *dm_build_path_u
 
 	event = dm_uevent_alloc(md);
 	if (!event) {
-		DMERR("%s: dm_uevent_alloc() failed", __FUNCTION__);
+		DMERR("%s: dm_uevent_alloc() failed", __func__);
 		goto err_nomem;
 	}
 
@@ -86,32 +86,32 @@ static struct dm_uevent *dm_build_path_u
 
 	if (add_uevent_var(&event->ku_env, "DM_TARGET=%s", ti->type->name)) {
 		DMERR("%s: add_uevent_var() for DM_TARGET failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s", dm_action)) {
 		DMERR("%s: add_uevent_var() for DM_ACTION failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_SEQNUM=%u",
 			   dm_next_uevent_seq(md))) {
 		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
-		DMERR("%s: add_uevent_var() for DM_PATH failed", __FUNCTION__);
+		DMERR("%s: add_uevent_var() for DM_PATH failed", __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
 			   nr_valid_paths)) {
 		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
@@ -146,25 +146,25 @@ void dm_send_uevents(struct list_head *e
 		if (dm_copy_name_and_uuid(event->md, event->name,
 					  event->uuid)) {
 			DMERR("%s: dm_copy_name_and_uuid() failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		if (add_uevent_var(&event->ku_env, "DM_NAME=%s", event->name)) {
 			DMERR("%s: add_uevent_var() for DM_NAME failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		if (add_uevent_var(&event->ku_env, "DM_UUID=%s", event->uuid)) {
 			DMERR("%s: add_uevent_var() for DM_UUID failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		r = kobject_uevent_env(kobj, event->action, event->ku_env.envp);
 		if (r)
-			DMERR("%s: kobject_uevent_env failed", __FUNCTION__);
+			DMERR("%s: kobject_uevent_env failed", __func__);
 uevent_free:
 		dm_uevent_free(event);
 	}
@@ -187,7 +187,7 @@ void dm_path_uevent(enum dm_uevent_type 
 	struct dm_uevent *event;
 
 	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
-		DMERR("%s: Invalid event_type %d", __FUNCTION__, event_type);
+		DMERR("%s: Invalid event_type %d", __func__, event_type);
 		goto out;
 	}
 
diff -puN drivers/md/raid5.c~md-replace-remaining-__function__-occurrences drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-replace-remaining-__function__-occurrences
+++ a/drivers/md/raid5.c
@@ -433,7 +433,7 @@ static void ops_run_io(struct stripe_hea
 
 			bi->bi_bdev = rdev->bdev;
 			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
-				__FUNCTION__, (unsigned long long)sh->sector,
+				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
@@ -520,7 +520,7 @@ static void ops_complete_biofill(void *s
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
@@ -569,7 +569,7 @@ static void ops_run_biofill(struct strip
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = sh->disks; i--; ) {
@@ -600,7 +600,7 @@ static void ops_complete_compute5(void *
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(R5_UPTODATE, &tgt->flags);
@@ -625,7 +625,7 @@ ops_run_compute5(struct stripe_head *sh,
 	int i;
 
 	pr_debug("%s: stripe %llu block: %d\n",
-		__FUNCTION__, (unsigned long long)sh->sector, target);
+		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
 	for (i = disks; i--; )
@@ -653,7 +653,7 @@ static void ops_complete_prexor(void *st
 {
 	struct stripe_head *sh = stripe_head_ref;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
@@ -670,7 +670,7 @@ ops_run_prexor(struct stripe_head *sh, s
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -699,7 +699,7 @@ ops_run_biodrain(struct stripe_head *sh,
 	 */
 	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -744,7 +744,7 @@ static void ops_complete_postxor(void *s
 {
 	struct stripe_head *sh = stripe_head_ref;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
@@ -757,7 +757,7 @@ static void ops_complete_write(void *str
 	struct stripe_head *sh = stripe_head_ref;
 	int disks = sh->disks, i, pd_idx = sh->pd_idx;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -787,7 +787,7 @@ ops_run_postxor(struct stripe_head *sh, 
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* check if prexor is active which means only process blocks
@@ -837,7 +837,7 @@ static void ops_complete_check(void *str
 	struct stripe_head *sh = stripe_head_ref;
 	int pd_idx = sh->pd_idx;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
@@ -859,7 +859,7 @@ static void ops_run_check(struct stripe_
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -1759,7 +1759,7 @@ handle_write_operations5(struct stripe_h
 	locked++;
 
 	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
-		__FUNCTION__, (unsigned long long)sh->sector,
+		__func__, (unsigned long long)sh->sector,
 		locked, sh->ops.pending);
 
 	return locked;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

