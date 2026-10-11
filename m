Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAC01B87C9;
	Sun, 11 Oct 2026 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757189; cv=none; b=YoAVO7kHIBhhmHbiHUNvGP2uNRFYaqxd/SenSwn1qF1LFGguRL7uRzO74WXpOXjhrQa+jnOSwiF/fJswAGatWyxEVBx5BWIItNKP7iNPFdHzw0gfzQ7BB3UGoFGi9SaTbEKO0kUXncEOvKCodtHCkylBoKBlixbFQl7So/s8kaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757189; c=relaxed/simple;
	bh=6es5G3IGavXbjiMHPzsB4S997ybqweU+2EebgYPfIxE=;
	h=Date:To:From:Subject:Message-Id; b=hYG4qLZH3WfphbBIGhUIOmzpVr2BgW7tldUDjdrpWvEa1ZJlmqdhaGLToyUYyNocZTtFt1Kw+RNOvpiScQCwdKa7maml+QSDMf3WuBq7eIKS4vJjbCdUdrZGkfqSFc6RL1sZ9c3+O5f7D+DqgLsOyfqU0MmNAjNV+/5KYlggIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=keQ+qIZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="keQ+qIZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9644D1F0089B;
	Sun, 11 Oct 2026 22:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757187;
	bh=IFmwh1OG80gZLkyYzW4M+5j0BuT79PCnvrq1d8bxbyo=;
	h=Date:To:From:Subject;
	b=keQ+qIZ+Q9QlX63WgMZznwSoF8VeQlP3KKh0XhK/rLlepcNbJPrQO9qXIm11zcCed
	 7AabjdDTooEDoW0ebBcIyPJgsPD5A4QICNunTqk1OXnbYj5/MDuAc44x3bNgFfka0N
	 XcaxaaPykd6T/hycgs8sP2v8GRdQk+vMjhG2DqM8=
Date: Sun, 11 Oct 2026 15:19:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,elb12345@hotmail.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch removed from -mm tree
Message-Id: <20261011221947.9644D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: decompress_bunzip2: fix integer overflow in run-length decoding
has been removed from the -mm tree.  Its filename was
     lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Wed, 16 Sep 2026 09:53:51 +0100

The RUNA/RUNB decoder in get_next_block() accumulates a run length into
the signed int t with no bound.  runPos doubles per symbol, so t grows as
at least 2^n-1 and reaches INT_MAX after 31 RUNA symbols.  The guard that
follows, dbufCount+t >= dbufSize, is itself a signed addition, and as the
kernel builds with -fno-strict-overflow it wraps negative once dbufCount
is nonzero, so the guard is skipped.  while (t--) dbuf[dbufCount++] = uc
then writes INT_MAX entries into a buffer holding at most 900000.  One
literal symbol ahead of the run is enough to make dbufCount nonzero.

Bound t to the block size as it is accumulated.  t only grows within a
run, so the value tested never exceeds the final run length; any stream
that decodes today satisfies dbufCount+t < dbufSize at the flush, hence t
< dbufSize throughout, and no such stream is rejected.  Because t grows as
at least 2^n-1 the bound trips by the 20th symbol, leaving runPos at most
2^19, so the following runPos <<= 1 cannot overflow either.

Link: https://lore.kernel.org/AS8P251MB00010FE5E38D253CF98A652AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---

 lib/decompress_bunzip2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding
+++ a/lib/decompress_bunzip2.c
@@ -428,6 +428,10 @@ got_huff_bits:
 			t += (runPos << nextSym);
 			/* +runPos if RUNA; +2*runPos if RUNB */
 
+			/* Bound the run so t and runPos cannot overflow. */
+			if (t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
 			runPos <<= 1;
 			continue;
 		}
_

Patches currently in -mm which might be from elb12345@hotmail.co.uk are


