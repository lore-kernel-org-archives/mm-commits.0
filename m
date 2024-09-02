Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E68129406
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248284; cv=none; b=IFUaGNvnISwKVzZxqQML70FRAUWyA4Gwa1i9fznFAK/t8v6tuLiN4bfta6EgpkJVX9SMVJ4kG/ZE8D/mz7tUROqyYM+ri/B+p61/LSarGcX1Rt6uJRUxvmbGlgc5y//5UiphAKb4HgYNuhB4yPT1ULBjGkUhbxXm4kQglcWoos0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248284; c=relaxed/simple;
	bh=oaUYlwNIohJeZh8HWbOY0t9aIOl9RJIpzv7Qgoja8Cg=;
	h=Date:To:From:Subject:Message-Id; b=psGRuRnJdNGF6SvBCKDSDezcGLkuhSlhyszljdRU+y0ozFDTnpqeocdu5M9mjcGEK70IhHExIscxwG/qipOP+DG0jeOPwQ0sbhGfbiH/SKubIMS4A4KH/x4zG9vnmx1KC9lM8wfkP71MrWl8sb8CXiN0ZiqfIJDHOPCwUiiJ3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xErnXTTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xErnXTTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A0DC4CEC2;
	Mon,  2 Sep 2024 03:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248282;
	bh=oaUYlwNIohJeZh8HWbOY0t9aIOl9RJIpzv7Qgoja8Cg=;
	h=Date:To:From:Subject:From;
	b=xErnXTTPBNL7CL0QctvaZ0EF8OwVJ/rTgxn99OSPxVKVIaX/5xojTnGmyPK6+7/TS
	 mw0/8cd0UFuWh7U0t+x3cUkSzCnsc5J4HqGbHJEod1XDtkV6UxgSqrHhm/KhXt8/lG
	 tlu/UyGvBTnSVP1oL+ADuavStLkFPF2bCNst9nnQ=
Date: Sun, 01 Sep 2024 20:38:01 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,oliver.sang@intel.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mul_u64_u64_div_u64-basic-sanity-test-fix.patch removed from -mm tree
Message-Id: <20240902033802.71A0DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mul_u64_u64_div_u64: avoid undefined shift value
has been removed from the -mm tree.  Its filename was
     mul_u64_u64_div_u64-basic-sanity-test-fix.patch

This patch was dropped because it was folded into mul_u64_u64_div_u64-basic-sanity-test.patch

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
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
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

