Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795413276;
	b=znxnexvd4sBhQF9HxRNho5yxj8LeGgc1emTJaVFYrCmj/rHorvpSZzJOhnCsx/zRxZ2G
	 jpQzEpURljpEdO8QFWsP7eSU9hDXvAkNZk72Zsa0QSxpk+qohSp4UplqSNzoLmMI73CbM
	 pB9/iTRGgt+BXhpJvxt2xydvBegmhnd123xeJ06R+tcFVCLXMWmCcun2IxzEFfgrg+l7V
	 gPfzrWF7bxSL2sj41qkDWTAy/AvaSPBC/9CetU4mMQH15yznvvbK1LLj7XXHbyAXCg19X
	 aIlupZf3Z9xhgMH4bqF3/3az954kF0H2J0Mm6Csq8WkghEFMdBuglBi34Teyjrb5RQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795413276;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=DsGGYdUg8qmcvrS4e1/ZPeTa+4BnZ/sivZrWxqMkXVw=;
	b=YDpRc8GY5ORCbFqSOjnjBF/1gy/ki7S6fTwop9HnCljNSDOcBMGJFG9IYRHo/GfP3v/2
	 +ITtPltvi5WiLGWkHyceVGOQFNBb5Sdh6yhcQ0xLq1bzjF2tKRK3m5yPVDRi/ZjD1DSEl
	 g+ahLFjgBjd2x2YIT/nkh7Ueg06m5PWXe9HCUTfbX50Sjfvlwq8N1LoMkMvYk/RoLL9Zf
	 co61v+icEYpQFeRtZsDIZEQ/tT5M6656G76FeyXzaW4xAuqtwtvez+quHE0y5dNiid0y/
	 YidQGSggEwNyFfaRmt6CR1yAVcxrRwZYHqlmFNkrwXxuPX0j9ozOWmh2Jy2EfMqKYww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="V/vzvZBM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020C606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 05:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V/vzvZBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4581F000CA;
	Mon, 23 Nov 2026 05:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795413275;
	bh=DsGGYdUg8qmcvrS4e1/ZPeTa+4BnZ/sivZrWxqMkXVw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=V/vzvZBMgriFEyB21fFHLGRkEttZxzRmUVz3LBX5HQYCBRuJ7/yM5P4L0mUHDUi23
	 Lw3wLV2n/oMjuZd4NhGMyMlJ0ycPDlhDZ+q/ALHEg6/8mmh9guxfCkm1XevEAsLpQl
	 jZAQ2efkW/7kHvObBl2n792q7mZmt3U2VCnPPCoY=
Date: Sun, 22 Nov 2026 21:54:34 -0800
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,
	markus.stockhausen@collogia.de,magiclinan@didiglobal.com,hch@lst.de,
	ebiggers@kernel.org,david.laight.linux@gmail.com,mc@raidlab.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122032933.2306875-2-mc@raidlab.org>
References: <20261122032933.2306875-2-mc@raidlab.org>
Subject: + raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch added to mm-nonmm-unstable branch
Message-Id: <20261123055435.7E4581F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: declare the AVX-512 P/Q stores as asm outputs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Miroslav Cimerman <mc@raidlab.org>
Subject: raid6: declare the AVX-512 P/Q stores as asm outputs
Date: Sun, 22 Nov 2026 03:29:31 +0000

Patch series "raid6: x86: asm constraints, sfence and prefetch in
xor_syndrome".

This follows up on the review of "raid6: use normal stores in the x86 x4
xor_syndrome functions" [1]. With that patch, none of the x86
xor_syndrome() functions uses non-temporal stores, so their sfence
orders nothing. Christoph suggested removing it [2]. Eric pointed out
that the AVX-512 functions list P and Q as asm inputs only and rely on
the "memory" clobber of that sfence, and suggested prefetcht0 for Q [3].
1/3 fixes the constraints, 2/3 removes the sfence, and 3/3 changes the
prefetch of Q.

The patches and the tests were prepared with the help of an LLM. I
reviewed everything.


This patch (of 3):

The AVX-512 gen_syndrome() and xor_syndrome() functions store P and Q in
inline asm that lists these memory operands as inputs only. The compiler
may then assume that the asm does not change P and Q. Each function ends
with an sfence whose asm has a "memory" clobber, and the constraints
technically rely on it.

Declare the stored P and Q as outputs: "=m" where the asm only writes
them, and "+m" for Q in xor_syndrome(), which the same asm reads and
writes back. The SSE2 and AVX2 functions already declare their stores as
outputs.

With clang the generated code does not change: it already loads the data
pointers from ptrs[] inside the loop over the block. gcc 15.2 now does
the same, because a byte store may alias the pointer array. Five of the
six functions get one or two more instructions.

Link: https://lore.kernel.org/20261122032933.2306875-1-mc@raidlab.org
Link: https://patch.msgid.link/20261122032933.2306875-2-mc@raidlab.org
Link: https://lore.kernel.org/linux-raid/20261109030805.25709-1-mc@raidlab.org/ [1]
Link: https://lore.kernel.org/linux-raid/avqegZd_W0kce0UA@infradead.org/ [2]
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/ [3]
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Markus Stockhausen <markus.stockhausen@collogia.de>

 lib/raid/raid6/x86/avx512.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/lib/raid/raid6/x86/avx512.c~raid6-declare-the-avx-512-p-q-stores-as-asm-outputs
+++ a/lib/raid/raid6/x86/avx512.c
@@ -73,8 +73,7 @@ static void raid6_avx5121_gen_syndrome(i
 			     "vpxorq %%zmm2,%%zmm2,%%zmm2\n\t"
 			     "vmovntdq %%zmm4,%1\n\t"
 			     "vpxorq %%zmm4,%%zmm4,%%zmm4"
-			     :
-			     : "m" (p[d]), "m" (q[d]));
+			     : "=m" (p[d]), "=m" (q[d]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -133,8 +132,7 @@ static void raid6_avx5121_xor_syndrome(i
 		/* Don't use movntdq for r/w memory area < cache line */
 			     "vmovdqa64 %%zmm4,%0\n\t"
 			     "vmovdqa64 %%zmm2,%1"
-			     :
-			     : "m" (q[d]), "m" (p[d]));
+			     : "+m" (q[d]), "=m" (p[d]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -204,9 +202,8 @@ static void raid6_avx5122_gen_syndrome(i
 			     "vmovntdq %%zmm3,%1\n\t"
 			     "vmovntdq %%zmm4,%2\n\t"
 			     "vmovntdq %%zmm6,%3"
-			     :
-			     : "m" (p[d]), "m" (p[d+64]), "m" (q[d]),
-			       "m" (q[d+64]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (q[d]),
+			       "=m" (q[d+64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -289,9 +286,8 @@ static void raid6_avx5122_xor_syndrome(i
 			     "vmovdqa64 %%zmm6,%1\n\t"
 			     "vmovdqa64 %%zmm2,%2\n\t"
 			     "vmovdqa64 %%zmm3,%3"
-			     :
-			     : "m" (q[d]), "m" (q[d+64]), "m" (p[d]),
-			       "m" (p[d+64]));
+			     : "+m" (q[d]), "+m" (q[d+64]), "=m" (p[d]),
+			       "=m" (p[d+64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -393,10 +389,9 @@ static void raid6_avx5124_gen_syndrome(i
 			     "vpxorq %%zmm12,%%zmm12,%%zmm12\n\t"
 			     "vmovntdq %%zmm14,%7\n\t"
 			     "vpxorq %%zmm14,%%zmm14,%%zmm14"
-			     :
-			     : "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]), "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (p[d+128]),
+			       "=m" (p[d+192]), "=m" (q[d]), "=m" (q[d+64]),
+			       "=m" (q[d+128]), "=m" (q[d+192]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -528,10 +523,9 @@ static void raid6_avx5124_xor_syndrome(i
 			     "vmovdqa64 %%zmm6,%5\n\t"
 			     "vmovdqa64 %%zmm12,%6\n\t"
 			     "vmovdqa64 %%zmm14,%7"
-			     :
-			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (p[d+128]),
+			       "=m" (p[d+192]), "+m" (q[d]), "+m" (q[d+64]),
+			       "+m" (q[d+128]), "+m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
_

Patches currently in -mm which might be from mc@raidlab.org are

raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch
raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch
raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch
raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch

