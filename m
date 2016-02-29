From: akpm@linux-foundation.org
Subject: + memremap-dont-modify-flags.patch added to -mm tree
Date: Mon, 29 Feb 2016 15:32:33 -0800
Message-ID: <56d4d511.IP7Qy+bWbeGOVedX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcB2Xce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brian.starkey@arm.com, catalin.marinas@arm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memremap: don't modify flags
has been added to the -mm tree.  Its filename is
     memremap-dont-modify-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memremap-dont-modify-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memremap-dont-modify-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Starkey <brian.starkey@arm.com>
Subject: memremap: don't modify flags

These patches implement a MEMREMAP_WC flag for memremap(), which can be
used to obtain writecombine mappings.  This is then used for setting up
dma_coherent_mem regions which use the DMA_MEMORY_MAP flag.

The motivation is to fix an alignment fault on arm64, and the suggestion
to implement MEMREMAP_WC for this case was made at [1].  That particular
issue is handled in patch 4, which makes sure that the appropriate memset
function is used when zeroing allocations mapped as IO memory.


This patch (of 4):

Don't modify the flags input argument to memremap(). MEMREMAP_WB is
already a special case so we can check for it directly instead of
clearing flag bits in each mapper.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/memremap.c~memremap-dont-modify-flags kernel/memremap.c
--- a/kernel/memremap.c~memremap-dont-modify-flags
+++ a/kernel/memremap.c
@@ -64,6 +64,9 @@ void *memremap(resource_size_t offset, s
 				       IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
 	void *addr = NULL;
 
+	if (!flags)
+		return NULL;
+
 	if (is_ram == REGION_MIXED) {
 		WARN_ONCE(1, "memremap attempted on mixed range %pa size: %#lx\n",
 				&offset, (unsigned long) size);
@@ -72,7 +75,6 @@ void *memremap(resource_size_t offset, s
 
 	/* Try all mapping types requested until one returns non-NULL */
 	if (flags & MEMREMAP_WB) {
-		flags &= ~MEMREMAP_WB;
 		/*
 		 * MEMREMAP_WB is special in that it can be satisifed
 		 * from the direct map.  Some archs depend on the
@@ -86,21 +88,19 @@ void *memremap(resource_size_t offset, s
 	}
 
 	/*
-	 * If we don't have a mapping yet and more request flags are
-	 * pending then we will be attempting to establish a new virtual
+	 * If we don't have a mapping yet and other request flags are
+	 * present then we will be attempting to establish a new virtual
 	 * address mapping.  Enforce that this mapping is not aliasing
 	 * System RAM.
 	 */
-	if (!addr && is_ram == REGION_INTERSECTS && flags) {
+	if (!addr && is_ram == REGION_INTERSECTS && flags != MEMREMAP_WB) {
 		WARN_ONCE(1, "memremap attempted on ram %pa size: %#lx\n",
 				&offset, (unsigned long) size);
 		return NULL;
 	}
 
-	if (!addr && (flags & MEMREMAP_WT)) {
-		flags &= ~MEMREMAP_WT;
+	if (!addr && (flags & MEMREMAP_WT))
 		addr = ioremap_wt(offset, size);
-	}
 
 	return addr;
 }
_

Patches currently in -mm which might be from brian.starkey@arm.com are

memremap-dont-modify-flags.patch
memremap-add-memremap_wc-flag.patch
drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch
drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch

