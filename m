Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795401407;
	b=MZ9AYq6YwwbGHUuJiq1JP/UGMZ6KeJhMg+U+AxG/Oj8q2IgnLb72BYHCZRz9cFgMxgRa
	 YQJE7W7XYYFTO1gb0IPn7AUlc7YQlzSLCq0AV5oRJM1BHYZ3wJA0WHvbwxlY/bYKxcgXn
	 a7XEMFYKYSU8A6OeCmfJoj9Cuwv2FXNkkDjssfwCil78P+d8WtonfUu6QoSVnjBGRkvK+
	 BPya/z/zI9k4RAGq3wl79h2EVkOVtneWG4QxTyZ3TQW4Dd0363EEgR8NTTTo3XpzipxHu
	 jGBuOLklNfi2irr3qldu5h6enS/VUjnwykQFvbJM/sIy887ZadcjLjaO6gy5nuYE4hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795401407;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ILvGwMGKnK/kFzYTG5OfqXKUQuxZ/PqmWvHJtDkKCHs=;
	b=Y/38HLaKU5skvqsvnB6Prp6twzJlnyFXPE4mmZBbyHpj7En5m3N8dmfqxRP4X9bjysC4
	 Ak0bftawxtVUpCEVLTfuBnrkmYKJAqOindHfJ7qvGqXVRZEBLO1iPg8L677J/zhx89qOa
	 0DuNs0JVUBYkxT+ow2Niv9gqp5ju81fQ8QlhXfMqKlTHsjUK8SY2Rvk40XGkugTF3zGBw
	 uIOwoMZE9ZmhjmO5NZZEr2Nzrn7/b7zl7iJaM5PPUEZaOeNJeJbKXRFgcyGBguiARAMEE
	 lHd3ocYaequGeWYsKSai39xbcFSaVNT3LctjhdKOqprUfB1CPTsel8bXbkHonJk+spg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=us8QY8wA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C736B60A2605
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 02:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=us8QY8wA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9A41F000E1;
	Mon, 23 Nov 2026 02:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795401407;
	bh=ILvGwMGKnK/kFzYTG5OfqXKUQuxZ/PqmWvHJtDkKCHs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=us8QY8wAs7bGL9dr0Jrf9KwUXqzbss2THC1Nx6BEX7/kCMLlfwzhb6e+RTZjlAxbb
	 YrdQo2zUGoG/j+f/j6G2lxyaPUN1H5sNSAavyAK/gSes9xqpvTC1wKXjwD8xgs+8Ey
	 koIGltg/ssFObANKguBOqM1063sNRb41mtjaM0dA=
Date: Sun, 22 Nov 2026 18:36:46 -0800
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,
	markus.stockhausen@collogia.de,magiclinan@didiglobal.com,hch@lst.de,
	ebiggers@kernel.org,david.laight.linux@gmail.com,mc@raidlab.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122032933.2306875-4-mc@raidlab.org>
References: <20261122032933.2306875-4-mc@raidlab.org>
Subject: + raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261123023646.ED9A41F000E1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: prefetch Q with prefetcht0 in the x86 x4 xor_syndrome functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch

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
Subject: raid6: prefetch Q with prefetcht0 in the x86 x4 xor_syndrome functions
Date: Sun, 22 Nov 2026 03:29:33 +0000

The x4 xor_syndrome() functions for SSE2, AVX2 and AVX-512 prefetch Q
with prefetchnta. That hint is meant for data that is used once. Q is
read, updated and written back with normal stores, and md calls
xor_syndrome() twice on the same P/Q page for each write.

Prefetch Q with prefetcht0, which keeps it in all cache levels. The data
blocks are read once and keep prefetchnta.

Time per write measured in a userspace harness in md's read-modify-write
pattern (two xor_syndrome() calls on the same P/Q page), avx512x4 on a
Xeon Gold 6130, 2-24 data disks, write to the first, middle and last
data disk, median of 10 passes:

  P and Q in DRAM:      -2.2% (geometric mean), up to -5.7%
  P and Q in L3:        +0.2%
  P and Q in L1/L2:     +0.3%

The gain comes with 2-8 data disks, where Q is a larger part of the
work. The SSE2 and AVX2 versions were not measured.

Link: https://patch.msgid.link/20261122032933.2306875-4-mc@raidlab.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Markus Stockhausen <markus.stockhausen@collogia.de>

 lib/raid/raid6/x86/avx2.c   |    4 ++--
 lib/raid/raid6/x86/avx512.c |    4 ++--
 lib/raid/raid6/x86/sse2.c   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/lib/raid/raid6/x86/avx2.c~raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx2.c
@@ -408,8 +408,8 @@ static void raid6_avx24_xor_syndrome(int
 			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 		}
-		asm volatile("prefetchnta %0" :: "m" (q[d]));
-		asm volatile("prefetchnta %0" :: "m" (q[d+64]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d+64]));
 		/* P/Q left side optimization */
 		for (z = start-1 ; z >= 0 ; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
--- a/lib/raid/raid6/x86/avx512.c~raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx512.c
@@ -476,8 +476,8 @@ static void raid6_avx5124_xor_syndrome(i
 				       "m" (dptr[z][d+128]),
 				       "m" (dptr[z][d+192]));
 		}
-		asm volatile("prefetchnta %0\n\t"
-			     "prefetchnta %1\n\t"
+		asm volatile("prefetcht0 %0\n\t"
+			     "prefetcht0 %1\n\t"
 			     :
 			     : "m" (q[d]), "m" (q[d+128]));
 		/* P/Q left side optimization */
--- a/lib/raid/raid6/x86/sse2.c~raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/sse2.c
@@ -405,8 +405,8 @@ static void raid6_sse24_xor_syndrome(int
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 		}
-		asm volatile("prefetchnta %0" :: "m" (q[d]));
-		asm volatile("prefetchnta %0" :: "m" (q[d+32]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d+32]));
 		/* P/Q left side optimization */
 		for ( z = start-1 ; z >= 0 ; z-- ) {
 			asm volatile("pxor %xmm5,%xmm5");
_

Patches currently in -mm which might be from mc@raidlab.org are

raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch
raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch
raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch
raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch

