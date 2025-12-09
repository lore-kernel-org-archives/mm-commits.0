Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5506305976
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308805; cv=none; b=NWLhzBrlmdlI9ZAABzw74OspsuYEpBwAU3QVsYu32/ceoXbLJSGGLQUf4SiJN2KaIxTxptinjAl1/jDgk7TcB6p/negYTaFHVwiBfWUsl16p0v3Fmnw43WTNFkPdyWkoO1RcQlKGcbiDgNM81tQy60dDGNxs6PlNS3/52lg3H4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308805; c=relaxed/simple;
	bh=/DjxXrbKW9ngQi8lmTrtEOPEMuNZ1YhK+or+FFn7cAs=;
	h=Date:To:From:Subject:Message-Id; b=oiyt6GXoi3RT6Ei69tFooQqfGpKVfqCtJcFlnkoWmOdTVLI/SVjJRHCZYp0rK8Kb9cmYFqszM5wznwGPiIH30roTfnTdNk6qCDVrRwy6DMma0gPDOy+u+PNllEZHosKsoSJptILt5tLnY79QlnS5KS2B0Jy7RdEoej3cuW0hvZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+4v+zJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+4v+zJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB06EC4CEF5;
	Tue,  9 Dec 2025 19:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308804;
	bh=/DjxXrbKW9ngQi8lmTrtEOPEMuNZ1YhK+or+FFn7cAs=;
	h=Date:To:From:Subject:From;
	b=V+4v+zJkjoP6JWKWKcQIIIzYNHwi2rjSUGU82KNVeNjt1sLsoO2C6TvBPPgtAnNFl
	 jOJcvjROfPuvqINA1IF20Vh9oUYID/QgCS+TmKrOXKaT08eFtE3E/NgkMKwEC9sdI0
	 M9mbhoa/dpAkZm6wDlgwHOEsW4iNg4rfVkx4Dj7E=
Date: Tue, 09 Dec 2025 11:33:24 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] args-fix-documentation-to-reflect-the-correct-numbers.patch removed from -mm tree
Message-Id: <20251209193324.BB06EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: args: fix documentation to reflect the correct numbers
has been removed from the -mm tree.  Its filename was
     args-fix-documentation-to-reflect-the-correct-numbers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


