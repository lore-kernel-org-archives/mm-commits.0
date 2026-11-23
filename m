Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795413278;
	b=Mb5apUl9yn1FqudwsZ1TcQnom4gttu2cDhHrcW52q1s0daspv1d7nR3zR8H93a0C7ctN
	 rh/2Ir4GWLyuswp4/lMEdKs2nM5tgq8Z4zWjWtK7qQJvtMoaqxwkHI+v0ZhVIG7duJRfI
	 C/F5jwZ4uvBTDcJ+tyfLcxJJm9oZ91yi+E36BiilqbH0poXPENrJI1AIHnlfHst4npWMi
	 tl8q3Tks9kjRpu01f+AobOS0Ck4Hk9oI8eIBSmP8JtYrDE53wkRwD9hHfXN7uIKXgNHi5
	 nIL6YNtBz6yv46hBTR9ty1H855Uga56J0OvuPFlfX632WOHhEYKNcSjUqOQvBIzY/Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795413278;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=1FKjJvIFK+cNtArsl8ZfnnINVxUxZCreIYQ5APpDLGE=;
	b=BS5GkmwihqgfjPb3/16UOpZhkroTErtWEMHI5+znV0fIZli9mdcOMLduqlm4LLllmPWi
	 4THrEYmQHqQzzWnF4pn6ENAKfpofDnUlY1s8LfowIwShsDDUlXclvXMkizfymPUPpqF+B
	 xnb5PQrHmD3UPzbXBxlIDTLj2mSa+AAnxLZbD744nJVY/Cq3YGi4NdJBcXvhuJiYbXtu9
	 rnKLNweW+A8yPtxTqYP3DiX68jHqpj106bAMEx4s0BXLT7a9mTxWg92YzHLPUkxOaA0sV
	 QhC1fbdoZHHcKVvSFjjrfZauAfJxG4ZuXA9CD+zmj4eFjBearY6cUNKdXRtrZapS+7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q6Ar3UmS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D722606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 05:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q6Ar3UmS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7571F000CA;
	Mon, 23 Nov 2026 05:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795413278;
	bh=1FKjJvIFK+cNtArsl8ZfnnINVxUxZCreIYQ5APpDLGE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Q6Ar3UmS9MJVRrCUSLPTfhs9K2qNk+5cx07qA7B44L9uHlWogJXH/DLvk9z/ddgD8
	 qqUKQlAGhdfdWiReF6pRXN41E8IgL4kCX66aanCAlk+T4lDREPu7D/RKwNHUuQlO1m
	 i6zrX7/ptH3XxECCpcsXhcKid6phKr8Ewy6K98is=
Date: Sun, 22 Nov 2026 21:54:37 -0800
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,
	markus.stockhausen@collogia.de,magiclinan@didiglobal.com,hch@lst.de,
	ebiggers@kernel.org,david.laight.linux@gmail.com,mc@raidlab.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122032933.2306875-3-mc@raidlab.org>
References: <20261122032933.2306875-3-mc@raidlab.org>
Subject: + raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261123055437.DB7571F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: remove the sfence from the x86 xor_syndrome functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch

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
Subject: raid6: remove the sfence from the x86 xor_syndrome functions
Date: Sun, 22 Nov 2026 03:29:32 +0000

The SSE2, AVX2 and AVX-512 xor_syndrome() functions end with an sfence.
It orders non-temporal stores, but none of these functions uses them
anymore. The x4 versions stopped with "raid6: use normal stores in the
x86 x4 xor_syndrome functions", and the x1 and x2 versions never used
them.

Remove the sfence from all nine functions. The gen_syndrome() functions
still write P and Q with non-temporal stores and keep their sfence.

The asm of the AVX-512 functions relied on the "memory" clobber of the
sfence. "raid6: declare the AVX-512 P/Q stores as asm outputs" declares
their stores as outputs instead.

The memory operands are still declared as single bytes while the asm
accesses 16 to 64 bytes. This is unchanged. No C code in these functions
accesses the buffers.

Link: https://patch.msgid.link/20261122032933.2306875-3-mc@raidlab.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-raid/avqegZd_W0kce0UA@infradead.org/
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Markus Stockhausen <markus.stockhausen@collogia.de>

 lib/raid/raid6/x86/avx2.c   |    3 ---
 lib/raid/raid6/x86/avx512.c |    3 ---
 lib/raid/raid6/x86/sse2.c   |    3 ---
 3 files changed, 9 deletions(-)

--- a/lib/raid/raid6/x86/avx2.c~raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx2.c
@@ -115,7 +115,6 @@ static void raid6_avx21_xor_syndrome(int
 		asm volatile("vmovdqa %%ymm2,%0" : "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -245,7 +244,6 @@ static void raid6_avx22_xor_syndrome(int
 		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d+32]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -448,7 +446,6 @@ static void raid6_avx24_xor_syndrome(int
 		asm volatile("vmovdqa %%ymm12,%0" : "=m" (q[d+64]));
 		asm volatile("vmovdqa %%ymm14,%0" : "=m" (q[d+96]));
 	}
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
--- a/lib/raid/raid6/x86/avx512.c~raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/avx512.c
@@ -135,7 +135,6 @@ static void raid6_avx5121_xor_syndrome(i
 			     : "+m" (q[d]), "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -290,7 +289,6 @@ static void raid6_avx5122_xor_syndrome(i
 			       "=m" (p[d+64]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -527,7 +525,6 @@ static void raid6_avx5124_xor_syndrome(i
 			       "=m" (p[d+192]), "+m" (q[d]), "+m" (q[d+64]),
 			       "+m" (q[d+128]), "+m" (q[d+192]));
 	}
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
--- a/lib/raid/raid6/x86/sse2.c~raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions
+++ a/lib/raid/raid6/x86/sse2.c
@@ -113,7 +113,6 @@ static void raid6_sse21_xor_syndrome(int
 		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
@@ -241,7 +240,6 @@ static void raid6_sse22_xor_syndrome(int
 		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
@@ -445,7 +443,6 @@ static void raid6_sse24_xor_syndrome(int
 		asm volatile("movdqa %%xmm12,%0" : "=m" (q[d+32]));
 		asm volatile("movdqa %%xmm14,%0" : "=m" (q[d+48]));
 	}
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
_

Patches currently in -mm which might be from mc@raidlab.org are

raid6-use-normal-stores-in-the-x86-x4-xor_syndrome-functions.patch
raid6-declare-the-avx-512-p-q-stores-as-asm-outputs.patch
raid6-remove-the-sfence-from-the-x86-xor_syndrome-functions.patch
raid6-prefetch-q-with-prefetcht0-in-the-x86-x4-xor_syndrome-functions.patch

