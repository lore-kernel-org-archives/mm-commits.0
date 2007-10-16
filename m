From: akpm@linux-foundation.org
Subject: - fbcon-logo-disable-logo-at-boot.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:58 -0700
Message-ID: <200710162044.l9GKiwjU016212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935912AbXJPVK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: logo: disable logo at boot
has been removed from the -mm tree.  Its filename was
     fbcon-logo-disable-logo-at-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: logo: disable logo at boot
From: Randy Dunlap <rdunlap@xenotime.net>

Add logo.nologo kernel boot option to disable the logo in order to provide
more screen space for kernel messages; especially useful when debugging and
screen space is more critical.

newport_con driver changes are untested.

[akpm@linux-foundation.org: cleanups, coding-style fixes]
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 drivers/video/console/newport_con.c |   20 ++++++++++++++------
 drivers/video/logo/logo.c           |    7 +++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~fbcon-logo-disable-logo-at-boot Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~fbcon-logo-disable-logo-at-boot
+++ a/Documentation/kernel-parameters.txt
@@ -911,6 +911,11 @@ and is between 256 and 4096 characters. 
 			n must be a power of two.  The default size
 			is set in the kernel config file.
 
+	logo.nologo	[FB] Disables display of the built-in Linux logo.
+			This may be used to provide more screen space for
+			kernel log messages and is useful when debugging
+			kernel boot problems.
+
 	lp=0		[LP]	Specify parallel ports to use, e.g,
 	lp=port[,port...]	lp=none,parport0 (lp0 not configured, lp1 uses
 	lp=reset		first parallel port). 'lp=0' disables the
diff -puN drivers/video/console/newport_con.c~fbcon-logo-disable-logo-at-boot drivers/video/console/newport_con.c
--- a/drivers/video/console/newport_con.c~fbcon-logo-disable-logo-at-boot
+++ a/drivers/video/console/newport_con.c
@@ -98,14 +98,19 @@ static inline void newport_init_cmap(voi
 	}
 }
 
-static void newport_show_logo(void)
+static struct linux_logo *newport_show_logo(void)
 {
 #ifdef CONFIG_LOGO_SGI_CLUT224
 	const struct linux_logo *logo = fb_find_logo(8);
-	const unsigned char *clut = logo->clut;
-	const unsigned char *data = logo->data;
+	const unsigned char *clut;
+	const unsigned char *data;
 	unsigned long i;
 
+	if (!logo)
+		return NULL;
+	*clut = logo->clut;
+	*data = logo->data;
+
 	for (i = 0; i < logo->clutsize; i++) {
 		newport_bfwait(npregs);
 		newport_cmap_setaddr(npregs, i + 0x20);
@@ -123,6 +128,8 @@ static void newport_show_logo(void)
 
 	for (i = 0; i < logo->width*logo->height; i++)
 		npregs->go.hostrw0 = *data++ << 24;
+
+	return logo;
 #endif /* CONFIG_LOGO_SGI_CLUT224 */
 }
 
@@ -465,9 +472,10 @@ static int newport_switch(struct vc_data
 	npregs->cset.topscan = 0x3ff;
 
 	if (!logo_drawn) {
-		newport_show_logo();
-		logo_drawn = 1;
-		logo_active = 1;
+		if (newport_show_logo()) {
+			logo_drawn = 1;
+			logo_active = 1;
+		}
 	}
 
 	return 1;
diff -puN drivers/video/logo/logo.c~fbcon-logo-disable-logo-at-boot drivers/video/logo/logo.c
--- a/drivers/video/logo/logo.c~fbcon-logo-disable-logo-at-boot
+++ a/drivers/video/logo/logo.c
@@ -34,6 +34,10 @@ extern const struct linux_logo logo_supe
 extern const struct linux_logo logo_superh_clut224;
 extern const struct linux_logo logo_m32r_clut224;
 
+static int nologo;
+module_param(nologo, bool, 0);
+MODULE_PARM_DESC(nologo, "Disables startup logo");
+
 /* logo's are marked __initdata. Use __init_refok to tell
  * modpost that it is intended that this function uses data
  * marked __initdata.
@@ -42,6 +46,9 @@ const struct linux_logo * __init_refok f
 {
 	const struct linux_logo *logo = NULL;
 
+	if (nologo)
+		return NULL;
+
 	if (depth >= 1) {
 #ifdef CONFIG_LOGO_LINUX_MONO
 		/* Generic Linux logo */
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
ufs-implement-show_options.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
fix-make-htmldocs-build-break.patch
add-section-ids-to-documentation-docbook-filesystemstmpl.patch
