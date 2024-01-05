Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABAC3588B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1XluafoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDF9C433C7;
	Fri,  5 Jan 2024 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478728;
	bh=G5pVx0yM6M835JpXOqLMDNu8jHVIS6V7WDGp3/BQ/7Y=;
	h=Date:To:From:Subject:From;
	b=1XluafoBWaeILw73kGsTysJrrwsH+SxgPbpwNGyP/OnOrD6bGECZ1M4GGoTaVldbU
	 v5m6Nbx9z9Al4Lp+HMGLvE+iOkqC/mi4Ho5E8iVbZK4mHz8AuY3LpZKcKN5JWgQmcw
	 CNpSBFJC+0ExXrruyY8KOdROU+zCFuxi/qJGIbLY=
Date: Fri, 05 Jan 2024 10:18:48 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,v-songbaohua@oppo.com,vitaly.wool@konsulko.com,sjenning@redhat.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-return-enospc-rather-than-einval-in-zs_malloc-while-size-is-too-large.patch removed from -mm tree
Message-Id: <20240105181848.9FDF9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zsmalloc: return -ENOSPC rather than -EINVAL in zs_malloc while size is too large
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-return-enospc-rather-than-einval-in-zs_malloc-while-size-is-too-large.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm: zsmalloc: return -ENOSPC rather than -EINVAL in zs_malloc while size is too large
Date: Thu, 28 Dec 2023 19:18:02 +1300

This is the case the "compressed" data is larger than the original data,
it is better to return -ENOSPC which can help zswap record a poor compr
rather than an invalid request.  Then we get more friendly counting for
reject_compress_poor in debugfs.

 bool zswap_store(struct folio *folio)
 {
 	...
 	ret = zpool_malloc(zpool, dlen, gfp, &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto put_dstmem;
 	}
 	if (ret) {
 		zswap_reject_alloc_fail++;
 		goto put_dstmem;
 	}
 	...
 }

Also, zbud_alloc() and z3fold_alloc() are returning ENOSPC in the same
case, eg

 static int z3fold_alloc(struct z3fold_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	...
 	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;

 	if (size > PAGE_SIZE)
 		return -ENOSPC;
 	...
 }

Link: https://lkml.kernel.org/r/20231228061802.25280-1-v-songbaohua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-return-enospc-rather-than-einval-in-zs_malloc-while-size-is-too-large
+++ a/mm/zsmalloc.c
@@ -1364,9 +1364,12 @@ unsigned long zs_malloc(struct zs_pool *
 	int newfg;
 	struct zspage *zspage;
 
-	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
+	if (unlikely(!size))
 		return (unsigned long)ERR_PTR(-EINVAL);
 
+	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
+		return (unsigned long)ERR_PTR(-ENOSPC);
+
 	handle = cache_alloc_handle(pool, gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are


