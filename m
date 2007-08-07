From: akpm@linux-foundation.org
Subject: + avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:14:24 -0700
Message-ID: <200708072214.l77MEOVc007509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936114AbXHGWOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     pnp: avoid a small unlikely memory leak in proc_read_escd()
has been added to the -mm tree.  Its filename is
     avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pnp: avoid a small unlikely memory leak in proc_read_escd()
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a small and unlikely memory leak in
drivers/pnp/pnpbios/proc.c::proc_read_escd().  It's inside a sanity check,
so it probably won't trigger often (if at all), however it *is* a potential
leak and it's easy to avoid, so let's just fix it :)

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/proc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/proc.c~avoid-a-small-unlikely-memory-leak-in-proc_read_escd drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~avoid-a-small-unlikely-memory-leak-in-proc_read_escd
+++ a/drivers/pnp/pnpbios/proc.c
@@ -94,8 +94,9 @@ static int proc_read_escd(char *buf, cha
 
 	/* sanity check */
 	if (escd_size > MAX_SANE_ESCD_SIZE) {
-		printk(KERN_ERR
-		       "PnPBIOS: proc_read_escd: ESCD size reported by BIOS read_escd call is too great\n");
+		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by"
+				" BIOS read_escd call is too great\n");
+		kfree(tmpbuf);
 		return -EFBIG;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

documentation-sysrq-description-of-h-slightly-inaccurate.patch
git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
