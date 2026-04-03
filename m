Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2626F36309F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198531; cv=none; b=CRD3/cy3nGHSbgomuePpChrDLPwi/vtRc/kVHMbsZIC57QGzsXYICqKp3QLlVX35BnC4lSNwBZImETdm+JGVnUnKMob//cZpH21St3E9JrRCTDLw7IzdMyDEmbvQHrGupzpJwGmAMyfMXLfeoMFBSmkvjGn81E/anVHh7GA+rKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198531; c=relaxed/simple;
	bh=asDc+mGiU+qa+lf+7tvHwi/kti8+F+M88ghzPLb4elw=;
	h=Date:To:From:Subject:Message-Id; b=QDgK07FcAsNtcyITWU+Z6lXt6uJRqZ/PDvU3Tv/RvUxNR0ES7ZoBw8eu/ClGHr9VblcvlYVPucsILwzxMCbS2kak89Wcu8/I58rHPnVzA8C8KadRaaXqK9x27SijoLp9DFTDfnqkWHNVZdxtf/2ZjabYosd9jwUb5k8R88/ShSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iZWzKRb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iZWzKRb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC23C4CEF7;
	Fri,  3 Apr 2026 06:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198531;
	bh=asDc+mGiU+qa+lf+7tvHwi/kti8+F+M88ghzPLb4elw=;
	h=Date:To:From:Subject:From;
	b=iZWzKRb6aBDzd1/sZY/hRqKyPbB5aE85Z10NWoGLn/dCoUepBM8dRwL5oKIIq7osQ
	 BiKSmsPxecQlDbYVNXOXXJzF1yUn7wd+xeTBMt522Ioso3OdjRQqXVYdPTART8ERSD
	 tiDciMK4P6YIZTMrjN6j9dOQ4z0+wuGMVzxqJ17M=
Date: Thu, 02 Apr 2026 23:42:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] async_xor-use-xor_gen.patch removed from -mm tree
Message-Id: <20260403064210.EBC23C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: async_xor: use xor_gen
has been removed from the -mm tree.  Its filename was
     async_xor-use-xor_gen.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: async_xor: use xor_gen
Date: Fri, 27 Mar 2026 07:16:56 +0100

Replace use of the loop around xor_blocks with the easier to use xor_gen
API.

Link: https://lkml.kernel.org/r/20260327061704.3707577-25-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_xor.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

--- a/crypto/async_tx/async_xor.c~async_xor-use-xor_gen
+++ a/crypto/async_tx/async_xor.c
@@ -103,7 +103,6 @@ do_sync_xor_offs(struct page *dest, unsi
 {
 	int i;
 	int xor_src_cnt = 0;
-	int src_off = 0;
 	void *dest_buf;
 	void **srcs;
 
@@ -117,23 +116,12 @@ do_sync_xor_offs(struct page *dest, unsi
 		if (src_list[i])
 			srcs[xor_src_cnt++] = page_address(src_list[i]) +
 				(src_offs ? src_offs[i] : offset);
-	src_cnt = xor_src_cnt;
+
 	/* set destination address */
 	dest_buf = page_address(dest) + offset;
-
 	if (submit->flags & ASYNC_TX_XOR_ZERO_DST)
 		memset(dest_buf, 0, len);
-
-	while (src_cnt > 0) {
-		/* process up to 'MAX_XOR_BLOCKS' sources */
-		xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
-		xor_blocks(xor_src_cnt, len, dest_buf, &srcs[src_off]);
-
-		/* drop completed sources */
-		src_cnt -= xor_src_cnt;
-		src_off += xor_src_cnt;
-	}
-
+	xor_gen(dest_buf, srcs, xor_src_cnt, len);
 	async_tx_sync_epilog(submit);
 }
 
@@ -168,11 +156,10 @@ dma_xor_aligned_offsets(struct dma_devic
  *
  * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
  *
- * xor_blocks always uses the dest as a source so the
- * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma engines is that they only
- * use the destination buffer as a source when it is explicitly specified
- * in the source list.
+ * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
+ * must be set to not include dest data in the calculation.  The assumption with
+ * dma engines is that they only use the destination buffer as a source when it
+ * is explicitly specified in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
  * The contents of this array will be overwritten if a scribble region
@@ -259,11 +246,10 @@ EXPORT_SYMBOL_GPL(async_xor_offs);
  *
  * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
  *
- * xor_blocks always uses the dest as a source so the
- * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma engines is that they only
- * use the destination buffer as a source when it is explicitly specified
- * in the source list.
+ * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
+ * must be set to not include dest data in the calculation.  The assumption with
+ * dma engines is that they only use the destination buffer as a source when it
+ * is explicitly specified in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
  * The contents of this array will be overwritten if a scribble region
_

Patches currently in -mm which might be from hch@lst.de are


