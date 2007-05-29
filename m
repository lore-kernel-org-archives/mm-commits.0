From: akpm@linux-foundation.org
Subject: + msi-fix-the-ordering-of-msix-irqs.patch added to -mm tree
Date: Tue, 29 May 2007 13:03:13 -0700
Message-ID: <200705292003.l4TK3Dl1010226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765471AbXE2UDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, greg@kroah.com, michael@ellerman.id.au, mikem@beardog.cca.cpqcorp.net


The patch titled
     msi: fix the ordering of msix irqs
has been added to the -mm tree.  Its filename is
     msi-fix-the-ordering-of-msix-irqs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msi: fix the ordering of msix irqs
From: "Eric W. Biederman" <ebiederm@xmission.com>

"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:

Found what seems the problem with our vectors being listed backward.  In
drivers/pci/msi.c we should be using list_add_tail rather than list_add to
preserve the ordering across various kernels.  Please consider this for
inclusion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Screwed-up-by: Michael Ellerman <michael@ellerman.id.au>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/msi.c~msi-fix-the-ordering-of-msix-irqs drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-fix-the-ordering-of-msix-irqs
+++ a/drivers/pci/msi.c
@@ -333,7 +333,7 @@ static int msi_capability_init(struct pc
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
 	}
-	list_add(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
 	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
@@ -404,7 +404,7 @@ static int msix_capability_init(struct p
 		entry->dev = dev;
 		entry->mask_base = base;
 
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
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
