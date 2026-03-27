Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DEF3FA5E1
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632740; cv=none; b=JW5s08pglcuXph+lLOLhr9zeAp1uYeaZ9OgtFmX5hvRYX+Y5sbmPwki8W2ecsSP1qkslGC3amW6geh66l0HMfnxXMO8sZIbt5M85hBD78UmFZOmWl8TbOXETi/Zi0m5xc6nswBquVXRCg6h3ZOi8My1tbQYFMJ3ojrzm9Y83+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632740; c=relaxed/simple;
	bh=i4Dl1/tx0FiAm34BEq2UW+b8WW7RNq5R1en6sH5oOLQ=;
	h=Date:To:From:Subject:Message-Id; b=L/YZDdDsHdpHxHQXp0yT5OMnys4ivZNna1U/zmD17vgbkfaq4S2DvHB5ivWaK11r9HYvcB/nLzl7I6yyBNBnZJXUEeaRrf0U/XAAhJLLAU2qs4jQSkHSgY3zCJ2ry6ugrq+ydAcDoaVKWqcWXxz8CiRHvCpzhgiIQ1vdU2Uz2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DIyNSl18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DIyNSl18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27552C19423;
	Fri, 27 Mar 2026 17:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632740;
	bh=i4Dl1/tx0FiAm34BEq2UW+b8WW7RNq5R1en6sH5oOLQ=;
	h=Date:To:From:Subject:From;
	b=DIyNSl18x08hNsktDfWW6Ct4vzLl4U+sXEW129/L1a2K1sEpZ03Z0cQL4nlDL/Nai
	 3LiCsc4Ql7TntH6uPRJDrDBlXh3QSXdtvYfRDxr0eo/SNiuu/097rS9OefrYEiCyMa
	 IzQ7RQXs/xAgp6+yVrv4D0YUUBguXoQ5CygyzFzw=
Date: Fri, 27 Mar 2026 10:32:19 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] async_xor-use-xor_gen.patch removed from -mm tree
Message-Id: <20260327173220.27552C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: async_xor: use xor_gen
has been removed from the -mm tree.  Its filename was
     async_xor-use-xor_gen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: async_xor: use xor_gen
Date: Tue, 24 Mar 2026 07:21:58 +0100

Replace use of the loop around xor_blocks with the easier to use xor_gen
API.

Link: https://lkml.kernel.org/r/20260324062211.3216301-23-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

