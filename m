Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8595F125A0
	for <mm-commits@vger.kernel.org>; Tue,  2 Dec 2025 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693763; cv=none; b=OVDP9FjOz0sAtQ8bQLTxfSSUNkel0baRf5Q6zTsuMS9hnPFiYBExnVCC1nseG+JaqQNIdjzfNC68S9/qc/GST032bTd8aw+a3ud+sJ0X1XiSJtcJ4j5MnXZafYG3YzD/vr2L461Uqkd8D1wJoGHFq7YfZt26pqQcqzVHhAU/HXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693763; c=relaxed/simple;
	bh=mQigx/tPIq3+dqkUMxB0O/RGFrGYHgkLbZOoBLp70Bo=;
	h=Date:To:From:Subject:Message-Id; b=ukG/j8UZRbjb2I4542/qWHtw3vdXc9qrLXwP5Pk4NvgCXDBI7Zui7PKjzP3He+29A+enHQ5hj9mVH59hLbijFj+cNKdPJ6SmbyPD6D2kGRVZeguwz6dt3o6k7/DED1c2QC9bXbbahjJWlWr9sradmiwavpK7Om8Dyv3BUZTFpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jCiPFnen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jCiPFnen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019FCC4CEF1;
	Tue,  2 Dec 2025 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764693763;
	bh=mQigx/tPIq3+dqkUMxB0O/RGFrGYHgkLbZOoBLp70Bo=;
	h=Date:To:From:Subject:From;
	b=jCiPFnenyI+GLpNFGQ3Dg1N5VS8sJUAtKMYOz/QXZ1zKk3MmNrrzXABNBaRmTp4fP
	 gyixq4g6QrP3UFQnGBlHaN9smPX+ARQUAuv+kJ6cHDEuAXjwUPQPTGBRRfjGSmF3fo
	 4YAcX1p3uF10IVOnMh2/0NPGfH85bHlVLL4TZdJo=
Date: Tue, 02 Dec 2025 08:42:42 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + args-fix-documentation-to-reflect-the-correct-numbers.patch added to mm-nonmm-unstable branch
Message-Id: <20251202164243.019FCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: args: fix documentation to reflect the correct numbers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     args-fix-documentation-to-reflect-the-correct-numbers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/args-fix-documentation-to-reflect-the-correct-numbers.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: args: fix documentation to reflect the correct numbers
Date: Mon, 1 Dec 2025 21:10:18 +0100

The macro uses up to 15 arguments.  Reflect this in the top level comment.

Link: https://lkml.kernel.org/r/20251201201018.765475-1-andriy.shevchenko@linux.intel.com
Fixes: d51e783c17ba ("lsm: count the LSMs enabled at compile time")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/args.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/args.h~args-fix-documentation-to-reflect-the-correct-numbers
+++ a/include/linux/args.h
@@ -6,9 +6,9 @@
 /*
  * How do these macros work?
  *
- * In __COUNT_ARGS() _0 to _12 are just placeholders from the start
+ * In __COUNT_ARGS() _0 to _15 are just placeholders from the start
  * in order to make sure _n is positioned over the correct number
- * from 12 to 0 (depending on X, which is a variadic argument list).
+ * from 15 to 0 (depending on X, which is a variadic argument list).
  * They serve no purpose other than occupying a position. Since each
  * macro parameter must have a distinct identifier, those identifiers
  * are as good as any.
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

args-fix-documentation-to-reflect-the-correct-numbers.patch

