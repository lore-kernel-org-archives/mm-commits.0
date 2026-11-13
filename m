Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537679;
	b=rjFc69LrWSVnuXGQ9n+HGQLpIV6iufMZ1Qoz3xVd1GJP2D/I1eqTct/AQkXOrcRnar3T
	 MpoQhAV9zv78ZPwP6YoD+HtBxAjJUlQByEMR6r/g6pinoPC6ySd2HpYn44W2QoQi6NaoN
	 H60dlHtUQfubWoHy8Drt1Wzdpl6WB4H4H6o02WiO1P+vwHjYT+2CIjffF8FpbR3FZy3i8
	 vC/vGZHTk5pkGB/HCvnb0GB9JPS28qe3sZZh4Wu2qgWEJ67uFMi2C4B2XUKw2fUMDJGBU
	 R57Zm+VXeXf7bPB8G2251rVOA9fA8RDN8Nhb0NqB4ejn740KvcCw/0jjoYIY42b85AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537679;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QNaXxlN2ZsJ68a8IX+qwHDYBnbGl+8DZAI4/GtpaXOI=;
	b=DIYxBMj1C3QVwFqlHNIwIhCHRl67frWwxO/Djua6dpMuJn80VKPWypORQPzWuy+WEEzF
	 smzy8VKX4aB9UfMolvctYLpTKdYuDDRnMUM1qeInnAr4jrWPVTYlAYb873JClZTq4yN59
	 OJj5Oto5rxWOCVjaXV7MiiVKZMamFEXrN186XxHVYVg8pljfNMPceSOffMHwNUf/vtsvM
	 fuY/DO57FYV2x8L6WzYmWYkY9x7aRsqybD0nixzL9dhqVc7/79D0+gNM6sYue510I8WbM
	 xa3SuhR6rh1tUu+nWvIZ6c82jWXsgqPyeprbLI+YMlH4lgVHE6Y6eOzQXLU17ZlFQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bOIvB3O5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E17B606A89A
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bOIvB3O5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02E01F000C8;
	Fri, 13 Nov 2026 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794537679;
	bh=QNaXxlN2ZsJ68a8IX+qwHDYBnbGl+8DZAI4/GtpaXOI=;
	h=Date:To:From:Subject;
	b=bOIvB3O58PKA66CLAo4qtkj8IlMmgn6Uek8HOfQYbBGF7RV0vWRhnY4z19TuZ9uRC
	 FOlM+nOJVfnCmOML6u7VSm7TllDvndiuFhxqa4Y3rCe8WQxgo85atrrHt9ezdt/mpS
	 +ebJ7PcsNDtanNTZpU4jhkmj4CVFEjtEbHAMNbl4=
Date: Thu, 12 Nov 2026 18:41:18 -0800
To: mm-commits@vger.kernel.org,richard@nod.at,johannes@sipsolutions.net,
	hch@lst.de,anton.ivanov@cambridgegreys.com,ebiggers@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-opt-out-of-initializing-mxcsr-and-387-state.patch added to mm-nonmm-unstable branch
Message-Id: <20261113024118.E02E01F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: opt out of initializing MXCSR and 387 state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-opt-out-of-initializing-mxcsr-and-387-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-opt-out-of-initializing-mxcsr-and-387-state.patch

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
From: Eric Biggers <ebiggers@kernel.org>
Subject: raid6: opt out of initializing MXCSR and 387 state
Date: Wed, 11 Nov 2026 12:56:04 -0800

The RAID6 code using "kernel-mode FPU" is integer code that does not use
any MMX or x87 instructions.  (MMX optimized code previously existed but
was recently removed.)  To the extent that float-domain instructions are
used at all, they are only moves, shuffles, and XORs, none of which
raises SIMD floating-point exceptions or depends on MXCSR.

Therefore, there's no need to initialize MXCSR or the 387 FPU state.

Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
every kernel-mode FPU section, reducing overhead, which matters most for
short input lengths.  On 32-bit kernels it also eliminates 'fninit'.

This will make the RAID code consistent with the crypto and CRC code,
which are also switching to kernel_fpu_begin_mask(0)
(https://lore.kernel.org/linux-crypto/20261105005523.84925-1-ebiggers@kernel.org/).
Another precedent for this optimization can be found in
commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
don't need a valid MXCSR state").

Link: https://lore.kernel.org/20261111205604.47547-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---

 lib/raid/raid6/x86/avx2.c         |   12 ++++++------
 lib/raid/raid6/x86/avx512.c       |   12 ++++++------
 lib/raid/raid6/x86/recov_avx2.c   |    4 ++--
 lib/raid/raid6/x86/recov_avx512.c |    4 ++--
 lib/raid/raid6/x86/recov_ssse3.c  |    4 ++--
 lib/raid/raid6/x86/sse2.c         |   12 ++++++------
 6 files changed, 24 insertions(+), 24 deletions(-)

--- a/lib/raid/raid6/x86/avx2.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/avx2.c
@@ -32,7 +32,7 @@ static void raid6_avx21_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm3,%ymm3,%ymm3");	/* Zero temp */
@@ -82,7 +82,7 @@ static void raid6_avx21_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
@@ -139,7 +139,7 @@ static void raid6_avx22_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm1,%ymm1,%ymm1"); /* Zero temp */
@@ -192,7 +192,7 @@ static void raid6_avx22_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
@@ -271,7 +271,7 @@ static void raid6_avx24_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm1,%ymm1,%ymm1");	/* Zero temp */
@@ -353,7 +353,7 @@ static void raid6_avx24_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" :: "m" (raid6_avx2_constants.x1d[0]));
 
--- a/lib/raid/raid6/x86/avx512.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/avx512.c
@@ -34,7 +34,7 @@ static void raid6_avx5121_gen_syndrome(i
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1" /* Zero temp */
@@ -93,7 +93,7 @@ static void raid6_avx5121_xor_syndrome(i
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
@@ -161,7 +161,7 @@ static void raid6_avx5122_gen_syndrome(i
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1" /* Zero temp */
@@ -225,7 +225,7 @@ static void raid6_avx5122_xor_syndrome(i
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
@@ -320,7 +320,7 @@ static void raid6_avx5124_gen_syndrome(i
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1\n\t"       /* Zero temp */
@@ -415,7 +415,7 @@ static void raid6_avx5124_xor_syndrome(i
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     :: "m" (raid6_avx512_constants.x1d[0]));
--- a/lib/raid/raid6/x86/recov_avx2.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/recov_avx2.c
@@ -43,7 +43,7 @@ static void raid6_2data_recov_avx2(int d
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	/* ymm0 = x0f[16] */
 	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
@@ -205,7 +205,7 @@ static void raid6_datap_recov_avx2(int d
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
 
--- a/lib/raid/raid6/x86/recov_avx512.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/recov_avx512.c
@@ -48,7 +48,7 @@ static void raid6_2data_recov_avx512(int
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	/* zmm0 = x0f[16] */
 	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
@@ -243,7 +243,7 @@ static void raid6_datap_recov_avx512(int
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
 
--- a/lib/raid/raid6/x86/recov_ssse3.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/recov_ssse3.c
@@ -44,7 +44,7 @@ static void raid6_2data_recov_ssse3(int
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm7" : : "m" (x0f[0]));
 
@@ -210,7 +210,7 @@ static void raid6_datap_recov_ssse3(int
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0, %%xmm7" : : "m" (x0f[0]));
 
--- a/lib/raid/raid6/x86/sse2.c~raid6-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/raid6/x86/sse2.c
@@ -28,7 +28,7 @@ static void raid6_sse21_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5");	/* Zero temp */
@@ -80,7 +80,7 @@ static void raid6_sse21_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
@@ -136,7 +136,7 @@ static void raid6_sse22_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5"); /* Zero temp */
@@ -189,7 +189,7 @@ static void raid6_sse22_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
@@ -266,7 +266,7 @@ static void raid6_sse24_gen_syndrome(int
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm2,%xmm2");	/* P[0] */
@@ -353,7 +353,7 @@ static void raid6_sse24_xor_syndrome(int
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch
um-define-kernel_fpu_begin_mask.patch
xor-opt-out-of-initializing-mxcsr-and-387-state.patch
raid6-opt-out-of-initializing-mxcsr-and-387-state.patch

