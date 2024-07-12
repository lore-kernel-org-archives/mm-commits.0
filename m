Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0753C062
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 20:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720815638; cv=none; b=hE/EFwpxnaacvW2za1IvlbXNkVnQO0cQ5cMtqcGGivKVqotJp0ihJ6d62agAfY/aajBAGY3MkUF/mh2sN9acDVBY4UtboogvwapBXL19tETExXp4fA2fd9/cQ0sspieqvm4qedwinKtnJ76Xv64S1uog6Bl6FwnrdDQbc3W3KCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720815638; c=relaxed/simple;
	bh=JlcD5/SibUBFeg70ZVytQ8VC95OfNbsEX4XsIc8WZWk=;
	h=Date:To:From:Subject:Message-Id; b=NvVIa3YLodPIusIEZjNElEka5o+EC0Lv+/F6wFiWWu13KsPJ2e8dmnoNGuz8Lb6mRAtyrjv0IeWsKgtO4PniNPWYcO7DdVlm3XyYfwsk/tQhUmgoGfQfFvTvyekaUi6FZz1XnplNQoVbcRGvpRIXOX+2l0pxa+2BHsITzXpjGk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wWLgEVu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wWLgEVu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9896AC32782;
	Fri, 12 Jul 2024 20:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720815637;
	bh=JlcD5/SibUBFeg70ZVytQ8VC95OfNbsEX4XsIc8WZWk=;
	h=Date:To:From:Subject:From;
	b=wWLgEVu8BWuXhIEwxrldPFUbcM8RsPnPu5/+rT7wYFvqaxxtoUPwNr9Ov5+lP/KxJ
	 F5eFWVuXxA+xdr7gv1zdhvHaNE/HlJUEUe6PmDTyxxWa0e5cHcdxaMzr2DOdfbfLx4
	 GYFHJKmXRT7vnCpSPvmqGBjQsG0VVzAf6OP7N+bw=
Date: Fri, 12 Jul 2024 13:20:37 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,oliver.sang@intel.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mul_u64_u64_div_u64-basic-sanity-test-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240712202037.9896AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mul_u64_u64_div_u64: avoid undefined shift value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mul_u64_u64_div_u64-basic-sanity-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mul_u64_u64_div_u64-basic-sanity-test-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nicolas Pitre <npitre@baylibre.com>
Subject: mul_u64_u64_div_u64: avoid undefined shift value
Date: Fri, 12 Jul 2024 13:41:46 -0400 (EDT)

Shifting a value to its type's size or beyond is undefined.  This may
happen if the product of a * b is not more than 64 bits despite ilog2(a) +
ilog2(b) being 63 and c having no trailing 0 bits.  We end up with shift=0
and n_lo >> shift | (n_hi << (64 - shift).  Take care of that case and add
such case to the test module.

Using __builtin_ctzll() with 0 is also undefined so take care of that
case too.

Link: https://lkml.kernel.org/r/7rrs9pn1-n266-3013-9q6n-1osp8r8s0rrn@syhkavp.arg
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407121652.69e657c5-oliver.sang@intel.com
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c                    |    9 ++++++++-
 lib/math/test_mul_u64_u64_div_u64.c |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/lib/math/div64.c~mul_u64_u64_div_u64-basic-sanity-test-fix
+++ a/lib/math/div64.c
@@ -212,11 +212,18 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
+	/* make sure c is not zero, trigger exception otherwise */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdiv-by-zero"
+	if (unlikely(c == 0))
+		return 1/0;
+#pragma GCC diagnostic pop
+
 	int shift = __builtin_ctzll(c);
 
 	/* try reducing the fraction in case the dividend becomes <= 64 bits */
 	if ((n_hi >> shift) == 0) {
-		u64 n = (n_lo >> shift) | (n_hi << (64 - shift));
+		u64 n = shift ? (n_lo >> shift) | (n_hi << (64 - shift)) : n_lo;
 
 		return div64_u64(n, c >> shift);
 		/*
--- a/lib/math/test_mul_u64_u64_div_u64.c~mul_u64_u64_div_u64-basic-sanity-test-fix
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -23,6 +23,7 @@ static test_params test_values[] = {
 {        0x1ffffffff,        0x1ffffffff,                0x4, 0xffffffff00000000 },
 { 0xffff000000000000, 0xffff000000000000, 0xffff000000000001, 0xfffeffffffffffff },
 { 0x3333333333333333, 0x3333333333333333, 0x5555555555555555, 0x1eb851eb851eb851 },
+{ 0x7fffffffffffffff,                0x2,                0x3, 0x5555555555555554 },
 { 0xffffffffffffffff,                0x2, 0x8000000000000000,                0x3 },
 { 0xffffffffffffffff,                0x2, 0xc000000000000000,                0x2 },
 { 0xffffffffffffffff, 0x4000000000000004, 0x8000000000000000, 0x8000000000000007 },
_

Patches currently in -mm which might be from npitre@baylibre.com are

mul_u64_u64_div_u64-make-it-precise-always.patch
mul_u64_u64_div_u64-basic-sanity-test.patch
mul_u64_u64_div_u64-basic-sanity-test-fix.patch

