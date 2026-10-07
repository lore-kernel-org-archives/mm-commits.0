Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F813515F9;
	Wed,  7 Oct 2026 02:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338668; cv=none; b=d/7TRdIZg0deNvOOnnSmP8xIGPN32g/gdgnKA2jwvs909IQxaDLMrkVVyPUsqKfBHlfKtHrd9D8XgTZfA4QCZV6PEl2UsVtDOS+faXsDgTbUExNcfnc7Uqvv3G3zajS0tDUzavXRfbwkOnn5F7/rbr1qkTjYshnBokXOFi9yVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338668; c=relaxed/simple;
	bh=QINUuzFpr17r3c4YA3S4Iq3/s0w5s7ThD++15jl2P68=;
	h=Date:To:From:Subject:Message-Id; b=Z/jLL36CD0pDVjavsm6pfKOev5ErsTN9X21HNXTSJkO6OCLc9rH8wHbY94wwUZmxjjLV+vn4kBW8i4rzJoARHh7QUaa/Guiq+ssyiCE6t4jt/AJAYZiEOLRlY7EJ1A7VmjGJc+B7Lm/mmtUv9OIMHHd5GlBzg53dK0qxy6b1ej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ym+uo8Di; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ym+uo8Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2616B1F0089C;
	Wed,  7 Oct 2026 02:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338667;
	bh=ORTv6KZY3vaGo2B2K0ZHXBPe5YtU6LKTJXyUGEInCgA=;
	h=Date:To:From:Subject;
	b=Ym+uo8Dia1I/N4IpcGWAy16iYCpKlNFjZoojJNxOL4axpK0lzaS6ttq2Vp9cDXfDZ
	 3V9PezpfDQeebdjVKg5SVQOL5z6AdCgmrgeARNqB9lwabIhpCdiccZNcSbfnP32vA0
	 p7BwU0FePHUHOgzMasinoSIhUo4MqyasbBh3UMDM=
Date: Tue, 06 Oct 2026 19:04:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-add-missing-vzeroupper-to-avx2-code.patch removed from -mm tree
Message-Id: <20261007020427.2616B1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: add missing vzeroupper to AVX2 code
has been removed from the -mm tree.  Its filename was
     raid6-add-missing-vzeroupper-to-avx2-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: raid6: add missing vzeroupper to AVX2 code
Date: Mon, 31 Aug 2026 14:23:08 -0700

Since the AVX2 optimized RAID6 code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212308.213855-1-ebiggers@kernel.org
Fixes: 2c935842bdb4 ("lib/raid6: Add AVX2 optimized gen_syndrome functions")
Fixes: 7056741fd9fc ("lib/raid6: Add AVX2 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
---

 lib/raid/raid6/x86/avx2.c       |    6 ++++++
 lib/raid/raid6/x86/recov_avx2.c |    2 ++
 2 files changed, 8 insertions(+)

--- a/lib/raid/raid6/x86/avx2.c~raid6-add-missing-vzeroupper-to-avx2-code
+++ a/lib/raid/raid6/x86/avx2.c
@@ -67,6 +67,7 @@ static void raid6_avx21_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -115,6 +116,7 @@ static void raid6_avx21_xor_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -175,6 +177,7 @@ static void raid6_avx22_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -243,6 +246,7 @@ static void raid6_avx22_xor_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -334,6 +338,7 @@ static void raid6_avx24_gen_syndrome(int
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -444,6 +449,7 @@ static void raid6_avx24_xor_syndrome(int
 		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
--- a/lib/raid/raid6/x86/recov_avx2.c~raid6-add-missing-vzeroupper-to-avx2-code
+++ a/lib/raid/raid6/x86/recov_avx2.c
@@ -176,6 +176,7 @@ static void raid6_2data_recov_avx2(int d
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -293,6 +294,7 @@ static void raid6_datap_recov_avx2(int d
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are


