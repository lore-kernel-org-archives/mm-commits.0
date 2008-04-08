From: akpm@linux-foundation.org
Subject: + doc-fix-dma-api-function-parameters.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:00:33 -0700
Message-ID: <200804080700.m3870X6v013334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYDHHAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     doc: fix DMA-API function parameters
has been added to the -mm tree.  Its filename is
     doc-fix-dma-api-function-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: fix DMA-API function parameters
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel bugzilla #10388.

DMA-API.txt has wrong argument type for some functions.  It uses struct device
but should use struct pci_dev.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
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

x86_32-fix-visualws-and-voyager-kexec-build-failures.patch
rapidio-fix-docbook-references.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
docbook-some-kernel-locking-fixes.patch
kernel-doc-detect-prevent-duplicate-doc-section-names.patch
kernel-doc-detect-trailing-kernel-doc-line-trash.patch
documentation-build-source-files-in-documentation-sub-dir.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

