Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E821771F
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188430; cv=none; b=c7Na2qF4atNVg/0h+mBEeTOXhoxw1QxnFfWifQ9ORmxTAMhEeSwf49o1Uq2B+azja5bECVg6CPdAbFbVj60S9hc335fX0Jm0rmVNBoXnVZDRiVUXp23gfNoA0/3IrBBj8PlRydpbea5ZeQiivKsO1WcBLabeZ3K9Dc5CxlPjC80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188430; c=relaxed/simple;
	bh=LTrJ9t5mw4KUXXiWpEwih54DAIxz5jrPGFlK3QcfJSY=;
	h=Date:To:From:Subject:Message-Id; b=bGbC4zOibmAya/jgqY6ZFXa8PoGNJ+fGp59rwvizj397RYJunR69Soi8NuNSLadQs3QWPwiLwWYEP/Q61awuWbcTV7eIYGJ2etXaqnq9s9AcT/5Sxx+4XCqXKNBaHrnKVqQT7dgNhR11RrIoMx/X1DtGEXCxprdzQwPUNPWswxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3YR0Jgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3YR0Jgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF02C4CEEC;
	Mon, 17 Mar 2025 05:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188430;
	bh=LTrJ9t5mw4KUXXiWpEwih54DAIxz5jrPGFlK3QcfJSY=;
	h=Date:To:From:Subject:From;
	b=F3YR0JgkEwNiOYIyQKB9JHjK77CCeQ/5C9jT2P1/Atpxhl6ut0PNjk0hLF7hT8Z7x
	 LPfAZPinUprGVfM4I8cxSABVNZeC15wW10zeMyQtQKmCXfl0egaCAmo4Ki865upEgp
	 vctWBi5v/FiSD4hoYtYOBQ8JQrKcDPMGjfTpOLtQ=
Date: Sun, 16 Mar 2025 22:13:50 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-permit-reclaim-in-zstd-custom-allocator.patch removed from -mm tree
Message-Id: <20250317051350.9AF02C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: permit reclaim in zstd custom allocator
has been removed from the -mm tree.  Its filename was
     zram-permit-reclaim-in-zstd-custom-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: permit reclaim in zstd custom allocator
Date: Mon, 3 Mar 2025 11:03:25 +0900

When configured with pre-trained compression/decompression dictionary
support, zstd requires custom memory allocator, which it calls internally
from compression()/decompression() routines.  That means allocation from
atomic context (either under entry spin-lock, or per-CPU local-lock or
both).  Now, with non-atomic zram read()/write(), those limitations are
relaxed and we can allow direct and indirect reclaim.

Link: https://lkml.kernel.org/r/20250303022425.285971-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-permit-reclaim-in-zstd-custom-allocator
+++ a/drivers/block/zram/backend_zstd.c
@@ -24,19 +24,10 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
- *
- * This means that allocator.customAlloc() can be called from zcomp_compress()
- * under local-lock (per-CPU compression stream), in which case we must use
- * GFP_ATOMIC.
- *
- * Another complication here is that we can be configured as a swap device.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	if (!preemptible())
-		return kvzalloc(size, GFP_ATOMIC);
-
-	return kvzalloc(size, __GFP_KSWAPD_RECLAIM | __GFP_NOWARN);
+	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


