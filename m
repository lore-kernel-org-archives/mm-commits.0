From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:03:31 -0700
Message-ID: <201107260003.p6Q03WkM006689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab1GZADv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, aghayal@codeaurora.org, ashayj@codeaurora.org, mcuos.com@gmail.com, sameo@linux.intel.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch

This patch was dropped because it was folded into drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch

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

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
drivers-misc-add-support-the-fsa9480-usb-switch.patch
lib-make-_tolower-public.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

