From: akpm@linux-foundation.org
Subject: - pci-fix-range-check-on-mmapped-sysfs-resource-files.patch removed from -mm tree
Date: Wed, 05 Nov 2008 11:26:40 -0800
Message-ID: <200811051926.mA5JQe1e010228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756420AbYKET0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 14:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eswierk@aristanetworks.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: fix range check on mmapped sysfs resource files
has been removed from the -mm tree.  Its filename was
     pci-fix-range-check-on-mmapped-sysfs-resource-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix range check on mmapped sysfs resource files
From: "Ed Swierk" <eswierk@aristanetworks.com>

pci_mmap_fits() returns the wrong answer if the sysfs resource file size
is not a multiple of the page size.  vm_end and vm_start are already
page-aligned, so size - start < nr, causing mmap() to return EINVAL.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pci-sysfs.c~pci-fix-range-check-on-mmapped-sysfs-resource-files drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~pci-fix-range-check-on-mmapped-sysfs-resource-files
+++ a/drivers/pci/pci-sysfs.c
@@ -575,7 +575,7 @@ int pci_mmap_fits(struct pci_dev *pdev, 
 
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
-	size = pci_resource_len(pdev, resno) >> PAGE_SHIFT;
+	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
 	if (start < size && size - start >= nr)
 		return 1;
 	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
_

Patches currently in -mm which might be from eswierk@aristanetworks.com are

linux-next.patch

