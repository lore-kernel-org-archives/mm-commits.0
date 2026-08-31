Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D49938CFE4;
	Mon, 31 Aug 2026 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214473; cv=none; b=q2QHctlP7mKeCDF4mHBtxDLuUYxpiVC+oZIuTGb6iMcQZj/rFHnFKMIifofYNAwhbSogIzvUKPQk1pwB6+whN+GD6hIRDEZ7rQQuMkHFDhG7IZS1evAzQZRXCJuIzlVJpPl95L0BA1Q5ZJU2QZzAxpNn6RS8YwClyoR9aPYAkds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214473; c=relaxed/simple;
	bh=xCaDVobVYYNkSujYCb2LRiiVIL46YlvHZvztPPiDOZY=;
	h=Date:To:From:Subject:Message-Id; b=cQj2s1VRvEjPwcrWpFmUOVxGhoAtic3vQHZil2Mk8CpooBwVxvxUFhMA1WLcmkqwAk+d6Db+VWOv4phgShzvofQlaVYSqrm+pWjdJNfa8ADQz28F7jawGHFR+VbyiuTx0vwRY6mbgG2WO5IrHqqGQpQQwwGXdMxOpqFE55T6vH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R9Z4Q4uY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R9Z4Q4uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5FA1F000E9;
	Mon, 31 Aug 2026 22:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788214471;
	bh=unBlQ57kvOCVfpI6Wqq6zgNJfvWz/L0c6etL3R8dy48=;
	h=Date:To:From:Subject;
	b=R9Z4Q4uY/wF605JXqX30gvXYrim8TbFdi1L6lYNSp7ylnVLVUD+6Hp5nkEZlKdIvM
	 dl1REhuneKi3PwPvNV2j6OY1xHTfSTucN68bZtQrFLyhzVvR7fLs2TPZRdo94aaZ3f
	 ysU3JxC/cXtkIXXIm6ZpufMe/KDAbV3pLPVLfm4w=
Date: Mon, 31 Aug 2026 15:14:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-add-missing-vzeroupper-to-avx-512-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260831221431.8E5FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: add missing vzeroupper to AVX-512 code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-add-missing-vzeroupper-to-avx-512-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-add-missing-vzeroupper-to-avx-512-code.patch

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
Subject: raid6: add missing vzeroupper to AVX-512 code
Date: Mon, 31 Aug 2026 14:23:16 -0700

Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212316.213896-1-ebiggers@kernel.org
Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome functions")
Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/x86/avx512.c       |    6 ++++++
 lib/raid/raid6/x86/recov_avx512.c |    2 ++
 2 files changed, 8 insertions(+)

--- a/lib/raid/raid6/x86/avx512.c~raid6-add-missing-vzeroupper-to-avx-512-code
+++ a/lib/raid/raid6/x86/avx512.c
@@ -78,6 +78,7 @@ static void raid6_avx5121_gen_syndrome(i
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -137,6 +138,7 @@ static void raid6_avx5121_xor_syndrome(i
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -208,6 +210,7 @@ static void raid6_avx5122_gen_syndrome(i
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -292,6 +295,7 @@ static void raid6_avx5122_xor_syndrome(i
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -396,6 +400,7 @@ static void raid6_avx5124_gen_syndrome(i
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -529,6 +534,7 @@ static void raid6_avx5124_xor_syndrome(i
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
--- a/lib/raid/raid6/x86/recov_avx512.c~raid6-add-missing-vzeroupper-to-avx-512-code
+++ a/lib/raid/raid6/x86/recov_avx512.c
@@ -211,6 +211,7 @@ static void raid6_2data_recov_avx512(int
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -353,6 +354,7 @@ static void raid6_datap_recov_avx512(int
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-add-missing-vzeroupper-to-avx-code.patch
raid6-add-missing-vzeroupper-to-avx2-code.patch
raid6-add-missing-vzeroupper-to-avx-512-code.patch

