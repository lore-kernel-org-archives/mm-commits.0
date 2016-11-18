From: akpm@linux-foundation.org
Subject: + igb-update-code-to-better-handle-incrementing-page-count.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 15:31:05 -0800
Message-ID: <582f8f39.PKWj9o/esG82x3q8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753510AbcKRXbH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:31:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jeffrey.t.kirsher@intel.com, jejb@parisc-linux.org, jonas@southpole.se, keguang.zhang@gmail.com, lftan@altera.com, linux@armlinux.org.uk, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, ralf@linux-mips.org, realmz6@gmail.com, rkuo@codeaurora.org, tklauser@distanz.ch, vgupta@synopsys.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: igb: update code to better handle incrementing page count
has been added to the -mm tree.  Its filename is
     igb-update-code-to-better-handle-incrementing-page-count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/igb-update-code-to-better-handle-incrementing-page-count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/igb-update-code-to-better-handle-incrementing-page-count.patch

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
Subject: igb: update code to better handle incrementing page count

Update the driver code so that we do bulk updates of the page reference
count instead of just incrementing it by one reference at a time.  The
advantage to doing this is that we cut down on atomic operations and this
in turn should give us a slight improvement in cycles per packet.  In
addition if we eventually move this over to using build_skb the gains will
be more noticeable.

Link: http://lkml.kernel.org/r/20161110113616.76501.17072.stgit@ahduyck-blue-test.jf.intel.com
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

 drivers/net/ethernet/intel/igb/igb.h      |    7 ++++-
 drivers/net/ethernet/intel/igb/igb_main.c |   26 +++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff -puN drivers/net/ethernet/intel/igb/igb.h~igb-update-code-to-better-handle-incrementing-page-count drivers/net/ethernet/intel/igb/igb.h
--- a/drivers/net/ethernet/intel/igb/igb.h~igb-update-code-to-better-handle-incrementing-page-count
+++ a/drivers/net/ethernet/intel/igb/igb.h
@@ -210,7 +210,12 @@ struct igb_tx_buffer {
 struct igb_rx_buffer {
 	dma_addr_t dma;
 	struct page *page;
-	unsigned int page_offset;
+#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
+	__u32 page_offset;
+#else
+	__u16 page_offset;
+#endif
+	__u16 pagecnt_bias;
 };
 
 struct igb_tx_queue_stats {
diff -puN drivers/net/ethernet/intel/igb/igb_main.c~igb-update-code-to-better-handle-incrementing-page-count drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~igb-update-code-to-better-handle-incrementing-page-count
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3958,7 +3958,8 @@ static void igb_clean_rx_ring(struct igb
 				     PAGE_SIZE,
 				     DMA_FROM_DEVICE,
 				     DMA_ATTR_SKIP_CPU_SYNC);
-		__free_page(buffer_info->page);
+		__page_frag_drain(buffer_info->page, 0,
+				  buffer_info->pagecnt_bias);
 
 		buffer_info->page = NULL;
 	}
@@ -6837,13 +6838,15 @@ static bool igb_can_reuse_rx_page(struct
 				  struct page *page,
 				  unsigned int truesize)
 {
+	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias--;
+
 	/* avoid re-using remote pages */
 	if (unlikely(igb_page_is_reserved(page)))
 		return false;
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely(page_count(page) != 1))
+	if (unlikely(page_ref_count(page) != pagecnt_bias))
 		return false;
 
 	/* flip page offset to other buffer */
@@ -6856,10 +6859,14 @@ static bool igb_can_reuse_rx_page(struct
 		return false;
 #endif
 
-	/* Even if we own the page, we are not allowed to use atomic_set()
-	 * This would break get_page_unless_zero() users.
-	 */
-	page_ref_inc(page);
+	/* If we have drained the page fragment pool we need to update
+	 * the pagecnt_bias and page count so that we fully restock the
+	 * number of references the driver holds.
+	 */
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX);
+		rx_buffer->pagecnt_bias = USHRT_MAX;
+	}
 
 	return true;
 }
@@ -6911,7 +6918,6 @@ static bool igb_add_rx_frag(struct igb_r
 			return true;
 
 		/* this page cannot be reused so discard it */
-		__free_page(page);
 		return false;
 	}
 
@@ -6982,10 +6988,13 @@ static struct sk_buff *igb_fetch_rx_buff
 		/* hand second half of page back to the ring */
 		igb_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
-		/* we are not reusing the buffer so unmap it */
+		/* We are not reusing the buffer so unmap it and free
+		 * any references we are holding to it
+		 */
 		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
 				     PAGE_SIZE, DMA_FROM_DEVICE,
 				     DMA_ATTR_SKIP_CPU_SYNC);
+		__page_frag_drain(page, 0, rx_buffer->pagecnt_bias);
 	}
 
 	/* clear contents of rx_buffer */
@@ -7259,6 +7268,7 @@ static bool igb_alloc_mapped_page(struct
 	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = 0;
+	bi->pagecnt_bias = 1;
 
 	return true;
 }
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

