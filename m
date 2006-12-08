From: akpm@osdl.org
Subject: - various-fbdev-files-mark-structs-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:07:27 -0800
Message-ID: <200612080907.kB897R1e014450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425269AbWLHJHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:07:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, deller@gmx.de, mm-commits@vger.kernel.org


The patch titled
     various-fbdev-files-mark-structs-fix
has been removed from the -mm tree.  Its filename was
     various-fbdev-files-mark-structs-fix.patch

This patch was dropped because it was folded into various-fbdev-files-mark-structs.patch

------------------------------------------------------
Subject: various-fbdev-files-mark-structs-fix
From: Andrew Morton <akpm@osdl.org>

drivers/video/fbsysfs.c: In function 'fb_init_device':
drivers/video/fbsysfs.c:517: warning: passing argument 2 of 'device_create_file' discards qualifiers from pointer target type
drivers/video/fbsysfs.c:525: warning: passing argument 2 of 'device_remove_file' discards qualifiers from pointer target type
drivers/video/fbsysfs.c: In function 'fb_cleanup_device':
drivers/video/fbsysfs.c:538: warning: passing argument 2 of 'device_remove_file' discards qualifiers from pointer target type

Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/fbsysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbsysfs.c~various-fbdev-files-mark-structs-fix drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~various-fbdev-files-mark-structs-fix
+++ a/drivers/video/fbsysfs.c
@@ -487,7 +487,7 @@ static ssize_t show_bl_curve(struct devi
 /* When cmap is added back in it should be a binary attribute
  * not a text one. Consideration should also be given to converting
  * fbdev to use configfs instead of sysfs */
-static const struct device_attribute device_attrs[] = {
+static struct device_attribute device_attrs[] = {
 	__ATTR(bits_per_pixel, S_IRUGO|S_IWUSR, show_bpp, store_bpp),
 	__ATTR(blank, S_IRUGO|S_IWUSR, show_blank, store_blank),
 	__ATTR(console, S_IRUGO|S_IWUSR, show_console, store_console),
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

