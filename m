From: akpm@linux-foundation.org
Subject: + powerpc-ep8248e-fix-compile-problem-if-config_fs_enet.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:23:23 -0700
Message-ID: <200807162023.m6GKNNYc011242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbYGPUX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, benh@kernel.crashing.org


The patch titled
     powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
has been added to the -mm tree.  Its filename is
     powerpc-ep8248e-fix-compile-problem-if-config_fs_enet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
From: Kumar Gala <galak@kernel.crashing.org>

If we don't enable FS_ENET we get build issues:

arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/82xx/ep8248e.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/powerpc/platforms/82xx/ep8248e.c~powerpc-ep8248e-fix-compile-problem-if-config_fs_enet arch/powerpc/platforms/82xx/ep8248e.c
--- a/arch/powerpc/platforms/82xx/ep8248e.c~powerpc-ep8248e-fix-compile-problem-if-config_fs_enet
+++ a/arch/powerpc/platforms/82xx/ep8248e.c
@@ -59,6 +59,7 @@ static void __init ep8248e_pic_init(void
 	of_node_put(np);
 }
 
+#ifdef CONFIG_FS_ENET_MDIO_FCC
 static void ep8248e_set_mdc(struct mdiobb_ctrl *ctrl, int level)
 {
 	if (level)
@@ -164,6 +165,7 @@ static struct of_platform_driver ep8248e
 	.probe = ep8248e_mdio_probe,
 	.remove = ep8248e_mdio_remove,
 };
+#endif
 
 struct cpm_pin {
 	int port, pin, flags;
@@ -296,7 +298,9 @@ static  __initdata struct of_device_id o
 static int __init declare_of_platform_devices(void)
 {
 	of_platform_bus_probe(NULL, of_bus_ids, NULL);
+#ifdef CONFIG_FS_ENET_MDIO_FCC
 	of_register_platform_driver(&ep8248e_mdio_driver);
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

linux-next.patch
powerpc-ep8248e-fix-compile-problem-if-config_fs_enet.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch
resource-use-new-resource-type-changes.patch

