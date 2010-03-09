From: akpm@linux-foundation.org
Subject: + documentation-fix-block-biodoctxt-dma-mapping-description.patch added to -mm tree
Date: Tue, 09 Mar 2010 11:48:30 -0800
Message-ID: <201003091948.o29JmUuj001300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab0CITse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:48:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     Documentation: fix block/biodoc.txt dma mapping description
has been added to the -mm tree.  Its filename is
     documentation-fix-block-biodoctxt-dma-mapping-description.patch

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
Subject: Documentation: fix block/biodoc.txt dma mapping description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- It looks incorrect to use blk_rq_map_sg with pci_map_page here about
  DMA mappings. dma_map_sg?

- better to use dma_map_page instead of pci_map_page.
  http://marc.info/?l=linux-kernel&m=126596737604808&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/biodoc.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/block/biodoc.txt~documentation-fix-block-biodoctxt-dma-mapping-description Documentation/block/biodoc.txt
--- a/Documentation/block/biodoc.txt~documentation-fix-block-biodoctxt-dma-mapping-description
+++ a/Documentation/block/biodoc.txt
@@ -1162,8 +1162,8 @@ where a driver received a request ala th
 
 As mentioned, there is no virtual mapping of a bio. For DMA, this is
 not a problem as the driver probably never will need a virtual mapping.
-Instead it needs a bus mapping (pci_map_page for a single segment or
-use blk_rq_map_sg for scatter gather) to be able to ship it to the driver. For
+Instead it needs a bus mapping (dma_map_page for a single segment or
+use dma_map_sg for scatter gather) to be able to ship it to the driver. For
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
documentation-fix-block-biodoctxt-dma-mapping-description.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
dma-mappingh-add-the-dma_unmap-state-api-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

