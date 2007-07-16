From: akpm@linux-foundation.org
Subject: - compat32-ignore-the-loop_clr_fd-ioctl.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:53 -0700
Message-ID: <200707162059.l6GKxrT0002463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760722AbXGPVNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     compat32: ignore the LOOP_CLR_FD ioctl
has been removed from the -mm tree.  Its filename was
     compat32-ignore-the-loop_clr_fd-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: compat32: ignore the LOOP_CLR_FD ioctl
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

compat32: Ignore the LOOP_CLR_FD ioctl for the loop block device, to kill an
annoying kernel message when e.g. busybox umount is used.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/compat_ioctl.c~compat32-ignore-the-loop_clr_fd-ioctl fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat32-ignore-the-loop_clr_fd-ioctl
+++ a/fs/compat_ioctl.c
@@ -63,6 +63,7 @@
 #include <linux/wireless.h>
 #include <linux/atalk.h>
 #include <linux/blktrace_api.h>
+#include <linux/loop.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -3489,6 +3490,9 @@ HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_tr
 
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
+
+/* loop */
+IGNORE_IOCTL(LOOP_CLR_FD)
 };
 
 #define IOCTL_HASHSIZE 256
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
git-powerpc.patch
fbdev-extract-fb_show_logo_line.patch
fbdev-add-fb_append_extra_logo.patch
fbdev-spe-helper-penguin-logo.patch
cell-draw-spe-helper-penguin-logos.patch
