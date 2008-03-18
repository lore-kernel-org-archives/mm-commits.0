From: akpm@linux-foundation.org
Subject: - devres-implement-pcim_iomap_regions_request_all.patch removed from -mm tree
Date: Tue, 18 Mar 2008 16:42:42 -0700
Message-ID: <200803182352.m2INqQE6022284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757819AbYCSTlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     devres: implement pcim_iomap_regions_request_all()
has been removed from the -mm tree.  Its filename was
     devres-implement-pcim_iomap_regions_request_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devres: implement pcim_iomap_regions_request_all()
From: Tejun Heo <htejun@gmail.com>

Some drivers need to reserve all PCI BARs to prevent other drivers misusing
unoccupied BARs.  pcim_iomap_regions_request_all() requests all BARs and iomap
specified BARs.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN lib/devres.c~devres-implement-pcim_iomap_regions_request_all lib/devres.c
--- a/lib/devres.c~devres-implement-pcim_iomap_regions_request_all
+++ a/lib/devres.c
@@ -298,6 +298,31 @@ int pcim_iomap_regions(struct pci_dev *p
 EXPORT_SYMBOL(pcim_iomap_regions);
 
 /**
+ * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
+ * @pdev: PCI device to map IO resources for
+ * @mask: Mask of BARs to iomap
+ * @name: Name used when requesting regions
+ *
+ * Request all PCI BARs and iomap regions specified by @mask.
+ */
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+				   const char *name)
+{
+	int request_mask = ((1 << 6) - 1) & ~mask;
+	int rc;
+
+	rc = pci_request_selected_regions(pdev, request_mask, name);
+	if (rc)
+		return rc;
+
+	rc = pcim_iomap_regions(pdev, mask, name);
+	if (rc)
+		pci_release_selected_regions(pdev, request_mask);
+	return rc;
+}
+EXPORT_SYMBOL(pcim_iomap_regions_request_all);
+
+/**
  * pcim_iounmap_regions - Unmap and release PCI BARs
  * @pdev: PCI device to map IO resources for
  * @mask: Mask of BARs to unmap and release
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
devres-implement-pcim_iomap_regions_request_all.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
add-macros-similar-to-min-max-min_t-max_t.patch
ata-remove-fit-macro.patch

