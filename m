From: akpm@linux-foundation.org
Subject: [folded] drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:49:26 -0700
Message-ID: <20120529214926.95BC8A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:35222 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2E2Vte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:49:34 -0400
Received: by faaa25 with SMTP id a25so263066faa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:49:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, hartleys@visionengravers.com, hsweeten@visionengravers.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch

This patch was dropped because it was folded into drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix

Fix resulting build error

drivers/video/backlight/apple_bl.c:228: error: redefinition of 'apple_bl_register'
include/linux/apple_bl.h:15: note: previous definition of 'apple_bl_register' was here
drivers/video/backlight/apple_bl.c:237: error: redefinition of 'apple_bl_unregister'
include/linux/apple_bl.h:20: note: previous definition of 'apple_bl_unregister' was here

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/apple_bl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/apple_bl.h~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix include/linux/apple_bl.h
--- a/include/linux/apple_bl.h~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix
+++ a/include/linux/apple_bl.h
@@ -5,7 +5,7 @@
 #ifndef _LINUX_APPLE_BL_H
 #define _LINUX_APPLE_BL_H
 
-#ifdef CONFIG_BACKLIGHT_APPLE
+#if defined(CONFIG_BACKLIGHT_APPLE) || defined(CONFIG_BACKLIGHT_APPLE_MODULE)
 
 extern int apple_bl_register(void);
 extern void apple_bl_unregister(void);
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
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

