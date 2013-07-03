From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-remove-unused-support-for-memset-operations-v3-fix.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:38:33 -0700
Message-ID: <51d499d9.Lr5UumPgvdKx9AOB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3GCVie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, t.figa@samsung.com, olof@lixom.net, kyungmin.park@samsung.com, khilman@linaro.org, jason@lakedaemon.net, herbert@gondor.apana.org.au, djbw@fb.com, b.zolnierkie@samsung.com, sebastian.hesselbarth@gmail.com

Subject: [folded-merged] drivers-dma-remove-unused-support-for-memset-operations-v3-fix.patch removed from -mm tree
To: sebastian.hesselbarth@gmail.com,b.zolnierkie@samsung.com,djbw@fb.com,herbert@gondor.apana.org.au,jason@lakedaemon.net,khilman@linaro.org,kyungmin.park@samsung.com,olof@lixom.net,t.figa@samsung.com,vinod.koul@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:38:33 -0700


The patch titled
     Subject: drivers-dma-remove-unused-support-for-memset-operations-v3-fix
has been removed from the -mm tree.  Its filename was
     drivers-dma-remove-unused-support-for-memset-operations-v3-fix.patch

This patch was dropped because it was folded into drivers-dma-remove-unused-support-for-memset-operations.patch

------------------------------------------------------
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: drivers-dma-remove-unused-support-for-memset-operations-v3-fix

Commit 834cbfe ("drivers/dma: remove unused support for MEMSET operations")
removes MEMSET from dmaengine but does not completely removes it from
drivers/dma/mv_xor.

This also fixes some compiler warnings about now obsolete functions by
removing those.

[bzolnier: splitted off changes from bigger patch]
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/mv_xor.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff -puN drivers/dma/mv_xor.c~drivers-dma-remove-unused-support-for-memset-operations-v3-fix drivers/dma/mv_xor.c
--- a/drivers/dma/mv_xor.c~drivers-dma-remove-unused-support-for-memset-operations-v3-fix
+++ a/drivers/dma/mv_xor.c
@@ -89,11 +89,6 @@ static void mv_desc_clear_next_desc(stru
 	hw_desc->phy_next_desc = 0;
 }
 
-static void mv_desc_set_block_fill_val(struct mv_xor_desc_slot *desc, u32 val)
-{
-	desc->value = val;
-}
-
 static void mv_desc_set_dest_addr(struct mv_xor_desc_slot *desc,
 				  dma_addr_t addr)
 {
@@ -128,22 +123,6 @@ static void mv_chan_set_next_descriptor(
 	__raw_writel(next_desc_addr, XOR_NEXT_DESC(chan));
 }
 
-static void mv_chan_set_dest_pointer(struct mv_xor_chan *chan, u32 desc_addr)
-{
-	__raw_writel(desc_addr, XOR_DEST_POINTER(chan));
-}
-
-static void mv_chan_set_block_size(struct mv_xor_chan *chan, u32 block_size)
-{
-	__raw_writel(block_size, XOR_BLOCK_SIZE(chan));
-}
-
-static void mv_chan_set_value(struct mv_xor_chan *chan, u32 value)
-{
-	__raw_writel(value, XOR_INIT_VALUE_LOW(chan));
-	__raw_writel(value, XOR_INIT_VALUE_HIGH(chan));
-}
