From: akpm@linux-foundation.org
Subject: + vt-fix-warnings-in-selectionh.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:23 -0700
Message-ID: <200708272223.l7RMNNk6031646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757527AbXH0WXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@gmail.com


The patch titled
     vt: Fix warnings in selection.h
has been added to the -mm tree.  Its filename is
     vt-fix-warnings-in-selectionh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: Fix warnings in selection.h
From: Ralf Baechle <ralf@linux-mips.org>

<linux/selection.h> assumes that struct tty_struct has previously been
included.  If not, this pile of warnings will result:

  CC [M]  drivers/video/console/newport_con.o
In file included from drivers/video/console/newport_con.c:18:
include/linux/selection.h:16: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:16: warning: its scope is only this definition or decl
aration, which is probably not what you want
include/linux/selection.h:17: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:20: warning: 'struct tty_struct' declared inside param
eter list

Fixed by adding a forward declaration of struct tty_struct.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/selection.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/selection.h~vt-fix-warnings-in-selectionh include/linux/selection.h
--- a/include/linux/selection.h~vt-fix-warnings-in-selectionh
+++ a/include/linux/selection.h
@@ -13,6 +13,7 @@
 struct tty_struct;
 
 extern struct vc_data *sel_cons;
+struct tty_struct;
 
 extern void clear_selection(void);
 extern int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
add-maintainers-entry-for-ioc3-serial-driver.patch
fix-modpost-warning-in-serial-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
pci-section-warning-fix.patch
pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
