From: akpm@linux-foundation.org
Subject: - doc-fix-dma-api-function-parameters.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:44 -0700
Message-ID: <200804300543.m3U5hiC2029338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYD3GLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     doc: fix DMA-API function parameters
has been removed from the -mm tree.  Its filename was
     doc-fix-dma-api-function-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: fix DMA-API function parameters
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel bugzilla #10388.

DMA-API.txt has wrong argument type for some functions.  It uses struct device
but should use struct pci_dev.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DMA-API.txt~doc-fix-dma-api-function-parameters Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~doc-fix-dma-api-function-parameters
+++ a/Documentation/DMA-API.txt
@@ -145,7 +145,7 @@ Part Ic - DMA addressing limitations
 int
 dma_supported(struct device *dev, u64 mask)
 int
-pci_dma_supported(struct device *dev, u64 mask)
+pci_dma_supported(struct pci_dev *hwdev, u64 mask)
 
 Checks to see if the device can support DMA to the memory described by
 mask.
@@ -189,7 +189,7 @@ dma_addr_t
 dma_map_single(struct device *dev, void *cpu_addr, size_t size,
 		      enum dma_data_direction direction)
 dma_addr_t
-pci_map_single(struct device *dev, void *cpu_addr, size_t size,
+pci_map_single(struct pci_dev *hwdev, void *cpu_addr, size_t size,
 		      int direction)
 
 Maps a piece of processor virtual memory so it can be accessed by the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

