From: akpm@linux-foundation.org
Subject: [folded-dropped] idr-rename-max_level-to-max_idr_level-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:56:57 -0700
Message-ID: <20121004235658.BF9B4200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:51982 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JDX5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:57:02 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so51603lah.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:57:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bernd@petrovitsch.priv.at, fengguang.wu@intel.com, glommer@parallels.com, wharms@bfs.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix
has been removed from the -mm tree.  Its filename was
     idr-rename-max_level-to-max_idr_level-fix.patch

This patch was dropped because it was folded into idr-rename-max_level-to-max_idr_level.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: idr-rename-max_level-to-max_idr_level-fix

repair fallout

Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: walter harms <wharms@bfs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c        |    2 +-
 drivers/infiniband/core/cm.c  |    2 +-
 drivers/pps/pps.c             |    2 +-
 drivers/thermal/thermal_sys.c |    2 +-
 fs/super.c                    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/i2c/i2c-core.c~idr-rename-max_level-to-max_idr_level-fix drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/drivers/i2c/i2c-core.c
@@ -982,7 +982,7 @@ int i2c_add_numbered_adapter(struct i2c_
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_ID_MASK)
+	if (adap->nr & ~MAX_IDR_MASK)
 		return -EINVAL;
 
 retry:
diff -puN drivers/infiniband/core/cm.c~idr-rename-max_level-to-max_idr_level-fix drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/drivers/infiniband/core/cm.c
@@ -390,7 +390,7 @@ static int cm_alloc_id(struct cm_id_priv
 		ret = idr_get_new_above(&cm.local_id_table, cm_id_priv,
 					next_id, &id);
 		if (!ret)
-			next_id = ((unsigned) id + 1) & MAX_ID_MASK;
+			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
 		spin_unlock_irqrestore(&cm.lock, flags);
 	} while( (ret == -EAGAIN) && idr_pre_get(&cm.local_id_table, GFP_KERNEL) );
 
diff -puN drivers/pps/pps.c~idr-rename-max_level-to-max_idr_level-fix drivers/pps/pps.c
--- a/drivers/pps/pps.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/drivers/pps/pps.c
@@ -306,7 +306,7 @@ int pps_register_cdev(struct pps_device 
 	if (err < 0)
 		return err;
 
-	pps->id &= MAX_ID_MASK;
+	pps->id &= MAX_IDR_MASK;
 	if (pps->id >= PPS_MAX_SOURCES) {
 		pr_err("%s: too many PPS sources in the system\n",
 					pps->info.name);
diff -puN drivers/thermal/thermal_sys.c~idr-rename-max_level-to-max_idr_level-fix drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/drivers/thermal/thermal_sys.c
@@ -148,7 +148,7 @@ again:
 	else if (unlikely(err))
 		return err;
 
-	*id = *id & MAX_ID_MASK;
+	*id = *id & MAX_IDR_MASK;
 	return 0;
 }
 
diff -puN fs/super.c~idr-rename-max_level-to-max_idr_level-fix fs/super.c
--- a/fs/super.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/fs/super.c
@@ -865,7 +865,7 @@ int get_anon_bdev(dev_t *p)
 	else if (error)
 		return -EAGAIN;
 
-	if ((dev & MAX_ID_MASK) == (1 << MINORBITS)) {
+	if ((dev & MAX_IDR_MASK) == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
 		ida_remove(&unnamed_dev_ida, dev);
 		if (unnamed_dev_start > dev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

