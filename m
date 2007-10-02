From: akpm@linux-foundation.org
Subject: - fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:24:28 -0700
Message-ID: <200710022224.l92MOSlH025643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbXJBWYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
has been removed from the -mm tree.  Its filename was
     fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker noticed that we have a potential NULL pointer
deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
This patch handles it by adding the same test against NULL that is
used elsewhere in the same function.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic7xxx_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6557,7 +6557,8 @@ ahc_print_register(ahc_reg_parse_entry_t
 	printed = printf("%s[0x%x]", name, value);
 	if (table == NULL) {
 		printed += printf(" ");
-		*cur_column += printed;
+		if (cur_column != NULL)
+			*cur_column += printed;
 		return (printed);
 	}
 	printed_mask = 0;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-cifs.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-net.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-nfs.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
uml-remove-unneeded-void-cast.patch
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
fbdev-update-documentation-fb-00-index.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
