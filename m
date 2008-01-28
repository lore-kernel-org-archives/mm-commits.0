From: akpm@linux-foundation.org
Subject: + atari-falcon-ide-add-missing-hwif-variable.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:16:40 -0800
Message-ID: <200801280517.m0S5HZIE013458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYA1FR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, bzolnier@gmail.com, sshtylyov@ru.mvista.com


The patch titled
     Atari Falcon IDE: Add missing hwif variable
has been added to the -mm tree.  Its filename is
     atari-falcon-ide-add-missing-hwif-variable.patch

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
Subject: Atari Falcon IDE: Add missing hwif variable
From: Geert Uytterhoeven <geert@linux-m68k.org>

Commit cbb010c180294a5242a7681555c28737d9dd26ab

    ide: drop 'initializing' argument from ide_register_hw()

    * Rename init_hwif_data() to ide_init_port_data() and export it.

    * For all users of ide_register_hw() with 'initializing' argument set
      hwif->present and hwif->hold are always zero so convert these host
      drivers to use ide_find_port()+ide_init_port_data()+ide_init_port_hw()
      instead (also no need for init_hwif_default() call since the setup
      done by it gets over-ridden by ide_init_port_hw() call).

    * Drop 'initializing' argument from ide_register_hw().

introduced the usage of a hwif variable, but forgot to declare the actual
variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/legacy/falconide.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ide/legacy/falconide.c~atari-falcon-ide-add-missing-hwif-variable drivers/ide/legacy/falconide.c
--- a/drivers/ide/legacy/falconide.c~atari-falcon-ide-add-missing-hwif-variable
+++ a/drivers/ide/legacy/falconide.c
@@ -66,6 +66,7 @@ static int __init falconide_init(void)
 {
     if (MACH_IS_ATARI && ATARIHW_PRESENT(IDE)) {
 	hw_regs_t hw;
+	ide_hwif_t *hwif;
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
atari-falcon-ide-add-missing-hwif-variable.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
amiga-serial-driver-port_write_mutex-fixup.patch
atari-floppy-rename-disk_type-to-atari_disk_type.patch
pm2fb-big-endian-fix.patch
add-cmpxchg_local-to-m86k.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
