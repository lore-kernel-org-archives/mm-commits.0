From: akpm@linux-foundation.org
Subject: - serio-fix-modpost-warning.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:43:00 -0700
Message-ID: <200709070043.l870h0q6016080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964858AbXIGAsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     SERIO: Fix modpost warning
has been removed from the -mm tree.  Its filename was
     serio-fix-modpost-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SERIO: Fix modpost warning
From: Ralf Baechle <ralf@linux-mips.org>

i8042_unregister_ports's only caller i8042_remove is a __devexit function
so make it __devexit too.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/serio/i8042.c~serio-fix-modpost-warning drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~serio-fix-modpost-warning
+++ a/drivers/input/serio/i8042.c
@@ -1044,7 +1044,7 @@ static void __devinit i8042_register_por
 	}
 }
 
-static void __devinit i8042_unregister_ports(void)
+static void __devexit i8042_unregister_ports(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

bcm1480-serial-build-fix.patch
git-input.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
