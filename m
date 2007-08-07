From: akpm@linux-foundation.org
Subject: + au88x0-mem-leak-fix-in-snd_vortex_create.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:29:45 -0700
Message-ID: <200708072029.l77KTj0E002457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758346AbXHGUaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, rene.herman@gmail.com


The patch titled
     au88x0: mem leak fix in snd_vortex_create()
has been added to the -mm tree.  Its filename is
     au88x0-mem-leak-fix-in-snd_vortex_create.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
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
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
