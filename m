Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81D413BAFA
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291686; cv=none; b=NE11YTpvKCAykUM0BhvuAXuROq4s2K8w2qEK+U3GH9NScD2tn87UxH6uc1IkRdksn0YMekNCwTmLp6+tPENbhbakQoE+PlAU5V/M2Rdy3KNUMxsxTJ5SWKBZ0amCccheAA3BzQzGXluNsaYlCnH0YQDBo67m13MND48kspoozFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291686; c=relaxed/simple;
	bh=YOE+ZfNwdbd0tr5vyHVW6so5nO4KdxtXLftdVgTOyrM=;
	h=Date:To:From:Subject:Message-Id; b=RcbT6FI2WPKAKK2pZ/3uOtpqly7amZQm79NwPbw8SElU1CKI7rVLMPXvYTUqrNmAOhXdwP3afWX/AkHsj/e0WfEed9npZIcf2ToOE1EeYgKPUg3/k9kyaE6f0AAFzlWHtS5LONBou3I8uESULkePNS43NEJmWsyKBm3kODNc4AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sw3TpFCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sw3TpFCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC357C2BD10;
	Sat,  6 Jul 2024 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291685;
	bh=YOE+ZfNwdbd0tr5vyHVW6so5nO4KdxtXLftdVgTOyrM=;
	h=Date:To:From:Subject:From;
	b=sw3TpFCvId7erWg1568yOjbWLNqA9xX8js45lkEXHghRYNKRaEq3ftcLvoncJVBkc
	 ljOojLrl2LXPqD85rCF5r0szL+nEcjVqFeUQLbp2/b5w/ljpV1A3iro17c0gdRA/5/
	 4fCK6U9znD4mNyDAOtt2L2YM8m2E69v2bRkAsP7w=
Date: Sat, 06 Jul 2024 11:48:05 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-use-only-one-pool-in-zswap-v3.patch removed from -mm tree
Message-Id: <20240706184805.BC357C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-use-only-one-pool-in-zswap-v3
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-only-one-pool-in-zswap-v3.patch

This patch was dropped because it was folded into mm-zswap-use-only-one-pool-in-zswap.patch

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm-zswap-use-only-one-pool-in-zswap-v3
Date: Tue, 25 Jun 2024 12:39:05 +0800

fix error handling again in zswap_pool_create(), per Yosry

Link: https://lkml.kernel.org/r/20240625-zsmalloc-lock-mm-everything-v3-2-ad941699cb61@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-only-one-pool-in-zswap-v3
+++ a/mm/zswap.c
@@ -268,7 +268,7 @@ static struct zswap_pool *zswap_pool_cre
 	pool->zpool = zpool_create_pool(type, name, gfp);
 	if (!pool->zpool) {
 		pr_err("%s zpool not available\n", type);
-		return NULL;
+		goto error;
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
@@ -303,7 +303,8 @@ ref_fail:
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
-	zpool_destroy_pool(pool->zpool);
+	if (pool->zpool)
+		zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 	return NULL;
 }
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

