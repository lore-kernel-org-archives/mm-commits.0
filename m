From: akpm@linux-foundation.org
Subject: + idr-rename-max_level-to-max_idr_level-fix.patch added to -mm tree
Date: Wed, 12 Sep 2012 16:03:07 -0700
Message-ID: <20120912230308.AC7FA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58454 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2ILXDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 19:03:12 -0400
Received: by wibhr14 with SMTP id hr14so150830wib.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 16:03:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bernd@petrovitsch.priv.at, fengguang.wu@intel.com, glommer@parallels.com, wharms@bfs.de


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix
has been added to the -mm tree.  Its filename is
     idr-rename-max_level-to-max_idr_level-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -78,7 +78,7 @@ again:
 	else if (unlikely(err))
 		return err;
 
-	*id = *id & MAX_ID_MASK;
+	*id = *id & MAX_IDR_MASK;
 	return 0;
 }
 
diff -puN fs/super.c~idr-rename-max_level-to-max_idr_level-fix fs/super.c
--- a/fs/super.c~idr-rename-max_level-to-max_idr_level-fix
+++ a/fs/super.c
@@ -871,7 +871,7 @@ int get_anon_bdev(dev_t *p)
 	else if (error)
 		return -EAGAIN;
 
-	if ((dev & MAX_ID_MASK) == (1 << MINORBITS)) {
+	if ((dev & MAX_IDR_MASK) == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
 		ida_remove(&unnamed_dev_ida, dev);
 		if (unnamed_dev_start > dev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

