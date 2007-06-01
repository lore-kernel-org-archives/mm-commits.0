From: akpm@linux-foundation.org
Subject: - msi-fix-the-ordering-of-msix-irqs.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:05 -0700
Message-ID: <200706011747.l51Hl4IU015105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761056AbXFARrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, greg@kroah.com, michael@ellerman.id.au, mikem@beardog.cca.cpqcorp.net, mm-commits@vger.kernel.org


The patch titled
     msi: fix the ordering of msix irqs
has been removed from the -mm tree.  Its filename was
     msi-fix-the-ordering-of-msix-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
rd-remove-ramdisk_set_page_dirty.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
buffer-kill-old-incorrect-comment.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
