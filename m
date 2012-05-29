From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:54:37 -0700
Message-ID: <20120529215437.C8648A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44920 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2E2Vyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:54:39 -0400
Received: by qabg24 with SMTP id g24so296067qab.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:54:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.stein@systec-electronic.com, bryan.wu@canonical.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch

This patch was dropped because it was folded into drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix

revert unintentional rename of pca955x_ledsel()

Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix
+++ a/drivers/leds/leds-pca955x.c
@@ -133,7 +133,7 @@ static inline int pca95xx_num_led_regs(i
  * Return an LED selector register value based on an existing one, with
  * the appropriate 2-bit state value set for the given LED number (0-3).
  */
-static inline u8 pca955x_ledel(u8 oldval, int led_num, int state)
+static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
 {
 	return (oldval & (~(0x3 << (led_num << 1)))) |
 		((state & 0x3) << (led_num << 1));
@@ -213,13 +213,13 @@ static void pca955x_led_work(struct work
 
 	switch (pca955x_led->brightness) {
 	case LED_FULL:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_ON);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_ON);
 		break;
 	case LED_OFF:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_OFF);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_OFF);
 		break;
 	case LED_HALF:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK0);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK0);
 		break;
 	default:
 		/*
@@ -231,7 +231,7 @@ static void pca955x_led_work(struct work
 		 */
 		pca955x_write_pwm(pca955x->client, 1,
 				255 - pca955x_led->brightness);
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK1);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK1);
 		break;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch
backlight-add-lm3533-backlight-driver.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch
leds-led-module-for-da9052-53-pmic-v2.patch
leds-heartbeat-stop-on-shutdown.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

