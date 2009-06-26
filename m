From: akpm@linux-foundation.org
Subject: + atyfb-fix-hp-omnibook-500-reboot-hang.patch added to -mm tree
Date: Fri, 26 Jun 2009 15:39:47 -0700
Message-ID: <200906262239.n5QMdlZp030826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZFZWkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 18:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, krzysztof.h1@poczta.fm, mpatocka@redhat.com


The patch titled
     atyfb: fix HP OmniBook 500 reboot hang
has been added to the -mm tree.  Its filename is
     atyfb-fix-hp-omnibook-500-reboot-hang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: fix HP OmniBook 500 reboot hang
From: Ville Syrjala <syrjala@sci.fi>

Apparently HP OmniBook 500's BIOS doesn't like the way atyfb reprograms
the hardware. The BIOS will simply hang after a reboot. Fix the problem
by restoring the hardware to it's original state on reboot.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb.h      |    2 
 drivers/video/aty/atyfb_base.c |   89 +++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 9 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-fix-hp-omnibook-500-reboot-hang drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-fix-hp-omnibook-500-reboot-hang
+++ a/drivers/video/aty/atyfb.h
@@ -187,6 +187,8 @@ struct atyfb_par {
 	int mtrr_reg;
 #endif
 	u32 mem_cntl;
+	struct crtc saved_crtc;
+	union aty_pll saved_pll;
 };
 
     /*
diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-hp-omnibook-500-reboot-hang drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-hp-omnibook-500-reboot-hang
+++ a/drivers/video/aty/atyfb_base.c
@@ -66,6 +66,8 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/backlight.h>
+#include <linux/reboot.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
@@ -249,8 +251,6 @@ static int aty_init(struct fb_info *info
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
 
-static struct crtc saved_crtc;
-static union aty_pll saved_pll;
 static void aty_get_crtc(const struct atyfb_par *par, struct crtc *crtc);
 
 static void aty_set_crtc(const struct atyfb_par *par, const struct crtc *crtc);
@@ -261,6 +261,8 @@ static void set_off_pitch(struct atyfb_p
 static int read_aty_sense(const struct atyfb_par *par);
 #endif
 
+static DEFINE_MUTEX(reboot_lock);
+static struct fb_info *reboot_info;
 
     /*
      *  Interface used by the world
@@ -2390,9 +2392,9 @@ static int __devinit aty_init(struct fb_
 #endif /* CONFIG_FB_ATY_CT */
 
 	/* save previous video mode */
-	aty_get_crtc(par, &saved_crtc);
+	aty_get_crtc(par, &par->saved_crtc);
 	if(par->pll_ops->get_pll)
-		par->pll_ops->get_pll(info, &saved_pll);
+		par->pll_ops->get_pll(info, &par->saved_pll);
 
 	par->mem_cntl = aty_ld_le32(MEM_CNTL, par);
 	gtb_memsize = M64_HAS(GTB_DSP);
@@ -2667,8 +2669,8 @@ static int __devinit aty_init(struct fb_
 
 aty_init_exit:
 	/* restore video mode */
-	aty_set_crtc(par, &saved_crtc);
-	par->pll_ops->set_pll(info, &saved_pll);
+	aty_set_crtc(par, &par->saved_crtc);
+	par->pll_ops->set_pll(info, &par->saved_pll);
 
 #ifdef CONFIG_MTRR
 	if (par->mtrr_reg >= 0) {
@@ -3502,6 +3504,11 @@ static int __devinit atyfb_pci_probe(str
 	par->mmap_map[1].prot_flag = _PAGE_E;
 #endif /* __sparc__ */
 
+	mutex_lock(&reboot_lock);
+	if (!reboot_info)
+		reboot_info = info;
+	mutex_unlock(&reboot_lock);
+
 	return 0;
 
 err_release_io:
@@ -3614,8 +3621,8 @@ static void __devexit atyfb_remove(struc
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 
 	/* restore video mode */
-	aty_set_crtc(par, &saved_crtc);
-	par->pll_ops->set_pll(info, &saved_pll);
+	aty_set_crtc(par, &par->saved_crtc);
+	par->pll_ops->set_pll(info, &par->saved_pll);
 
 	unregister_framebuffer(info);
 
@@ -3661,6 +3668,11 @@ static void __devexit atyfb_pci_remove(s
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 
+	mutex_lock(&reboot_lock);
+	if (reboot_info == info)
+		reboot_info = NULL;
+	mutex_unlock(&reboot_lock);
+
 	atyfb_remove(info);
 }
 
@@ -3808,6 +3820,56 @@ static int __init atyfb_setup(char *opti
 }
 #endif  /*  MODULE  */
 
+static int atyfb_reboot_notify(struct notifier_block *nb,
+			       unsigned long code, void *unused)
+{
+	struct atyfb_par *par;
+
+	if (code != SYS_RESTART)
+		return NOTIFY_DONE;
+
+	mutex_lock(&reboot_lock);
+
+	if (!reboot_info)
+		goto out;
+
+	if (!lock_fb_info(reboot_info))
+		goto out;
+
+	par = reboot_info->par;
+
+	/*
+	 * HP OmniBook 500's BIOS doesn't like the state of the
+	 * hardware after atyfb has been used. Restore the hardware
+	 * to the original state to allow successful reboots.
+	 */
+	aty_set_crtc(par, &par->saved_crtc);
+	par->pll_ops->set_pll(reboot_info, &par->saved_pll);
+
+	unlock_fb_info(reboot_info);
+ out:
+	mutex_unlock(&reboot_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block atyfb_reboot_notifier = {
+	.notifier_call = atyfb_reboot_notify,
+};
+
+static const struct dmi_system_id atyfb_reboot_ids[] = {
+	{
+		.ident = "HP OmniBook 500",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP OmniBook PC"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "HP OmniBook 500 FA"),
+		},
+	},
+
+	{ }
+};
+
 static int __init atyfb_init(void)
 {
     int err1 = 1, err2 = 1;
@@ -3826,11 +3888,20 @@ static int __init atyfb_init(void)
     err2 = atyfb_atari_probe();
 #endif
 
-    return (err1 && err2) ? -ENODEV : 0;
+    if (err1 && err2)
+	return -ENODEV;
+
+    if (dmi_check_system(atyfb_reboot_ids))
+	register_reboot_notifier(&atyfb_reboot_notifier);
+
+    return 0;
 }
 
 static void __exit atyfb_exit(void)
 {
+	if (dmi_check_system(atyfb_reboot_ids))
+		unregister_reboot_notifier(&atyfb_reboot_notifier);
+
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&atyfb_driver);
 #endif
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-hp-omnibook-500-reboot-hang.patch
atyfb-fix-alignment-for-block-writes.patch
atyfb-coding-style-cleanup.patch
platinumfb-misplaced-parenthesis.patch

