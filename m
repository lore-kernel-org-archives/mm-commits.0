From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 02 Jan 2013 12:07:00 -0800
Message-ID: <20130102200702.EC60382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42219 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3ABUHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 15:07:05 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so1536727vcq.2
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 12:07:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                     |    3 ---
 drivers/md/dm-raid1.c                |    5 -----
 drivers/md/dm-snap.c                 |   13 -------------
 drivers/md/dm-thin.c                 |    4 ----
 drivers/pinctrl/pinctrl-exynos5440.c |    4 ----
 drivers/pinctrl/pinctrl-samsung.c    |    4 ----
 6 files changed, 33 deletions(-)

diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
--- a/arch/x86/Kconfig~linux-next-git-rejects
+++ a/arch/x86/Kconfig
@@ -112,10 +112,7 @@ config X86
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
-<<<<<<< HEAD
-=======
 	select ARCH_USE_BUILTIN_BSWAP
->>>>>>> linux-next/akpm-base
 	select GENERIC_SIGALTSTACK
 
 config INSTRUCTION_DECODER
diff -puN drivers/pinctrl/pinctrl-exynos5440.c~linux-next-git-rejects drivers/pinctrl/pinctrl-exynos5440.c
--- a/drivers/pinctrl/pinctrl-exynos5440.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-exynos5440.c
@@ -117,11 +117,7 @@ struct exynos5440_pinctrl_priv_data {
 };
 
 /* list of all possible config options supported */
-<<<<<<< HEAD
-static struct pin_config {
-=======
 static const struct pin_config {
->>>>>>> linux-next/akpm-base
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
diff -puN drivers/pinctrl/pinctrl-samsung.c~linux-next-git-rejects drivers/pinctrl/pinctrl-samsung.c
--- a/drivers/pinctrl/pinctrl-samsung.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-samsung.c
@@ -37,11 +37,7 @@
 #define FSUFFIX_LEN		sizeof(FUNCTION_SUFFIX)
 
 /* list of all possible config options supported */
-<<<<<<< HEAD
-static struct pin_config {
-=======
 static const struct pin_config {
->>>>>>> linux-next/akpm-base
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
diff -puN drivers/md/dm-raid1.c~linux-next-git-rejects drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~linux-next-git-rejects
+++ a/drivers/md/dm-raid1.c
@@ -1183,15 +1183,10 @@ static int mirror_map(struct dm_target *
 	if (unlikely(!m))
 		return -EIO;
 
-<<<<<<< HEAD
-	dm_bio_record(&bio_record->details, bio);
-	bio_record->m = m;
-=======
 	read_record = mempool_alloc(ms->read_record_pool, GFP_NOIO);
 	dm_bio_record(&read_record->details, bio);
 	map_context->ptr = read_record;
 	read_record->m = m;
->>>>>>> linux-next/akpm-base
 
 	map_bio(m, bio);
 
diff -puN drivers/md/dm-snap.c~linux-next-git-rejects drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~linux-next-git-rejects
+++ a/drivers/md/dm-snap.c
@@ -198,18 +198,8 @@ static void init_tracked_chunk(struct bi
 
 static bool is_bio_tracked(struct bio *bio)
 {
-<<<<<<< HEAD
-	struct dm_snap_tracked_chunk *c = dm_per_bio_data(bio, sizeof(struct dm_snap_tracked_chunk));
-	return !hlist_unhashed(&c->node);
-}
-
-static void track_chunk(struct dm_snapshot *s, struct bio *bio, chunk_t chunk)
-{
-	struct dm_snap_tracked_chunk *c = dm_per_bio_data(bio, sizeof(struct dm_snap_tracked_chunk));
-=======
 	struct dm_snap_tracked_chunk *c = mempool_alloc(s->tracked_chunk_pool,
 							GFP_NOIO);
->>>>>>> linux-next/akpm-base
 
 	c->chunk = chunk;
 
@@ -217,11 +207,8 @@ static void track_chunk(struct dm_snapsh
 	hlist_add_head(&c->node,
 		       &s->tracked_chunk_hash[DM_TRACKED_CHUNK_HASH(chunk)]);
 	spin_unlock_irq(&s->tracked_chunk_lock);
-<<<<<<< HEAD
-=======
 
 	return c;
->>>>>>> linux-next/akpm-base
 }
 
 static void stop_tracking_chunk(struct dm_snapshot *s, struct bio *bio)
diff -puN drivers/md/dm-thin.c~linux-next-git-rejects drivers/md/dm-thin.c
--- a/drivers/md/dm-thin.c~linux-next-git-rejects
+++ a/drivers/md/dm-thin.c
@@ -374,11 +374,7 @@ static void inc_all_io_entry(struct pool
 	if (bio->bi_rw & REQ_DISCARD)
 		return;
 
-<<<<<<< HEAD
-	h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
-=======
 	h = dm_get_mapinfo(bio)->ptr;
->>>>>>> linux-next/akpm-base
 	h->all_io_entry = dm_deferred_entry_inc(pool->all_io_ds);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
linux-next.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
cma-use-unsigned-type-for-count-argument-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

