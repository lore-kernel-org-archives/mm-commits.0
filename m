Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F26D1A8
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291684; cv=none; b=DnKh59B2eO2IV6HvOrw0D8xvyZfbK8oQCyT/3z3xYQSKVum4MaAmZWZEEoldpNAvYPIZefSTowo5aO/53XCzKZuRbwPFvk7Dz5y0GkOScp+m8SQmXP35NA+QcTrQLktd4aytmqhts9vPTk2i0rk+AJHGBs89nO60yaehqBt3b+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291684; c=relaxed/simple;
	bh=gmcKD8N3uJ1J9CfKygHiFpoHdHIEZHPXwpsmEtc7TVk=;
	h=Date:To:From:Subject:Message-Id; b=LupqTS+rEDl1OQ+8bGOGRFrKfNDmp+06hLChNcr7kQz+gtkHVXm7LnLY+zMUf7E/vZSfLEIqnPkhPggaFH+LM/mp5mLcJvaSyF31HwGoDz8FFh5JtGfYA7KKg4iY/4LbIqlOR3hdUI1KEhqel7vm9b0v7A6vCyJD3qFtU6eMABA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kQwuO8RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kQwuO8RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE1EC2BD10;
	Sat,  6 Jul 2024 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291684;
	bh=gmcKD8N3uJ1J9CfKygHiFpoHdHIEZHPXwpsmEtc7TVk=;
	h=Date:To:From:Subject:From;
	b=kQwuO8RODCZuA6/sssFR5N/iWY1u3xC0Xb3PYFv6NuOwcEbhXd5ov2ikAd8iSk/RK
	 fcG6dSCOp7XXyM+lgjikd0NmkBYnGM5J7IW4sVY+QeDf1b04OQLKUoFaQHcnPuK8/b
	 rF7hNDULopQRuQj4IRCF3Kf34RAwsKGSJIh1v2kQ=
Date: Sat, 06 Jul 2024 11:48:04 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-use-only-one-pool-in-zswap-v2.patch removed from -mm tree
Message-Id: <20240706184804.8FE1EC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-use-only-one-pool-in-zswap-v2
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-only-one-pool-in-zswap-v2.patch

This patch was dropped because it was folded into mm-zswap-use-only-one-pool-in-zswap.patch

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm-zswap-use-only-one-pool-in-zswap-v2
Date: Fri, 21 Jun 2024 15:15:10 +0800

fix error handling in zswap_pool_create(), per Dan Carpenter

Link: https://lkml.kernel.org/r/20240621-zsmalloc-lock-mm-everything-v2-2-d30e9cd2b793@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-only-one-pool-in-zswap-v2
+++ a/mm/zswap.c
@@ -268,7 +268,7 @@ static struct zswap_pool *zswap_pool_cre
 	pool->zpool = zpool_create_pool(type, name, gfp);
 	if (!pool->zpool) {
 		pr_err("%s zpool not available\n", type);
-		goto error;
+		return NULL;
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

