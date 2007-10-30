From: akpm@linux-foundation.org
Subject: + gbefb-fix-section-mismatch-warnings.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:32:54 -0700
Message-ID: <200710302032.l9UKWsNf026800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXJ3Udm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     gbefb: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     gbefb-fix-section-mismatch-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
