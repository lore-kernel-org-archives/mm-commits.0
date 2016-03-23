From: akpm@linux-foundation.org
Subject: [merged] memremap-add-memremap_wc-flag.patch removed from -mm
 tree
Date: Wed, 23 Mar 2016 10:42:52 -0700
Message-ID: <56f2d59c.d0uYjG/aeHawMIeg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbcCWRmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brian.starkey@arm.com, catalin.marinas@arm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memremap: add MEMREMAP_WC flag
has been removed from the -mm tree.  Its filename was
     memremap-add-memremap_wc-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Starkey <brian.starkey@arm.com>
Subject: memremap: add MEMREMAP_WC flag

Add a flag to memremap() for writecombine mappings.  Mappings satisfied by
this flag will not be cached, however writes may be delayed or combined
into more efficient bursts.  This is most suitable for buffers written
sequentially by the CPU for use by other DMA devices.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    1 +
 kernel/memremap.c  |   13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/io.h~memremap-add-memremap_wc-flag include/linux/io.h
--- a/include/linux/io.h~memremap-add-memremap_wc-flag
+++ a/include/linux/io.h
@@ -135,6 +135,7 @@ enum {
 	/* See memremap() kernel-doc for usage description... */
 	MEMREMAP_WB = 1 << 0,
 	MEMREMAP_WT = 1 << 1,
+	MEMREMAP_WC = 1 << 2,
 };
 
 void *memremap(resource_size_t offset, size_t size, unsigned long flags);
diff -puN kernel/memremap.c~memremap-add-memremap_wc-flag kernel/memremap.c
--- a/kernel/memremap.c~memremap-add-memremap_wc-flag
+++ a/kernel/memremap.c
@@ -41,11 +41,13 @@ static void *try_ram_remap(resource_size
  * memremap() - remap an iomem_resource as cacheable memory
  * @offset: iomem resource start address
  * @size: size of remap
- * @flags: either MEMREMAP_WB or MEMREMAP_WT
+ * @flags: any of MEMREMAP_WB, MEMREMAP_WT and MEMREMAP_WC
  *
  * memremap() is "ioremap" for cases where it is known that the resource
  * being mapped does not have i/o side effects and the __iomem
- * annotation is not applicable.
+ * annotation is not applicable. In the case of multiple flags, the different
+ * mapping types will be attempted in the order listed below until one of
+ * them succeeds.
  *
  * MEMREMAP_WB - matches the default mapping for System RAM on
  * the architecture.  This is usually a read-allocate write-back cache.
@@ -57,6 +59,10 @@ static void *try_ram_remap(resource_size
  * cache or are written through to memory and never exist in a
  * cache-dirty state with respect to program visibility.  Attempts to
  * map System RAM with this mapping type will fail.
+ *
+ * MEMREMAP_WC - establish a writecombine mapping, whereby writes may
+ * be coalesced together (e.g. in the CPU's write buffers), but is otherwise
+ * uncached. Attempts to map System RAM with this mapping type will fail.
  */
 void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 {
@@ -102,6 +108,9 @@ void *memremap(resource_size_t offset, s
 	if (!addr && (flags & MEMREMAP_WT))
 		addr = ioremap_wt(offset, size);
 
+	if (!addr && (flags & MEMREMAP_WC))
+		addr = ioremap_wc(offset, size);
+
 	return addr;
 }
 EXPORT_SYMBOL(memremap);
_

Patches currently in -mm which might be from brian.starkey@arm.com are


