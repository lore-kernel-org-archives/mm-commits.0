From: akpm@linux-foundation.org
Subject: + igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 15:31:02 -0800
Message-ID: <582f8f36.fGspJAnyhykRRVll%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753752AbcKRXbF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jeffrey.t.kirsher@intel.com, jejb@parisc-linux.org, jonas@southpole.se, keguang.zhang@gmail.com, lftan@altera.com, linux@armlinux.org.uk, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, ralf@linux-mips.org, realmz6@gmail.com, rkuo@codeaurora.org, tklauser@distanz.ch, vgupta@synopsys.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: igb: update driver to make use of DMA_ATTR_SKIP_CPU_SYNC
has been added to the -mm tree.  Its filename is
     igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: igb: update driver to make use of DMA_ATTR_SKIP_CPU_SYNC

The ARM architecture provides a mechanism for deferring cache line
invalidation in the case of map/unmap.  This patch makes use of this
mechanism to avoid unnecessary synchronization.

A secondary effect of this change is that the portion of the page that has
been synchronized for use by the CPU should be writable and could be
passed up the stack (at least on ARM).

The last bit that occurred to me is that on architectures where the
sync_for_cpu call invalidates cache lines we were prefetching and then
invalidating the first 128 bytes of the packet.  To avoid that I have
moved the sync up to before we perform the prefetch and allocate the
skbuff so that we can actually make use of it.

Link: http://lkml.kernel.org/r/20161110113611.76501.98897.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Cc: Helge Deller <deller@gmx.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Keguang Zhang <keguang.zhang@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/intel/igb/igb_main.c |   53 ++++++++++++--------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff -puN drivers/net/ethernet/intel/igb/igb_main.c~igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3943,10 +3943,21 @@ static void igb_clean_rx_ring(struct igb
 		if (!buffer_info->page)
 			continue;
 
-		dma_unmap_page(rx_ring->dev,
-			       buffer_info->dma,
-			       PAGE_SIZE,
-			       DMA_FROM_DEVICE);
+		/* Invalidate cache lines that may have been written to by
+		 * device so that we avoid corrupting memory.
+		 */
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      buffer_info->dma,
+					      buffer_info->page_offset,
+					      IGB_RX_BUFSZ,
+					      DMA_FROM_DEVICE);
+
+		/* free resources associated with mapping */
+		dma_unmap_page_attrs(rx_ring->dev,
+				     buffer_info->dma,
+				     PAGE_SIZE,
+				     DMA_FROM_DEVICE,
+				     DMA_ATTR_SKIP_CPU_SYNC);
 		__free_page(buffer_info->page);
 
 		buffer_info->page = NULL;
@@ -6815,12 +6826,6 @@ static void igb_reuse_rx_page(struct igb
 
 	/* transfer page from old buffer to new buffer */
 	*new_buff = *old_buff;
-
-	/* sync the buffer for use by the device */
-	dma_sync_single_range_for_device(rx_ring->dev, old_buff->dma,
-					 old_buff->page_offset,
-					 IGB_RX_BUFSZ,
-					 DMA_FROM_DEVICE);
 }
 
 static inline bool igb_page_is_reserved(struct page *page)
@@ -6941,6 +6946,13 @@ static struct sk_buff *igb_fetch_rx_buff
 	page = rx_buffer->page;
 	prefetchw(page);
 
+	/* we are reusing so sync this buffer for CPU use */
+	dma_sync_single_range_for_cpu(rx_ring->dev,
+				      rx_buffer->dma,
+				      rx_buffer->page_offset,
+				      size,
+				      DMA_FROM_DEVICE);
+
 	if (likely(!skb)) {
 		void *page_addr = page_address(page) +
 				  rx_buffer->page_offset;
@@ -6965,21 +6977,15 @@ static struct sk_buff *igb_fetch_rx_buff
 		prefetchw(skb->data);
 	}
 
-	/* we are reusing so sync this buffer for CPU use */
-	dma_sync_single_range_for_cpu(rx_ring->dev,
-				      rx_buffer->dma,
-				      rx_buffer->page_offset,
-				      size,
-				      DMA_FROM_DEVICE);
-
 	/* pull page into skb */
 	if (igb_add_rx_frag(rx_ring, rx_buffer, size, rx_desc, skb)) {
 		/* hand second half of page back to the ring */
 		igb_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
 		/* we are not reusing the buffer so unmap it */
-		dma_unmap_page(rx_ring->dev, rx_buffer->dma,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
+				     PAGE_SIZE, DMA_FROM_DEVICE,
+				     DMA_ATTR_SKIP_CPU_SYNC);
 	}
 
 	/* clear contents of rx_buffer */
@@ -7237,7 +7243,8 @@ static bool igb_alloc_mapped_page(struct
 	}
 
 	/* map page for use */
-	dma = dma_map_page(rx_ring->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	dma = dma_map_page_attrs(rx_ring->dev, page, 0, PAGE_SIZE,
+				 DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 
 	/* if mapping failed free memory back to system since
 	 * there isn't much point in holding memory we can't use
@@ -7278,6 +7285,12 @@ void igb_alloc_rx_buffers(struct igb_rin
 		if (!igb_alloc_mapped_page(rx_ring, bi))
 			break;
 
+		/* sync the buffer for use by the device */
+		dma_sync_single_range_for_device(rx_ring->dev, bi->dma,
+						 bi->page_offset,
+						 IGB_RX_BUFSZ,
+						 DMA_FROM_DEVICE);
+
 		/* Refresh the desc even if buffer_addrs didn't change
 		 * because each write-back erases this info.
 		 */
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

arch-arc-add-option-to-skip-sync-on-dma-mapping.patch
arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-avr32-add-option-to-skip-sync-on-dma-map.patch
arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-frv-add-option-to-skip-sync-on-dma-map.patch
arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch
mm-add-support-for-releasing-multiple-instances-of-a-page.patch
igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
igb-update-code-to-better-handle-incrementing-page-count.patch

