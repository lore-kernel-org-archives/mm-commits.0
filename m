From: akpm@linux-foundation.org
Subject: - recognize-video=gx1fb-option.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:40 -0800
Message-ID: <200702122249.l1CMnePH014148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030382AbXBLWtv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@pol.net, jordan.crouse@amd.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Recognize video=gx1fb:... option
has been removed from the -mm tree.  Its filename was
     recognize-video=gx1fb-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Recognize video=gx1fb:... option
From: Alexey Dobriyan <adobriyan@gmail.com>

Juergen Beisert reported that the following option doesn't work for him

	video=gx1fb:1024x768-16@60

though sisfb was able to parse similar option correctly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gx1fb_core.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/video/geode/gx1fb_core.c~recognize-video=gx1fb-option drivers/video/geode/gx1fb_core.c
--- a/drivers/video/geode/gx1fb_core.c~recognize-video=gx1fb-option
+++ a/drivers/video/geode/gx1fb_core.c
@@ -401,6 +401,30 @@ static void gx1fb_remove(struct pci_dev 
 	framebuffer_release(info);
 }
 
+#ifndef MODULE
+static void __init gx1fb_setup(char *options)
+{
+	char *this_opt;
+
+	if (!options || !*options)
+		return;
+
+	while ((this_opt = strsep(&options, ","))) {
+		if (!*this_opt)
+			continue;
+
+		if (!strncmp(this_opt, "mode:", 5))
+			strlcpy(mode_option, this_opt + 5, sizeof(mode_option));
+		else if (!strncmp(this_opt, "crt:", 4))
+			crt_option = !!simple_strtoul(this_opt + 4, NULL, 0);
+		else if (!strncmp(this_opt, "panel:", 6))
+			strlcpy(panel_option, this_opt + 6, sizeof(panel_option));
+		else
+			strlcpy(mode_option, this_opt, sizeof(mode_option));
+	}
+}
+#endif
+
 static struct pci_device_id gx1fb_id_table[] = {
 	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_VIDEO,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
@@ -420,8 +444,11 @@ static struct pci_driver gx1fb_driver = 
 static int __init gx1fb_init(void)
 {
 #ifndef MODULE
-	if (fb_get_options("gx1fb", NULL))
+	char *option = NULL;
+
+	if (fb_get_options("gx1fb", &option))
 		return -ENODEV;
+	gx1fb_setup(option);
 #endif
 	return pci_register_driver(&gx1fb_driver);
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
