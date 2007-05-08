From: akpm@linux-foundation.org
Subject: - apple-smc-driver-hardware-monitoring-and-control-cleanup.patch removed from -mm tree
Date: Mon, 07 May 2007 21:48:33 -0700
Message-ID: <200705080448.l484mXD1013747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967718AbXEHEss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 00:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dtor@mail.ru, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     make drivers/hwmon/applesmc.c:backlight_work static
has been removed from the -mm tree.  Its filename was
     apple-smc-driver-hardware-monitoring-and-control-cleanup.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: make drivers/hwmon/applesmc.c:backlight_work static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-cleanup drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-cleanup
+++ a/drivers/hwmon/applesmc.c
@@ -742,7 +742,7 @@ static void applesmc_backlight_set(struc
 	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
 	mutex_unlock(&applesmc_lock);
 }
-DECLARE_WORK(backlight_work, &applesmc_backlight_set);
+static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
 
 static void applesmc_brightness_set(struct led_classdev *led_cdev,
 						enum led_brightness value)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
