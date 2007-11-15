From: akpm@linux-foundation.org
Subject: - gbefb-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:42 -0800
Message-ID: <200711152110.lAFLAg04015680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932528AbXKOVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     gbefb: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     gbefb-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gbefb: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Make 'default_mode' and 'default_var' be __initdata.
Fixes these section warnings:

WARNING: vmlinux.o(.data+0x128e0): Section mismatch: reference to .init.data:default_mode_CRT (between 'default_mode' and 'default_var')
WARNING: vmlinux.o(.data+0x128e4): Section mismatch: reference to .init.data:default_var_CRT (between 'default_var' and 'dev_attr_size')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-fix-section-mismatch-warnings drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-fix-section-mismatch-warnings
+++ a/drivers/video/gbefb.c
@@ -183,8 +183,8 @@ static struct fb_videomode default_mode_
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-struct fb_videomode *default_mode = &default_mode_CRT;
-struct fb_var_screeninfo *default_var = &default_var_CRT;
+struct fb_videomode *default_mode __initdata = &default_mode_CRT;
+struct fb_var_screeninfo *default_var __initdata = &default_var_CRT;
 
 static int flat_panel_enabled = 0;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
