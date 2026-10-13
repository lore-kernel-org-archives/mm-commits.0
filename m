Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679E31618C
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 03:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791862406; cv=none; b=FNoGWRGQOqsCLE8K6kiNkHgYvdKH2a7/kvPT2kLp7QPy3ERQ/p4sEvSl07k64JTcLax2rZQA8DHgJSVvq9y4A0btXZa275QyOb5NSeuKv7AY+ZhMlamRSrLaO19vEElEa4s9mVhVwbuYwQSmlDZ1OGaV74IAvsbzBZLdSKr9ZIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791862406; c=relaxed/simple;
	bh=UL8xqm+D3o2eM5f8u60FX5HXuAbhWdnZ10ek67gA1As=;
	h=Date:To:From:Subject:Message-Id; b=NaCYoeT0/lpV1Oqs3bpkyX7fh68P+rHHkDfnvB12qZ6rcNPgmj4wU8qLiMhrQ+bFpkmKAdOMeuh8WN3ND7zWLIZ0PgsWxv5WV+zGL0lFYXIECw2Ow2SpTDJGDtVPT0ZOmVKWYZ6KZSe18EwCHy4KRgvEZcOhEFmG6w2oR+xk+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPk9lPiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPk9lPiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A061F000FF;
	Tue, 13 Oct 2026 03:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791862405;
	bh=Y+r99ipewYRuqv9cbsN1fA82FKPs47oYtUkla5mN/M0=;
	h=Date:To:From:Subject;
	b=lPk9lPiuUhhlnZ2cllhOKDUw9cWuuNXyyp/Mnlb+uuBzRDN2YIC/xC5UiLpA1lsrQ
	 bfZCRqm1LpSia/4jvd9enQ6Tx78N31shNWUm8xjg3uxUUd3/tJCobgJEmS782g5KX/
	 n7XUqw7SySxB7Q/tLzuqZ/ZuYBIYdRTRJgVIGI1w=
Date: Mon, 12 Oct 2026 20:33:24 -0700
To: mm-commits@vger.kernel.org,yann.collet.73@gmail.com,xiang@kernel.org,terrelln@fb.com,guoxuenan@huawei.com,Biplab.Raut@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch added to mm-nonmm-unstable branch
Message-Id: <20261013033325.05A061F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/lz4: add software-pipelined prefetch to decode fast loop
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch

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
From: "S. Biplab Raut" <Biplab.Raut@amd.com>
Subject: lib/lz4: add software-pipelined prefetch to decode fast loop
Date: Tue, 13 Oct 2026 03:20:10 +0000

LZ4 decompression of cold 4 KiB pages (the zswap/zram hot path) stalls on
cache misses because the input stream (compressed) and output buffer
(uncompressed page) are not resident in L1/L2.  Insert read-ahead and
write-intent prefetch hints at the top of the decode loop in
LZ4_decompress_generic() to overlap memory latency with decode work.

The prefetch distances (96 B read, 128 B write) are tuned for the
page-at-a-time workload where both buffers fit in L1d.  Prefetch is
architecturally a no-op hint on all Linux-supported architectures; it
never faults, never changes correctness, and compiles to nothing on
targets without hardware prefetch.

Measured on AMD EPYC 9755 (Turin, 2S×128C), Ubuntu 24.04, kernel
6.8.0-90-generic, real zswap path (cgroup-constrained MADV_PAGEOUT + full
scan-back), Silesia corpus, 15 paired rounds:

  Kernel LZ4 median scan:  1.0994 s
  Patched  median scan:    1.0472 s
  Median paired speedup:   5.09%  (range 4.19%–6.99%)
  Patched was faster in all 15 rounds.

Link: https://lore.kernel.org/20261013032010.2453893-1-Biplab.Raut@amd.com
Signed-off-by: S. Biplab Raut <Biplab.Raut@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Guo Xuenan <guoxuenan@huawei.com>
---

 lib/lz4/lz4_decompress.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/lib/lz4/lz4_decompress.c~lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop
+++ a/lib/lz4/lz4_decompress.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/prefetch.h>
 #include <linux/unaligned.h>
 
 /*-*****************************
@@ -122,6 +123,26 @@ static FORCE_INLINE int LZ4_decompress_g
 		const BYTE *match;
 		size_t offset;
 
+		/*
+		 * Software-pipelined prefetch hints.  On the zswap/zram
+		 * hot path, both the compressed input and the output page
+		 * are cold (just faulted in or freshly allocated).  Prime
+		 * the L1d for the next loop iteration so that the actual
+		 * loads/stores hit warm cache lines.
+		 *
+		 * Distances are tuned for 4 KiB page-at-a-time workloads:
+		 *   96 B read-ahead on ip  ~  6 tokens ahead
+		 *  128 B write-intent on op ~ 2 long-literal copies ahead
+		 *  192 B deeper read-ahead  ~  covers the match-copy tail
+		 *
+		 * prefetch() / prefetchw() are architecture-portable hints
+		 * that compile to NOP on targets without HW prefetch.  They
+		 * never fault, even past buffer boundaries.
+		 */
+		prefetch(ip + 96);
+		prefetchw(op + 128);
+		prefetch(ip + 192);
+
 		/* get literal length */
 		unsigned int const token = *ip++;
 		length = token>>ML_BITS;
_

Patches currently in -mm which might be from Biplab.Raut@amd.com are

lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch

