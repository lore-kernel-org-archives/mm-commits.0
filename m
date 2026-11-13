Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537676;
	b=1/NcfQrESa/D/Eq7e5Lm8HeX9CcVcRYn+E6dk5IKUzxtBvSBycNAbMOffPkG3kEoVlIf
	 cghMnhD2oK/ddA2WLdywNWIq734ZOxROmtf3Gbb7qcZtvgG/Yve3a0fVQEjv+GQo9lg6V
	 yPaYZcQavWq9ed2XCX+digPzu7V0aHEVgdRHcba1Pq8aqpa++YD+GgE+7uVIrPwP1L4Nu
	 uRcflc0csIBhkb86DTEZPPNN/L5R0pZ8k5SHt8RYhmA4Kf7HjXE3/PKOlwyjGLhKKgGob
	 gms+SbT15x6Nz3c9zTrW2YTP1onOfy7YKM2f+awRElZe6kUdFpXJMEFaTaU2H5Sqr6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537676;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RRwsg83IcWmdUXUyG0zCS7oHjX/HFTQF7UwwPawTD0k=;
	b=uK0nemN8y+/0JR3Vc4ZXsFcO+NiW0QQARKCUlI6sTtlvD17WaRJwh7aNRb2tf9e47Xfh
	 Dh95w6M5GcGIwx9iA3t2cLzTbk7ZXZGLz/j7cG9qdoGDWtdDLgnxTrNDgKjVZoaOreIqt
	 vOLCvkloCy+hIdtuFs86B/Z9oDeHna4wx3v6cQu0YXF80yNm2ckpEu0m/Is9p1hp4JVhW
	 EXwXLEyfZGjFFkm+TWCs3K/83xyKFdR99kmd2BxHNzoGd0s7DiubrCdZmtth7iI6Ht+Fo
	 h6jsMEWMuronfOw0dj2esM327tklYRzh/UwEU+2L6Hh0b5uH9C/L0jiUxHLreQwcw5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y6R2gigM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3E606A33A
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y6R2gigM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3D1F000C9;
	Fri, 13 Nov 2026 02:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794537675;
	bh=RRwsg83IcWmdUXUyG0zCS7oHjX/HFTQF7UwwPawTD0k=;
	h=Date:To:From:Subject;
	b=y6R2gigM5JP80jfKgJ+LPPlxCg4rnorBD4yUgDdsSHkJOxGPcvOB/25xpztpzsPa7
	 IZ+k5zcD5KM8qQVYkB8wLS+kx7YVK8izWiAFH1yMZ3w3QtzXQWM8TA/fKHmu/2PjzV
	 buXDs0DYwhEWczr2BoiiszurRLfFIxfKQcg+m4no=
Date: Thu, 12 Nov 2026 18:41:15 -0800
To: mm-commits@vger.kernel.org,richard@nod.at,johannes@sipsolutions.net,
	hch@lst.de,anton.ivanov@cambridgegreys.com,ebiggers@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-opt-out-of-initializing-mxcsr-and-387-state.patch added to mm-nonmm-unstable branch
Message-Id: <20261113024115.A0C3D1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: xor: opt out of initializing MXCSR and 387 state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-opt-out-of-initializing-mxcsr-and-387-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-opt-out-of-initializing-mxcsr-and-387-state.patch

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
Subject: xor: opt out of initializing MXCSR and 387 state
Date: Wed, 11 Nov 2026 12:56:03 -0800

The XOR code using "kernel-mode FPU" is integer code that does not use
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

Link: https://lore.kernel.org/20261111205604.47547-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---

 lib/raid/xor/x86/xor-avx.c    |    2 +-
 lib/raid/xor/x86/xor-avx512.c |    2 +-
 lib/raid/xor/x86/xor-sse.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/lib/raid/xor/x86/xor-avx512.c~xor-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/xor/x86/xor-avx512.c
@@ -110,7 +110,7 @@ DO_XOR_BLOCKS(avx512_inner, xor_avx512_2
 static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
 			   unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
--- a/lib/raid/xor/x86/xor-avx.c~xor-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/xor/x86/xor-avx.c
@@ -145,7 +145,7 @@ DO_XOR_BLOCKS(avx_inner, xor_avx_2, xor_
 static void xor_gen_avx(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
--- a/lib/raid/xor/x86/xor-sse.c~xor-opt-out-of-initializing-mxcsr-and-387-state
+++ a/lib/raid/xor/x86/xor-sse.c
@@ -432,7 +432,7 @@ DO_XOR_BLOCKS(sse_inner, xor_sse_2, xor_
 static void xor_gen_sse(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_sse_inner(dest, srcs, src_cnt, bytes);
 	kernel_fpu_end();
 }
@@ -448,7 +448,7 @@ DO_XOR_BLOCKS(sse_pf64_inner, xor_sse_2_
 static void xor_gen_sse_pf64(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_sse_pf64_inner(dest, srcs, src_cnt, bytes);
 	kernel_fpu_end();
 }
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch
um-define-kernel_fpu_begin_mask.patch
xor-opt-out-of-initializing-mxcsr-and-387-state.patch
raid6-opt-out-of-initializing-mxcsr-and-387-state.patch

