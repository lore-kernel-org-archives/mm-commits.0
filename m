Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADE033122D;
	Wed,  7 Oct 2026 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338667; cv=none; b=tw52oRjtgrHXKWcIDSo7G9g0QEVVAVwL7656PCbODpbXaO9aTf9KQ/JAEyqIb5dA+U7mrPAdSIYUqNHFR0js/FWm8l8Rzvua5qwlxbpn5V4kHl0rXl1CKeCgNsB8jWICIJP6p6QXHOMcWch5NfNx4QAROO+SgID1l29wzmvFTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338667; c=relaxed/simple;
	bh=xXJdyUjLoqSDoZR8DJxWdKopSahGRibZRTBYQKKbUkw=;
	h=Date:To:From:Subject:Message-Id; b=SFOVV8g+ynNk/AdLqhkUBfxYjtE29YNzwSozI07pXvsJh5Oxvzr7Mv2pVdgZfUg9svz1Dp1cXBkXJ7yf2KDrRnZszhzn2b54+eKnkaN+5xoc7baZoCzjq9R4x0cWY1+Nz532Z0gJbxqBv5JWlyIyKQbSAnTb2zJVvTcipJsLQf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pG8vWJCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pG8vWJCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014F91F0089B;
	Wed,  7 Oct 2026 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338666;
	bh=67YRl/C/MPIV+cv8NuLbpyOH1w2t0jDPqJBvgfdubrg=;
	h=Date:To:From:Subject;
	b=pG8vWJCrmHotkdmAL5FkrkfYedW0KZIUxm5F/r5xLzOWiP9TD323aiiDUUZ5S70YI
	 vC9p4fa4usjgOcp6pxhRtbEsBU4V8wb4wjR3GlwsF2mp5V1BmbtkxN9YI/i6BNNq20
	 aFja8tnQudG6nMK0HDY1k4XHVgVYaksVdi09Fo80=
Date: Tue, 06 Oct 2026 19:04:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-add-missing-vzeroupper-to-avx-code.patch removed from -mm tree
Message-Id: <20261007020426.014F91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: add missing vzeroupper to AVX code
has been removed from the -mm tree.  Its filename was
     xor-add-missing-vzeroupper-to-avx-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
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


