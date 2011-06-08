From: akpm@linux-foundation.org
Subject: + drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch added to -mm tree
Date: Tue, 07 Jun 2011 17:33:03 -0700
Message-ID: <201106080033.p580X3ak005209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab1FHAdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 20:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, aghayal@codeaurora.org, ashayj@codeaurora.org, mcuos.com@gmail.com, sameo@linux.intel.com, sboyd@codeaurora.org


The patch titled
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
has been added to the -mm tree.  Its filename is
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch

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
Subject: drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
From: Andrew Morton <akpm@linux-foundation.org>

cosmetic tweaks

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: Ashay Jaiswal <ashayj@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -15,7 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include<linux/spinlock.h>
+#include <linux/spinlock.h>
 
 #include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/rtc.h>
@@ -46,7 +46,6 @@
  * @rtc_dev:		device structure.
  * @ctrl_reg_lock:	spinlock protecting access to ctrl_reg.
  */
-
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
 	int rtc_alarm_irq;
@@ -63,7 +62,6 @@ struct pm8xxx_rtc {
  * The RTC registers need to be read/written one byte at a time. This is a
  * hardware limitation.
  */
-
 static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
 		int base, int count)
 {
@@ -105,8 +103,7 @@ static int pm8xxx_write_wrapper(struct p
  * 3. Write Byte[1], Byte[2], Byte[3] then Byte[0].
  * 4. Enable alarm if disabled in step 1.
  */
-static int
-pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
+static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc, i;
 	unsigned long secs, irq_flags;
@@ -181,8 +178,7 @@ rtc_rw_fail:
 	return rc;
 }
 
-static int
-pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
+static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc;
 	u8 value[NUM_8_BIT_RTC_REGS], reg;
@@ -232,8 +228,7 @@ pm8xxx_rtc_read_time(struct device *dev,
 	return 0;
 }
 
-static int
-pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS], ctrl_reg;
@@ -277,8 +272,7 @@ rtc_rw_fail:
 	return rc;
 }
 
-static int
-pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc;
 	u8 value[NUM_8_BIT_RTC_REGS];
@@ -310,9 +304,7 @@ pm8xxx_rtc_read_alarm(struct device *dev
 	return 0;
 }
 
-
-static int
-pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
+static int pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 {
 	int rc;
 	unsigned long irq_flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

