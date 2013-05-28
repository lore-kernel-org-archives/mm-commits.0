From: akpm@linux-foundation.org
Subject: +
 drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch added
 to -mm tree
Date: Tue, 28 May 2013 16:11:52 -0700
Message-ID: <51a539b8.XvW+cwDoLrR3CpAs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab3E1XLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.cz, airlied@linux.ie, jeffm@suse.com

Subject: + drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch added to -mm tree
To: jeffm@suse.com,airlied@linux.ie,jslaby@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:11:52 -0700


The patch titled
     Subject: drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO
has been added to the -mm tree.  Its filename is
     drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO

Commit 8116188fdef594 ("nouveau/acpi: hook up to the MXM method for mux
switching.") broke the build on non-x86 architectures due to the new
dependency on MXM and MXM being an x86 platform driver.

It built previously since the vga switcheroo registration routines were
zereod out on !X86.  The code was built in but unused.

This patch makes all of the DSM code depend on CONFIG_VGA_SWITCHEROO,
allowing it to build on non-x86 and shrinking the module size as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_acpi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/gpu/drm/nouveau/nouveau_acpi.c~drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo drivers/gpu/drm/nouveau/nouveau_acpi.c
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c~drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo
+++ a/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -46,6 +46,7 @@ bool nouveau_is_v1_dsm(void) {
 #define NOUVEAU_DSM_HAS_MUX 0x1
 #define NOUVEAU_DSM_HAS_OPT 0x2
 
+#ifdef CONFIG_VGA_SWITCHEROO
 static const char nouveau_dsm_muid[] = {
 	0xA0, 0xA0, 0x95, 0x9D, 0x60, 0x00, 0x48, 0x4D,
 	0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4,
@@ -337,6 +338,10 @@ void nouveau_unregister_dsm_handler(void
 	if (nouveau_dsm_priv.optimus_detected || nouveau_dsm_priv.dsm_detected)
 		vga_switcheroo_unregister_handler();
 }
+#else
+void nouveau_register_dsm_handler(void) {}
+void nouveau_unregister_dsm_handler(void) {}
+#endif
 
 /* retrieve the ROM in 4k blocks */
 static int nouveau_rom_call(acpi_handle rom_handle, uint8_t *bios,
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch
reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch

