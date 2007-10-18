From: akpm@linux-foundation.org
Subject: - update-dma-mapping-documentation.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:48 -0700
Message-ID: <200710180704.l9I74mCg031591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759909AbXJRH2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, davem@davemloft.net, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Update DMA-mapping documentation
has been removed from the -mm tree.  Its filename was
     update-dma-mapping-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Update DMA-mapping documentation
From: Matthew Wilcox <matthew@wil.cx>

A couple of updates haven't considered whether the documentation makes
sense as a whole any more.  Three changes here:

 - Remove the reference to the "DAC Addressing for Address Space Hungry
   Devices" section which was deleted by Jan Beulich.
 - Remove the comment about DMA_24BIT_MASK which became obsolete when
   Tobias Klauser changed the code to actually use DMA_24BIT_MASK.
 - Remove the section "64-bit DMA and DAC cycle support" since it's
   fully covered above, and contains a reference to the section deleted
   by Jan.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-mapping.txt |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN Documentation/DMA-mapping.txt~update-dma-mapping-documentation Documentation/DMA-mapping.txt
--- a/Documentation/DMA-mapping.txt~update-dma-mapping-documentation
+++ a/Documentation/DMA-mapping.txt
@@ -189,12 +189,6 @@ smaller mask as pci_set_dma_mask(). Howe
 device driver only uses consistent allocations, one would have to
 check the return value from pci_set_consistent_dma_mask().
 
-If your 64-bit device is going to be an enormous consumer of DMA
-mappings, this can be problematic since the DMA mappings are a
-finite resource on many platforms.  Please see the "DAC Addressing
-for Address Space Hungry Devices" section near the end of this
-document for how to handle this case.
-
 Finally, if your device can only drive the low 24-bits of
 address during PCI bus mastering you might do something like:
 
@@ -203,8 +197,6 @@ address during PCI bus mastering you mig
 		       "mydev: 24-bit DMA addressing not available.\n");
 		goto ignore_this_device;
 	}
-[Better use DMA_24BIT_MASK instead of 0x00ffffff.
-See linux/include/dma-mapping.h for reference.]
 
 When pci_set_dma_mask() is successful, and returns zero, the PCI layer
 saves away this mask you have provided.  The PCI layer will use this
@@ -652,18 +644,6 @@ It is planned to completely remove virt_
 they are entirely deprecated.  Some ports already do not provide these
 as it is impossible to correctly support them.
 
-		64-bit DMA and DAC cycle support
-
-Do you understand all of the text above?  Great, then you already
-know how to use 64-bit DMA addressing under Linux.  Simply make
-the appropriate pci_set_dma_mask() calls based upon your cards
-capabilities, then use the mapping APIs above.
-
-It is that simple.
-
-Well, not for some odd devices.  See the next section for information
-about that.
-
 		Optimizing Unmap State Space Consumption
 
 On many platforms, pci_unmap_{single,page}() is simply a nop.
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
git-scsi-misc.patch
make-sure-nobodys-leaking-resources.patch
