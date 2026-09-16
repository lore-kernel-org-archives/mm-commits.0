Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E02E37BE75;
	Wed, 16 Sep 2026 23:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599762; cv=none; b=f4ELhwtbYDEp3krWh14XDct/RSRT2qgUBxdiZdVMkf0RIo1n2ySnlRmQ4qGqJ6K7KtpoDqNKrY5//XL/awDawEpwUj9TJVXkio5WkOxKb82eUTFmdO7IAYWnME3Yvot6uqRYGV2A4rKoQZ17lyxpcM/f2xSL1FbbEC49dP/Gf78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599762; c=relaxed/simple;
	bh=eYsnbZwo1OXRm29370IkjNSHbmVLsYc4WoB5P21fS50=;
	h=Date:To:From:Subject:Message-Id; b=WxU5Ds50mqLWw+9zpHOHuaGe/PHAsDnbsiAVqMD6QFiQ+4NYFDSeHqe95EFYlNth/P7MQN8EavqiBD9RRjqwbVl+VWwrbNcwy2YGxyy0aAV5P2u8UAAVmqoxPMhwtoNyDMMB7JrFuv4n7oiAbu+y35SWZzUuuOscw4Q7+eP/Giw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i+ea0m+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i+ea0m+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEEF1F000FF;
	Wed, 16 Sep 2026 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789599754;
	bh=Ttf1Lp06eGMZTq8kmEWQK8VQAwqDKcMLoLNRDecdFa4=;
	h=Date:To:From:Subject;
	b=i+ea0m+g/alYzYD9sQUCbANUPYdZnUPIHoi4pPLH2bXJRoRMNJskCHcFhNj+TP5Wo
	 Cvq4/xhpu84y4ifzFGJcK6YTWxx9xqJWe/D1ZXBtUVm/z7YZVaSF50jbrS9yyIPiZ4
	 Yo11ZrpkbZNDsdokb/kMbEcPY97xDjLgxf5ELA4c=
Date: Wed, 16 Sep 2026 16:02:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,elb12345@hotmail.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch added to mm-nonmm-unstable branch
Message-Id: <20260916230234.7BEEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: decompress_bunzip2: fix integer overflow in run-length decoding
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch

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

lib-decompress_bunzip2-fix-integer-overflow-in-run-length-decoding.patch

