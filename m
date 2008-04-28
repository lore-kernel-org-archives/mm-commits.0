From: akpm@linux-foundation.org
Subject: - lxfb-disable-suspend-vt-switch-by-default.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:01 -0700
Message-ID: <200804282159.m3SLx1hh018538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965454AbYD1V7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: disable suspend VT switch by default
has been removed from the -mm tree.  Its filename was
     lxfb-disable-suspend-vt-switch-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: disable suspend VT switch by default
From: Andres Salomon <dilinger@queued.net>

By default disable VT switch, but allow it to be overridden via the
'vt_switch' module arg.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/lxfb.txt       |    2 ++
 drivers/video/geode/lxfb_core.c |    7 +++++++
 2 files changed, 9 insertions(+)

diff -puN Documentation/fb/lxfb.txt~lxfb-disable-suspend-vt-switch-by-default Documentation/fb/lxfb.txt
--- a/Documentation/fb/lxfb.txt~lxfb-disable-suspend-vt-switch-by-default
+++ a/Documentation/fb/lxfb.txt
@@ -45,6 +45,8 @@ Accepted options:
 mode_option	- specify the video mode.  Of the form
 		  <x>x<y>[-<bpp>][@<refresh>]
 vram		- size of video ram (normally auto-detected)
+vt_switch	- enable vt switching during suspend/resume.  The vt
+		  switch is slow, but harmless.
 
 --
 Andres Salomon <dilinger@debian.org>
diff -puN drivers/video/geode/lxfb_core.c~lxfb-disable-suspend-vt-switch-by-default drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-disable-suspend-vt-switch-by-default
+++ a/drivers/video/geode/lxfb_core.c
@@ -17,6 +17,7 @@
 #include <linux/console.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -28,6 +29,7 @@
 static char *mode_option;
 static int noclear, nopanel, nocrt;
 static int vram;
+static int vt_switch;
 
 /* Most of these modes are sorted in ascending order, but
  * since the first entry in this table is the "default" mode,
@@ -523,6 +525,8 @@ static int __init lxfb_probe(struct pci_
 	lxfb_check_var(&info->var, info);
 	lxfb_set_par(info);
 
+	pm_set_vt_switch(vt_switch);
+
 	if (register_framebuffer(info) < 0) {
 		ret = -EINVAL;
 		goto err;
@@ -648,5 +652,8 @@ MODULE_PARM_DESC(mode_option, "video mod
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram, "video memory size");
 
+module_param(vt_switch, int, 0);
+MODULE_PARM_DESC(vt_switch, "enable VT switch during suspend/resume");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode LX");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

