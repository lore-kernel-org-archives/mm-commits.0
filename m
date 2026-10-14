Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB24D9F6F
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791993326; cv=none; b=J7XAs4bR0oRgUUVVaXUGPFybHUtIOWjeRqPIBwTzhVf2//OUF6pILn2ycd/DpaNpGoN3fWe+BnSwTs+/1jhOVNns8Gqti29U6ghRaQ1+45z3nBVRC39ZQlI7ECAfYcI4dl4ixrjFrKPpnoykhe3kawXaOKiSC0hwQsUTfxLVJ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791993326; c=relaxed/simple;
	bh=fJzJYeZyLG9zscVkEcjck15xmK/XCVuFJ+B40Yg9jSQ=;
	h=Date:To:From:Subject:Message-Id; b=dXgSbwd+EuPNnp9LtAbPiY8/PYyP4SkQHzU7qbAQ1ZWkAKRtU22a/NN6b08Noh1BRRpye2dA1IZeM+VvFlV7EHzrk/qof0Z3LLspWKOYOyS/7jxzA0cMGCTW88Bm/xDtNJMVmOqtCTspTtKFgi0Z7TeG7c+e/5Xou1sF3szLYbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hb1oamRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hb1oamRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001B41F000C4;
	Wed, 14 Oct 2026 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791993325;
	bh=GnYXaxyDXpN8jVQqgYdxkZh0uQh1ln27Nztq6/NeAJw=;
	h=Date:To:From:Subject;
	b=Hb1oamRUxzRVkBeH8lDhdlV7Q5bg+bC+JyCfUP1BLbc1rQoXNffc4rSavMPwSMHI4
	 5fD8mhKui9ArCPraxFQi8rtfwQrunOggxCu/j2O1vdz37bs5dxs/Hob4NvtwQjyEEE
	 XvV97uy8FyePj2W/qgRUXpWQG1xxeyUe48yPAY34=
Date: Wed, 14 Oct 2026 08:55:24 -0700
To: mm-commits@vger.kernel.org,yann.collet.73@gmail.com,xiang@kernel.org,terrelln@fb.com,guoxuenan@huawei.com,arnd@arndb.de,Biplab.Raut@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch removed from -mm tree
Message-Id: <20261014155525.001B41F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/lz4: add software-pipelined prefetch to decode fast loop
has been removed from the -mm tree.  Its filename was
     lib-lz4-add-software-pipelined-prefetch-to-decode-fast-loop.patch

This patch was dropped because it had testing failures

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
Cc: Arnd Bergmann <arnd@arndb.de>
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


