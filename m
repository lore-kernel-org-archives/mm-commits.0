Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C423B16D4C8
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719344293; cv=none; b=Nd6zVLv25Ae/sd3ZOcc8d5SgbZryBBomyEoOUzdL4j2TOXJufuCkXYwNoPg5t+MLdEYUGF7TQ/iZ2vVii/DwxnXtHeAN9SFNI2ZNcmJ2QuqKYXLjSDVyPnxYCvCLx2evx0nYtgFcFlAYQa1BzKPcnrfxEw2fbxs0xT+mTahwfL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719344293; c=relaxed/simple;
	bh=MSwPdZIrW+gTBvOh/ixQ0eTQ0o3l1Qbdg6EJACmShwk=;
	h=Date:To:From:Subject:Message-Id; b=CN0H7e2NsDPnPLhPM+harc4PYpfMrQZXmfP0FYbprtpYLujjNZ0DhKhz2vuJmb376ERSs/kVJRtewpM69FDrwvj2CKpcncetVc48OtKsOtz595PZZwjV8kpZJ/eVA8KoMNdo6wDXGhmiZUlcOacVHL6SZvbI+XQ9qYq/2ricvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XqJcvNdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XqJcvNdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439C3C32782;
	Tue, 25 Jun 2024 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719344293;
	bh=MSwPdZIrW+gTBvOh/ixQ0eTQ0o3l1Qbdg6EJACmShwk=;
	h=Date:To:From:Subject:From;
	b=XqJcvNdQXqgnVI4+HMC8JBmXwfb5+eisG6lz1ffqKkbKTOCzdUWXcu1BDauXHlFlj
	 zbn838R6Ekvu4WlRJRwFH0RXjiWryTchxab7XwCdto53ZgAOlQu/vWh/1DddjU2h1C
	 EaZm6xjsN/Al/l59WyyGc9/xa7KDLJtUKx/MTuLU=
Date: Tue, 25 Jun 2024 12:38:12 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-only-one-pool-in-zswap-v3.patch added to mm-unstable branch
Message-Id: <20240625193813.439C3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-use-only-one-pool-in-zswap-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-only-one-pool-in-zswap-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-only-one-pool-in-zswap-v3.patch

This patch will later appear in the mm-unstable branch at
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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm-zswap-use-only-one-pool-in-zswap-v3
Date: Tue, 25 Jun 2024 12:39:05 +0800

fix error handling again in zswap_pool_create(), per Yosry

Link: https://lkml.kernel.org/r/20240625-zsmalloc-lock-mm-everything-v3-2-ad941699cb61@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
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
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-ksm-refactor-out-try_to_merge_with_zero_page.patch
mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch
mm-ksm-optimize-the-chain-chain_prune-interfaces.patch

