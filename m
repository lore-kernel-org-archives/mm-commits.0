From: akpm@linux-foundation.org
Subject: - au88x0-mem-leak-fix-in-snd_vortex_create.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:45 -0700
Message-ID: <200708081907.l78J7jci025792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760649AbXHHTIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     au88x0: mem leak fix in snd_vortex_create()
has been removed from the -mm tree.  Its filename was
     au88x0-mem-leak-fix-in-snd_vortex_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: au88x0: mem leak fix in snd_vortex_create()
From: Jesper Juhl <jesper.juhl@gmail.com>

In sound/pci/au88x0/au88x0.c::snd_vortex_create() :
The Coverity checker found that if we allocate storage for 'chip'
but then leave via the  regions_out:  label, then we end up leaking
the storage allocated for 'chip'.
I believe simply freeing 'chip' before the "return err;" line is
all we need to fix this, but please double-check me :)

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/au88x0/au88x0.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN sound/pci/au88x0/au88x0.c~au88x0-mem-leak-fix-in-snd_vortex_create sound/pci/au88x0/au88x0.c
--- a/sound/pci/au88x0/au88x0.c~au88x0-mem-leak-fix-in-snd_vortex_create
+++ a/sound/pci/au88x0/au88x0.c
@@ -232,6 +232,7 @@ snd_vortex_create(struct snd_card *card,
 	pci_disable_device(chip->pci_dev);
 	//FIXME: this not the right place to unregister the gameport
 	vortex_gameport_unregister(chip);
+	kfree(chip);
 	return err;
 }
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

documentation-sysrq-description-of-h-slightly-inaccurate.patch
git-acpi.patch
git-alsa.patch
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
