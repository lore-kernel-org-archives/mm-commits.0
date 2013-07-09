From: akpm@linux-foundation.org
Subject: [merged] crypto-talitos-use-sg_pcopy_to_buffer.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:35 -0700
Message-ID: <51dc9b3b.RsTqPs74RwxoJKwe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3GIXWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, imre.deak@intel.com, horia.geanta@freescale.com, herbert@gondor.apana.org.au, dgilbert@interlog.com, davem@davemloft.net, JBottomley@parallels.com, akinobu.mita@gmail.com

Subject: [merged] crypto-talitos-use-sg_pcopy_to_buffer.patch removed from -mm tree
To: akinobu.mita@gmail.com,JBottomley@parallels.com,davem@davemloft.net,dgilbert@interlog.com,herbert@gondor.apana.org.au,horia.geanta@freescale.com,imre.deak@intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:35 -0700


The patch titled
     Subject: crypto: talitos: use sg_pcopy_to_buffer()
has been removed from the -mm tree.  Its filename was
     crypto-talitos-use-sg_pcopy_to_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: crypto: talitos: use sg_pcopy_to_buffer()

Use sg_pcopy_to_buffer() which is better than the function previously used.
Because it doesn't do kmap/kunmap for skipped pages.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/talitos.c |   60 -------------------------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

diff -puN drivers/crypto/talitos.c~crypto-talitos-use-sg_pcopy_to_buffer drivers/crypto/talitos.c
--- a/drivers/crypto/talitos.c~crypto-talitos-use-sg_pcopy_to_buffer
+++ a/drivers/crypto/talitos.c
@@ -1112,64 +1112,6 @@ static int sg_count(struct scatterlist *
 	return sg_nents;
 }
 
-/**
- * sg_copy_end_to_buffer - Copy end data from SG list to a linear buffer
- * @sgl:		 The SG list
- * @nents:		 Number of SG entries
- * @buf:		 Where to copy to
- * @buflen:		 The number of bytes to copy
- * @skip:		 The number of bytes to skip before copying.
- *                       Note: skip + buflen should equal SG total size.
- *
- * Returns the number of copied bytes.
- *
- **/
-static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
-				    void *buf, size_t buflen, unsigned int skip)
-{
-	unsigned int offset = 0;
-	unsigned int boffset = 0;
-	struct sg_mapping_iter miter;
-	unsigned long flags;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
-	size_t total_buffer = buflen + skip;
-
-	sg_flags |= SG_MITER_FROM_SG;
-
-	sg_miter_start(&miter, sgl, nents, sg_flags);
-
-	local_irq_save(flags);
-
-	while (sg_miter_next(&miter) && offset < total_buffer) {
-		unsigned int len;
-		unsigned int ignore;
-
-		if ((offset + miter.length) > skip) {
-			if (offset < skip) {
-				/* Copy part of this segment */
-				ignore = skip - offset;
-				len = miter.length - ignore;
-				if (boffset + len > buflen)
-					len = buflen - boffset;
-				memcpy(buf + boffset, miter.addr + ignore, len);
-			} else {
-				/* Copy all of this segment (up to buflen) */
-				len = miter.length;
-				if (boffset + len > buflen)
-					len = buflen - boffset;
-				memcpy(buf + boffset, miter.addr, len);
-			}
-			boffset += len;
-		}
-		offset += miter.length;
-	}
-
-	sg_miter_stop(&miter);
-
-	local_irq_restore(flags);
-	return boffset;
-}
