From: akpm@linux-foundation.org
Subject: + cyclades-avoid-label-defined-but-not-used-warning.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:32:53 -0700
Message-ID: <200709120332.l8C3Wrhs014219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756737AbXILDc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, jirislaby@gmail.com


The patch titled
     Cyclades: Avoid label defined but not used warning
has been added to the -mm tree.  Its filename is
     cyclades-avoid-label-defined-but-not-used-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cyclades: Avoid label defined but not used warning
From: Jesper Juhl <jesper.juhl@gmail.com>

   CC      drivers/char/cyclades.o
 drivers/char/cyclades.c: In function 'cy_init':
 drivers/char/cyclades.c:5488: warning: label 'err_unr' defined but not used

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-avoid-label-defined-but-not-used-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-avoid-label-defined-but-not-used-warning
+++ a/drivers/char/cyclades.c
@@ -5362,13 +5362,13 @@ static int __init cy_init(void)
 #ifdef CONFIG_PCI
 	/* look for pci boards */
 	retval = pci_register_driver(&cy_pci_driver);
-	if (retval && !nboards)
-		goto err_unr;
+	if (retval && !nboards) {
+		tty_unregister_driver(cy_serial_driver);
+		goto err_frtty;
+	}
 #endif
 
 	return 0;
-err_unr:
-	tty_unregister_driver(cy_serial_driver);
 err_frtty:
 	put_tty_driver(cy_serial_driver);
 err:
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
