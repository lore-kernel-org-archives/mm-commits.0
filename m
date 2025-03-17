Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252CDEEA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186669; cv=none; b=BTgS4I5qqbqFurCzIz9J/IBFW+v0zw/sm5YAqluW2NPaexDSeRyTN2N3DlOc5Iw6RF+zbPYOpPcgEenWSpmo2az9pFuTYFmRsGL45txMUoPejhLaNqGbOfnG4nUNvIfuvnVtzsva4rBXezvSXgUjNc0o9ZX8ahbNzuy8l3l6oLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186669; c=relaxed/simple;
	bh=wZdWObFsEGrP3npdNfNyLnbYt2UZj8Akz2Li74Ej2VU=;
	h=Date:To:From:Subject:Message-Id; b=s/awi26QXQb51rNM44dRONyHxGrqTDr+LHjIbMNzPOZgn2dnSDNS9xfkgV2+rFr879ymv4cZsgKvF0t+Skjkfvc35BPp2vxEzaxmDeOcHLGedAIm3WCUBj18bKxpSmIz66oRnrZ5NwAJ5d9jYZQInsbjnRj5ErDiF5UxVy4LpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVIi1x9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVIi1x9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC63BC4CEEC;
	Mon, 17 Mar 2025 04:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186669;
	bh=wZdWObFsEGrP3npdNfNyLnbYt2UZj8Akz2Li74Ej2VU=;
	h=Date:To:From:Subject:From;
	b=HVIi1x9uebAUJ/XvmdZK2wvZlLic+y6lm3rTBLl63EZjcvDeBzNsksM2sZoEV6DDp
	 EKMHNTysm5Wtt0iirLveyCYwwHRUHxFZmEnpzGJtsya2Dvn2WjC7oaC4zR+LcnfPrV
	 QnBZD8U7+ZgkgU678f9CAdRQehrOlqUZ5p1SWvGg=
Date: Sun, 16 Mar 2025 21:44:28 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch removed from -mm tree
Message-Id: <20250317044428.DC63BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
Date: Wed, 5 Mar 2025 18:57:51 +0000

update the docs

Link: https://lkml.kernel.org/r/Z8ier-ZZp8T6MOTH@google.com
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/zsmalloc.rst |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/Documentation/mm/zsmalloc.rst~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix
+++ a/Documentation/mm/zsmalloc.rst
@@ -27,9 +27,8 @@ Instead, it returns an opaque handle (un
 location of the allocated object. The reason for this indirection is that
 zsmalloc does not keep zspages permanently mapped since that would cause
 issues on 32-bit systems where the VA region for kernel space mappings
-is very small. So, before using the allocating memory, the object has to
-be mapped using zs_map_object() to get a usable pointer and subsequently
-unmapped using zs_unmap_object().
+is very small. So, using the allocated memory should be done through the
+proper handle-based APIs.
 
 stat
 ====
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-z3fold-remove-z3fold.patch
mm-zbud-remove-zbud.patch
mm-zpool-add-interfaces-for-object-read-write-apis.patch
mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch
mm-zpool-remove-object-mapping-apis.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch
mm-zpool-remove-zpool_malloc_support_movable.patch

