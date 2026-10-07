Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EFC352022;
	Wed,  7 Oct 2026 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338669; cv=none; b=ENwb59+KfrYOq8AoMjWDEosaOJyeInxLSlzQPVCoPKIbQAFzZI+nwrGkrWBM2CCoeCozgycwChCj9jlvJlNoR1MCX+85f3dcggLZx96EBSdwOMW69aFKIFqRN1EqKNmQpdoY7NxeXWjQEbmmeLqVe4iwMHuSjzM0N+aj0xsq6XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338669; c=relaxed/simple;
	bh=q55pYg8PPA0WvLlc0Fu29gxKJC2RJeHVyVpjjHTFoX0=;
	h=Date:To:From:Subject:Message-Id; b=NfGFVDofRfimKX7TPyxwuvRPK1CIcyfMQuTzqKI3bq7lZ1sXRPi5SLVLZqSIl8MWTOI4QeN/Q63NDYFaPMqIRCLwlMYYy/z7rz5/jCvdXw1iaDEiQpmnMp1ojsZh9yllTwVCEBE7nzaoJA24/Q0yWK5fFsGiTQ2YC08n11Pjmmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDUM1D8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDUM1D8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6F1F0089B;
	Wed,  7 Oct 2026 02:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338668;
	bh=NkaVSFHzYTJjEyoM/n2SPusiyPocuQuhFMRthhT3Isg=;
	h=Date:To:From:Subject;
	b=rDUM1D8F4fSHzWW0ZQ3DDKQ7BTVGb4ZG71Os9UI5B72JMNWGOUqHbcmbdOW+oAqvK
	 CMojVtcvJi0xBoEfa4UIW2iNuGk8t8aSd+l6wKhQS6epkEyLFKDwRkFzvC6de4FLfV
	 Xkc8yKJGL7vEi5eLk3TJQH4tG0cmjaod3nh0tJ/o=
Date: Tue, 06 Oct 2026 19:04:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-add-missing-vzeroupper-to-avx-512-code.patch removed from -mm tree
Message-Id: <20261007020428.49F6F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: add missing vzeroupper to AVX-512 code
has been removed from the -mm tree.  Its filename was
     raid6-add-missing-vzeroupper-to-avx-512-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
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


