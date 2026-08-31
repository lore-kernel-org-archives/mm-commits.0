Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5FB39A802;
	Mon, 31 Aug 2026 22:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214468; cv=none; b=EQxzciAuyS+BNJ8kz0YndkUr0z3U06pIh3Gi0qnqIpxzzFWGof3hRRXJmYYi3om68OyN20sefvU4CBRfcEcUrRRzYOUPsEOpGMgM3pfr5Yew7ufO4dIxuwTZO3T/mk71dHaxGEgQpcakS72LZidbV/z6gJpAx+1rbvkESMgdYEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214468; c=relaxed/simple;
	bh=7TIuEjADm4D2dYWhjo7SiHbExcrloyVoXvPDY7mYfUE=;
	h=Date:To:From:Subject:Message-Id; b=qVG6vrUVAoaMqOHFgv2NBQ21V1TEsfuwBJAF7y/fDiYFgYSzKuEKLGfcKnM9l6Ptkc8FYCggnAf9OWGRWzgxCCH+aDkywUxH4Q4KkpuQ7H8++pRjTP+YJPyCyXNQfyrsHUFBJfVNZFSwMcTjFREaE6e4HAsKIfS0TcNpWguBcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vPZkx7FA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vPZkx7FA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6CA1F000E9;
	Mon, 31 Aug 2026 22:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788214467;
	bh=hrO9NFFmDQD0mduI27NkGGIDV300DkllyGG7ZLkhzyU=;
	h=Date:To:From:Subject;
	b=vPZkx7FAVcNErWis0cwxMDuN7gnIUCQ4Rk4TKWZE06wE1vMg55f3OnCwgHjAZ/+kG
	 eb+pHEY+w7PmDniV6QkTHKeI+cRcwRKR2PAbU+Rm1Ym2i6MX/iu5wD0EIkLwkRV/T4
	 REVfkN10VomQMllSlkZFnjpuiXPknslcg/vK7eQg=
Date: Mon, 31 Aug 2026 15:14:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-add-missing-vzeroupper-to-avx-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260831221427.1F6CA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: add missing vzeroupper to AVX code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-add-missing-vzeroupper-to-avx-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-add-missing-vzeroupper-to-avx-code.patch

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
Subject: xor: add missing vzeroupper to AVX code
Date: Mon, 31 Aug 2026 14:22:48 -0700

Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212248.213805-1-ebiggers@kernel.org
Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/x86/xor-avx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/raid/xor/x86/xor-avx.c~xor-add-missing-vzeroupper-to-avx-code
+++ a/lib/raid/xor/x86/xor-avx.c
@@ -147,6 +147,7 @@ static void xor_gen_avx(void *dest, void
 {
 	kernel_fpu_begin();
 	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-add-missing-vzeroupper-to-avx-code.patch
raid6-add-missing-vzeroupper-to-avx2-code.patch
raid6-add-missing-vzeroupper-to-avx-512-code.patch

