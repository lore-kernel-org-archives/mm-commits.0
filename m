From: akpm@linux-foundation.org
Subject: + m68knommu-set-no_dma.patch added to -mm tree
Date: Mon, 03 Nov 2008 12:45:56 -0800
Message-ID: <200811032045.mA3KjurQ023242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYKCUqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 15:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, gerg@snapgear.com


The patch titled
     m68knommu: set NO_DMA
has been added to the -mm tree.  Its filename is
     m68knommu-set-no_dma.patch

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

linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m68knommu-set-no_dma.patch
reiser4.patch

