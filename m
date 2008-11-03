From: akpm@linux-foundation.org
Subject: + pci-fix-range-check-on-mmapped-sysfs-resource-files.patch added to -mm tree
Date: Mon, 03 Nov 2008 12:43:46 -0800
Message-ID: <200811032043.mA3KhkqW022212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbYKCUoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 15:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eswierk@aristanetworks.com, jbarnes@virtuousgeek.org


The patch titled
     pci: fix range check on mmapped sysfs resource files
has been added to the -mm tree.  Its filename is
     pci-fix-range-check-on-mmapped-sysfs-resource-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

pci-fix-range-check-on-mmapped-sysfs-resource-files.patch

