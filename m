From: akpm@linux-foundation.org
Subject: - dma-document-dma_map_attrs-interfaces.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:35 -0700
Message-ID: <200804300543.m3U5hZPJ029329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680AbYD3FpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akepner@sgi.com, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com, markn@au1.ibm.


The patch titled
     dma: document dma_*map*_attrs() interfaces
has been removed from the -mm tree.  Its filename was
     dma-document-dma_map_attrs-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma: document dma_*map*_attrs() interfaces
From: Arthur Kepner <akepner@sgi.com>

Document the new dma_*map*_attrs() functions.

[markn@au1.ibm.com: fix up for dma-add-dma_map_attrs-interfaces and update docs]
Signed-off-by: Arthur Kepner <akepner@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt        |   65 +++++++++++++++++++++++++++++
 Documentation/DMA-attributes.txt |   24 ++++++++++
 2 files changed, 89 insertions(+)

diff -puN Documentation/DMA-API.txt~dma-document-dma_map_attrs-interfaces Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-document-dma_map_attrs-interfaces
+++ a/Documentation/DMA-API.txt
@@ -395,6 +395,71 @@ Notes:  You must do this:
 
 See also dma_map_single().
 
+dma_addr_t
+dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
+		     enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
+
+void
+dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
+		       size_t size, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
+
+int
+dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		 int nents, enum dma_data_direction dir,
+		 struct dma_attrs *attrs)
+
+void
+dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
+
+The four functions above are just like the counterpart functions
+without the _attrs suffixes, except that they pass an optional
+struct dma_attrs*.
+
+struct dma_attrs encapsulates a set of "dma attributes". For the
+definition of struct dma_attrs see linux/dma-attrs.h.
+
+The interpretation of dma attributes is architecture-specific, and
+each attribute should be documented in Documentation/DMA-attributes.txt.
+
+If struct dma_attrs* is NULL, the semantics of each of these
+functions is identical to those of the corresponding function
+without the _attrs suffix. As a result dma_map_single_attrs()
+can generally replace dma_map_single(), etc.
+
+As an example of the use of the *_attrs functions, here's how
+you could pass an attribute DMA_ATTR_FOO when mapping memory
+for DMA:
+
+#include <linux/dma-attrs.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
+ * documented in Documentation/DMA-attributes.txt */
+...
+
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_FOO, &attrs);
+	....
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	....
+
+Architectures that care about DMA_ATTR_FOO would check for its
+presence in their implementations of the mapping and unmapping
+routines, e.g.:
+
+void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
+			     size_t size, enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
+{
+	....
+	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
+	....
+	if (foo)
+		/* twizzle the frobnozzle */
+	....
+
 
 Part II - Advanced dma_ usage
 -----------------------------
diff -puN Documentation/DMA-attributes.txt~dma-document-dma_map_attrs-interfaces Documentation/DMA-attributes.txt
--- a/Documentation/DMA-attributes.txt~dma-document-dma_map_attrs-interfaces
+++ a/Documentation/DMA-attributes.txt
@@ -0,0 +1,24 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are
+defined in linux/dma-attrs.h.
+
+DMA_ATTR_WRITE_BARRIER
+----------------------
+
+DMA_ATTR_WRITE_BARRIER is a (write) barrier attribute for DMA.  DMA
+to a memory region with the DMA_ATTR_WRITE_BARRIER attribute forces
+all pending DMA writes to complete, and thus provides a mechanism to
+strictly order DMA from a device across all intervening busses and
+bridges.  This barrier is not specific to a particular type of
+interconnect, it applies to the system as a whole, and so its
+implementation must account for the idiosyncracies of the system all
+the way from the DMA device to memory.
+
+As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
+useful, suppose that a device does a DMA write to indicate that data is
+ready and available in memory.  The DMA of the "completion indication"
+could race with data DMA.  Mapping the memory used for completion
+indications with DMA_ATTR_WRITE_BARRIER would prevent the race.
+
_

Patches currently in -mm which might be from akepner@sgi.com are

origin.patch

