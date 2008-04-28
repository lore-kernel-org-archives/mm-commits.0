From: akpm@linux-foundation.org
Subject: - rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:44:46 -0700
Message-ID: <200804280644.m3S6ikoW012307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760341AbYD1Go5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8563-new-style-conversion-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-pcf8563-new-style-conversion.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf8563-new-style-conversion-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#100: FILE: drivers/rtc/rtc-pcf8563.c:255:
+	dev_dbg(&client->dev, "%s\n", __FUNCTION__);

ERROR: do not use assignment in if condition
#120: FILE: drivers/rtc/rtc-pcf8563.c:260:
+	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL)))

WARNING: line over 80 characters
#141: FILE: drivers/rtc/rtc-pcf8563.c:271:
+	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name, &client->dev,

total: 1 errors, 2 warnings, 180 lines checked

./patches/rtc-pcf8563-new-style-conversion.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-new-style-conversion-checkpatch-fixes drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-new-style-conversion-checkpatch-fixes
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -252,12 +252,13 @@ static int pcf8563_probe(struct i2c_clie
 
 	int err = 0;
 
-	dev_dbg(&client->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&client->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL)))
+	pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL));
+	if (!pcf8563)
 		return -ENOMEM;
 
 	/* Verify the chip is really an PCF8563 */
@@ -268,8 +269,8 @@ static int pcf8563_probe(struct i2c_clie
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name, &client->dev,
-				&pcf8563_rtc_ops, THIS_MODULE);
+	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name,
+				&client->dev, &pcf8563_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(pcf8563->rtc)) {
 		err = PTR_ERR(pcf8563->rtc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

