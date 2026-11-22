Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795307117;
	b=bJVh04NF6KgpDliD2U7grGChT2mt5+16Sfx3J8CRT0UwkWTGRgU8n+GGW1JEbn5amVbQ
	 tD9F6HFvWZ1s8k9112eQI1crfI+DV7t9I7OMge6UKRO3RG0+/u97ea8R26b8h3x4fVbXb
	 dUKVl49pPc5+xvxRg9+URrejQ6V8nSFCd3XdXqZt4/HwXjL+zPWee5hsqO6CeuhBBsuhx
	 CqKReUT6NuRuDSoenssxJgNNa6qzkB92+P0hr1Yvu4Fqj2Xrc6Hai8BrbZLgTRmJg29dL
	 lp4OdptkITpSEeZ3YhHXiNYpRcbTXUiFd1S3nTfsCJbvCfgyrd5zBYtvDeEOJoXBXkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795307117;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XEDK3fnDkMIykWOli3zsBv4eVNMO1CeXhsyQbBhPp0k=;
	b=P6/XMJG06Y6OyvSp0MaylKy+l0Gltg6oIKCGhbuFYnsEXKA2b3cisDZT+sJmg2BsHNgU
	 A6bOOeZU+3hOmjqruL0KfmU72hylef7HPDqJ2w+vo6G8W7c9LwYduY03xciXLxitcIrLG
	 HfKTAVv86KcyzmFatGyriU7PlNeT1CbcQrdO72WRgBg6yda2G+GuVHJlX4VC99iScUhuN
	 lTXs++YGoUQtmdwmT+VpnnQ0YwNX52CvDW6Wm4fX8nRO3AEjnqTIT16kBd5BEWq2hM4Ck
	 vf8npVvuRMfhu98TDxQYcu12s4wi7Dy/oHJEpb4L+APBnDE8ywSDt+xfyOCI83uynNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uzoXxrU8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF142606A320
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uzoXxrU8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B1F1F000C4;
	Sun, 22 Nov 2026 00:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795307116;
	bh=XEDK3fnDkMIykWOli3zsBv4eVNMO1CeXhsyQbBhPp0k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=uzoXxrU8bVvqq37VsyYQbkn1sR9kepYjgPmhYvwoSm0hak73QqhKNua8Xuy1UMWoh
	 Zj4nRiTSpkCNJucq5fYNdakcZZJOTBcVcWfvdRw/GBKHn6SH9peg9MK8CohWWtO/6C
	 rHlOcg+/na6IgPKmczyW9MUxcQF+e0gYgNWrXiKs=
Date: Sat, 21 Nov 2026 16:25:15 -0800
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,
	markus.stockhausen@collogia.de,magiclinan@didiglobal.com,hch@lst.de,
	ebiggers@kernel.org,david.laight.linux@gmail.com,ardb@kernel.org,
	antosha20xx@gmail.com,mc@raidlab.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261109030805.25709-1-mc@raidlab.org>
References: <20261109030805.25709-1-mc@raidlab.org>
Subject: + raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261122002516.51B1F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: use normal stores in the x86 x4 xor_syndrome functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch

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
Subject: raid6: use normal stores in the x86 x4 xor_syndrome functions
Date: Mon, 09 Nov 2026 03:08:05 +0000

xor_syndrome() updates P and Q in place for a read-modify-write.  md calls
it twice on the same P/Q page per write, to remove the old data and to add
the new data.  The x1 and x2 unrolled versions write P and Q with normal
stores since commit a582564b24be ("md/raid6 algorithms: xor_syndrome() for
SSE2"), which argued that non-temporal stores of less than a cache line
are slow, but kept non-temporal stores in the x4 version, as it writes
whole cache lines.  The AVX2 and AVX-512 versions followed the same
pattern.

The non-temporal stores evict P and Q from the cache and the sfence waits
until they are written to memory, just before the second call reads the
same P and Q again, now from memory.

Use normal aligned stores in the x4 unrolled versions too, like the x1 and
x2 versions and the other architectures.

md RAID-6, 4 KiB random writes, md thread on one core, Xeon E5-2699 v3:

  8+2 on null_blk (dm-raid):     85.6k -> 98.1k IOPS (+15%)
  6+2 on 8 Intel Optane M10:     57.3k -> 62.1k IOPS (+8%)

Change in time per write in md's pattern (both calls and the 4 KiB copy
between them), kernel code built in userspace, one core, geometric
mean over 2-24 data disks, data in cache / DRAM:

  avx2x4 (Xeon E5-2699 v3):  -66% / -38%
  avx512x4 (Xeon Gold 6130): -78% / -48%
  sse2x4 (Core i5-2520M):    -37% / -19%

Link: https://patch.msgid.link/20261109030805.25709-1-mc@raidlab.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Anton Gavriliuk <antosha20xx@gmail.com>
  Link: https://lore.kernel.org/CAAiJnjqrRo-75jg_Jrr0x2r85kY2g6_ZSH%2B8ukyJJ5UXyMb6pA@mail.gmail.com
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Markus Stockhausen <markus.stockhausen@collogia.de>

 lib/raid/raid6/x86/avx2.c   |   16 ++++++++--------
 lib/raid/raid6/x86/avx512.c |   16 ++++++++--------
 lib/raid/raid6/x86/sse2.c   |   16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

--- a/lib/raid/raid6/x86/avx2.c~raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx2.c
@@ -435,18 +435,18 @@ static void raid6_avx24_xor_syndrome(int
 			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 		}
-		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
-		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
-		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d+64]));
-		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d+96]));
+		asm volatile("vmovdqa %%ymm2,%0" : "=m" (p[d]));
+		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d+32]));
+		asm volatile("vmovdqa %%ymm10,%0" : "=m" (p[d+64]));
+		asm volatile("vmovdqa %%ymm11,%0" : "=m" (p[d+96]));
 		asm volatile("vpxor %0,%%ymm4,%%ymm4" : : "m" (q[d]));
 		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d+32]));
 		asm volatile("vpxor %0,%%ymm12,%%ymm12" : : "m" (q[d+64]));
 		asm volatile("vpxor %0,%%ymm14,%%ymm14" : : "m" (q[d+96]));
-		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
-		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
-		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d+64]));
-		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
+		asm volatile("vmovdqa %%ymm4,%0" : "=m" (q[d]));
+		asm volatile("vmovdqa %%ymm6,%0" : "=m" (q[d+32]));
+		asm volatile("vmovdqa %%ymm12,%0" : "=m" (q[d+64]));
+		asm volatile("vmovdqa %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
--- a/lib/raid/raid6/x86/avx512.c~raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx512.c
@@ -516,18 +516,18 @@ static void raid6_avx5124_xor_syndrome(i
 				     :
 				     : );
 		}
-		asm volatile("vmovntdq %%zmm2,%0\n\t"
-			     "vmovntdq %%zmm3,%1\n\t"
-			     "vmovntdq %%zmm10,%2\n\t"
-			     "vmovntdq %%zmm11,%3\n\t"
+		asm volatile("vmovdqa64 %%zmm2,%0\n\t"
+			     "vmovdqa64 %%zmm3,%1\n\t"
+			     "vmovdqa64 %%zmm10,%2\n\t"
+			     "vmovdqa64 %%zmm11,%3\n\t"
 			     "vpxorq %4,%%zmm4,%%zmm4\n\t"
 			     "vpxorq %5,%%zmm6,%%zmm6\n\t"
 			     "vpxorq %6,%%zmm12,%%zmm12\n\t"
 			     "vpxorq %7,%%zmm14,%%zmm14\n\t"
-			     "vmovntdq %%zmm4,%4\n\t"
-			     "vmovntdq %%zmm6,%5\n\t"
-			     "vmovntdq %%zmm12,%6\n\t"
-			     "vmovntdq %%zmm14,%7"
+			     "vmovdqa64 %%zmm4,%4\n\t"
+			     "vmovdqa64 %%zmm6,%5\n\t"
+			     "vmovdqa64 %%zmm12,%6\n\t"
+			     "vmovdqa64 %%zmm14,%7"
 			     :
 			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
 			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
--- a/lib/raid/raid6/x86/sse2.c~raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/sse2.c
@@ -432,18 +432,18 @@ static void raid6_sse24_xor_syndrome(int
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 		}
-		asm volatile("movntdq %%xmm2,%0" : "=m" (p[d]));
-		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d+16]));
-		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d+32]));
-		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d+48]));
+		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
+		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
+		asm volatile("movdqa %%xmm10,%0" : "=m" (p[d+32]));
+		asm volatile("movdqa %%xmm11,%0" : "=m" (p[d+48]));
 		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
 		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
 		asm volatile("pxor %0,%%xmm12" : : "m" (q[d+32]));
 		asm volatile("pxor %0,%%xmm14" : : "m" (q[d+48]));
-		asm volatile("movntdq %%xmm4,%0" : "=m" (q[d]));
-		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d+16]));
-		asm volatile("movntdq %%xmm12,%0" : "=m" (q[d+32]));
-		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d+48]));
+		asm volatile("movdqa %%xmm4,%0" : "=m" (q[d]));
+		asm volatile("movdqa %%xmm6,%0" : "=m" (q[d+16]));
+		asm volatile("movdqa %%xmm12,%0" : "=m" (q[d+32]));
+		asm volatile("movdqa %%xmm14,%0" : "=m" (q[d+48]));
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
_

Patches currently in -mm which might be from mc@raidlab.org are

raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch

