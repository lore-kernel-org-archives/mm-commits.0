From: akpm@linux-foundation.org
Subject: - m68knommu-set-no_dma.patch removed from -mm tree
Date: Mon, 05 Jan 2009 10:38:56 -0800
Message-ID: <200901051838.n05IcukC002239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZAESjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 13:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: set NO_DMA
has been removed from the -mm tree.  Its filename was
     m68knommu-set-no_dma.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: set NO_DMA
From: Adrian Bunk <bunk@kernel.org>

m68knommu does not set the Kconfig NO_DMA variable, but also does
not provide the required functions, resulting in the following
build error triggered by commit a40c24a13366e324bc0ff8c3bb107db89312c984
(net: Add SKB DMA mapping helper functions.):

  LD      vmlinux
net/built-in.o: In function `skb_dma_unmap':
(.text+0xac5e): undefined reference to `dma_unmap_single'
net/built-in.o: In function `skb_dma_unmap':
(.text+0xac7a): undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xacdc): undefined reference to `dma_map_single'
net/built-in.o: In function `skb_dma_map':
(.text+0xace8): undefined reference to `dma_mapping_error'
net/built-in.o: In function `skb_dma_map':
(.text+0xad10): undefined reference to `dma_map_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xad82): undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
(.text+0xadc6): undefined reference to `dma_unmap_single'
make[1]: *** [vmlinux] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/m68knommu/Kconfig~m68knommu-set-no_dma arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~m68knommu-set-no_dma
+++ a/arch/m68knommu/Kconfig
@@ -14,6 +14,10 @@ config MMU
 	bool
 	default n
 
+config NO_DMA
+	bool
+	default y
+
 config FPU
 	bool
 	default n
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m68knommu-set-no_dma.patch
reiser4.patch

