From: akpm@linux-foundation.org
Subject: + mpt-fusion-fix-two-potential-mem-leaks.patch added to -mm tree
Date: Wed, 01 Aug 2007 17:27:11 -0700
Message-ID: <200708020027.l720RBMY024933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903AbXHBA1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 20:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, Eric.Moore@lsil.com


The patch titled
     mpt-fusion: fix two potential mem leaks
has been added to the -mm tree.  Its filename is
     mpt-fusion-fix-two-potential-mem-leaks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mpt-fusion: fix two potential mem leaks
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted two potential memory leaks in
drivers/message/fusion/mptbase.c::mpt_attach().

There are two returns that may leak the storage allocated for 'ioc'
(sizeof(MPT_ADAPTER) bytes).

A simple fix would be to simply add two kfree() calls before the return
statements, but a better fix (that this patch implements) is to reorder the
code so that if we hit the first return condition we don't have to do the
allocation at all and then just add a kfree() call for the second case.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks
+++ a/drivers/message/fusion/mptbase.c
@@ -1408,18 +1408,18 @@ mpt_attach(struct pci_dev *pdev, const s
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
+	if (pci_enable_device(pdev))
+		return r;
+
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-
 	ioc->debug_level = mpt_debug_level;
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
-	if (pci_enable_device(pdev))
-		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
@@ -1428,6 +1428,7 @@ mpt_attach(struct pci_dev *pdev, const s
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
git-ia64.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
mips-remove-some-duplicate-includes.patch
git-mtd.patch
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
