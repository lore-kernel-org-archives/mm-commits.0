From: akpm@linux-foundation.org
Subject: + msi-mask-the-msix-vector-before-we-unmap-it.patch added to -mm tree
Date: Tue, 29 May 2007 13:03:15 -0700
Message-ID: <200705292003.l4TK3Fjj010230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764907AbXE2UDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, chase.maupin@hp.com, greg@kroah.com, mike.miller@hp.com


The patch titled
     msi: mask the msix vector before we unmap it
has been added to the -mm tree.  Its filename is
     msi-mask-the-msix-vector-before-we-unmap-it.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msi: mask the msix vector before we unmap it
From: "Eric W. Biederman" <ebiederm@xmission.com>

With these two lines in the reverse order the drives/block/ccis.c was
oopsing in msi_free_irqs.  Silly us calling writel on an area after
we unmap it.

BUG: unable to handle kernel paging request at virtual address f8b2200c
 printing eip:
c01e9cc7
*pdpt = 0000000000003001
*pde = 0000000037e48067
*pte = 0000000000000000
Oops: 0002 [#1]
SMP
Modules linked in: cciss ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core
sunrpc loop dm_multipath button battery asus_acpi ac tg3 floppy sg dm_snapshot
dm_zero dm_mirror ext3 jbd dm_mod ata_piix libata mptsas scsi_transport_sas
mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod
CPU:    1
EIP:    0060:[<c01e9cc7>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc2-gd2579053 #1)
EIP is at msi_free_irqs+0x81/0xbe
eax: f8b22000   ebx: f71f3180   ecx: f7fff280   edx: c1886eb8
esi: f7c4e800   edi: f7c4ec48   ebp: 00000002   esp: f5a0dec8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 5286, ti=f5a0d000 task=c47d2550 task.ti=f5a0d000)
Stack: 00000002 f8b72294 00000400 f8b69ca7 f8b6bc6c 00000002 00000000 00000000
       00000000 00000000 00000000 f5a997f4 f8b69d61 f7c5a4b0 f7c4e848 f7c4e848
       f7c4e800 f7c4e800 f8b72294 f7c4e848 f8b72294 c01e3cdf f7c4e848 c024c469
Call Trace:
 [<f8b69ca7>] cciss_shutdown+0xae/0xc3 [cciss]
 [<f8b69d61>] cciss_remove_one+0xa5/0x178 [cciss]
 [<c01e3cdf>] pci_device_remove+0x16/0x35
 [<c024c469>] __device_release_driver+0x71/0x8e
 [<c024c56e>] driver_detach+0xa0/0xde
 [<c024bc5c>] bus_remove_driver+0x27/0x41
 [<c01e3ef3>] pci_unregister_driver+0xb/0x13
 [<f8b6a343>] cciss_cleanup+0xf/0x51 [cciss]
 [<c0139ced>] sys_delete_module+0x110/0x135
 [<c0104c7a>] sysenter_past_esp+0x5f/0x85

Here's a patch that just reverses the 2 lines of code as Eric suggests. Please
consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Chase Maupin <chase.maupin@hp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pci/msi.c~msi-mask-the-msix-vector-before-we-unmap-it drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-mask-the-msix-vector-before-we-unmap-it
+++ a/drivers/pci/msi.c
@@ -558,12 +558,12 @@ static int msi_free_irqs(struct pci_dev*
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
-			if (list_is_last(&entry->list, &dev->msi_list))
-				iounmap(entry->mask_base);
-
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+
+			if (list_is_last(&entry->list, &dev->msi_list))
+				iounmap(entry->mask_base);
 		}
 		list_del(&entry->list);
 		kfree(entry);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
msi-fix-the-ordering-of-msix-irqs.patch
msi-mask-the-msix-vector-before-we-unmap-it.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
