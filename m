From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 13 Mar 2012 12:50:28 -0700
Message-ID: <20120313195030.42D7FA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:48282 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2CMTud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 15:50:33 -0400
Received: by vcbfk26 with SMTP id fk26so146034vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 12:50:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/id.c                |    4 ----
 drivers/hwmon/jc42.c                    |    4 ----
 drivers/net/wireless/ath/carl9170/tx.c  |    4 ----
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 sound/pci/hda/patch_realtek.c           |   10 ----------
 5 files changed, 25 deletions(-)

diff -puN arch/arm/mach-omap2/id.c~linux-next-git-rejects arch/arm/mach-omap2/id.c
--- a/arch/arm/mach-omap2/id.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/id.c
@@ -397,11 +397,7 @@ void __init omap3xxx_check_revision(void
 		break;
 	case 0xb944:
 		omap_revision = AM335X_REV_ES1_0;
-<<<<<<< HEAD
-		*cpu_rev = "1.0";
-=======
 		cpu_rev = "1.0";
->>>>>>> linux-next/akpm-end
 		break;
 	case 0xb8f2:
 		switch (rev) {
diff -puN drivers/hwmon/jc42.c~linux-next-git-rejects drivers/hwmon/jc42.c
--- a/drivers/hwmon/jc42.c~linux-next-git-rejects
+++ a/drivers/hwmon/jc42.c
@@ -180,7 +180,6 @@ static int jc42_remove(struct i2c_client
 static struct jc42_data *jc42_update_device(struct device *dev);
 
 static const struct i2c_device_id jc42_id[] = {
-<<<<<<< HEAD
 	{ "adt7408", 0 },
 	{ "at30ts00", 0 },
 	{ "cat94ts02", 0 },
@@ -200,9 +199,6 @@ static const struct i2c_device_id jc42_i
 	{ "stts3000", 0 },
 	{ "tse2002", 0 },
 	{ "ts3000", 0 },
-=======
-	{ "jc42", 0 },
->>>>>>> linux-next/akpm-end
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, jc42_id);
diff -puN drivers/net/wireless/ath/carl9170/tx.c~linux-next-git-rejects drivers/net/wireless/ath/carl9170/tx.c
--- a/drivers/net/wireless/ath/carl9170/tx.c~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/carl9170/tx.c
@@ -1247,11 +1247,7 @@ static bool carl9170_tx_ps_drop(struct a
 	tx_info = IEEE80211_SKB_CB(skb);
 
 	if (unlikely(sta_info->sleeping) &&
-<<<<<<< HEAD
-	    !(tx_info->flags & (IEEE80211_TX_CTL_POLL_RESPONSE |
-=======
 	    !(tx_info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
->>>>>>> linux-next/akpm-end
 				IEEE80211_TX_CTL_CLEAR_PS_FILT))) {
 		rcu_read_unlock();
 
diff -puN drivers/net/wireless/mwifiex/cfg80211.c~linux-next-git-rejects drivers/net/wireless/mwifiex/cfg80211.c
--- a/drivers/net/wireless/mwifiex/cfg80211.c~linux-next-git-rejects
+++ a/drivers/net/wireless/mwifiex/cfg80211.c
@@ -871,10 +871,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_pr
 	priv->sec_info.wpa2_enabled = false;
 	priv->wep_key_curr_index = 0;
 	priv->sec_info.encryption_mode = 0;
-<<<<<<< HEAD
-=======
 	priv->sec_info.is_authtype_auto = 0;
->>>>>>> linux-next/akpm-end
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -2051,24 +2051,18 @@ static int alc_build_controls(struct hda
  */
 
 static void alc_init_special_input_src(struct hda_codec *codec);
-<<<<<<< HEAD
 static int alc269_fill_coef(struct hda_codec *codec);
-=======
 static void alc_auto_init_std(struct hda_codec *codec);
->>>>>>> linux-next/akpm-end
 
 static int alc_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	unsigned int i;
 
-<<<<<<< HEAD
 	if (codec->vendor_id == 0x10ec0269)
 		alc269_fill_coef(codec);
-=======
 	if (spec->init_hook)
 		spec->init_hook(codec);
->>>>>>> linux-next/akpm-end
 
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
@@ -6135,11 +6129,7 @@ static void alc269_fill_coef(struct hda_
 	int val;
 
 	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
-<<<<<<< HEAD
-		return 0;
-=======
 		return;
->>>>>>> linux-next/akpm-end
 
 	if ((alc_get_coef0(codec) & 0x00ff) < 0x015) {
 		alc_write_coef_idx(codec, 0xf, 0x960b);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

