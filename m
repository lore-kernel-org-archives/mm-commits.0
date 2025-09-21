Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25292749C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758484250; cv=none; b=EoEV2u1p162vv62APMmXOzNEG/odgr8Re3DjiLMVkRHYqmf1EhTPS5Qo274IBptfo+whDRnL/EoW4KEpMdGUFEvIcjqAa+Wb2g0xdQN+nb5KSfpmeA4FfbPyMu98YWSoPzVx39KG2Mymjyf+3hINpBm1ghUSxNTjDs9orZLbhJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758484250; c=relaxed/simple;
	bh=bswK4K1FkFUZbIE55XjJvFnU1a9DCBqEPvZjA9lhh9E=;
	h=Date:To:From:Subject:Message-Id; b=M/qsjw0adzPua/+BD6PQh7Kjm1TGk4tbjdzIZG5byeQr1rWGpExVmV6o1ck/7ooDB6pFW0uMWWXbiad8/SLb9IQ74gxWJo+XaxtAHdVufw0ruNUbmjKnLW2HmlkNbppJAxgKHVvR9Hq0C9fXa2h4DfzSCUyeA/6ve3td2LSnSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/vt8K91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/vt8K91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2123FC4CEE7;
	Sun, 21 Sep 2025 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758484250;
	bh=bswK4K1FkFUZbIE55XjJvFnU1a9DCBqEPvZjA9lhh9E=;
	h=Date:To:From:Subject:From;
	b=x/vt8K91MfHKa3v+xUAzR5Vf5fGhfT2OHTb6g9qITw4IoDkjKaQq8lHdLLp7w7+SM
	 PUQQO6Cgt5DDsLmRlcA+z8UvXokg6AToUwgLS1z76Pr9cvZfDpnJ01O54AfaaBUC54
	 KXZAzyax7zpv1tqEzxYwBat8gOE9pl0lUbLKO3ZU=
Date: Sun, 21 Sep 2025 12:50:49 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-interact-directly-with-zsmalloc-fix.patch removed from -mm tree
Message-Id: <20250921195050.2123FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: interact directly with zsmalloc fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-interact-directly-with-zsmalloc-fix.patch

This patch was dropped because it was folded into mm-zswap-interact-directly-with-zsmalloc.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: interact directly with zsmalloc fix
Date: Mon, 15 Sep 2025 10:56:15 -0400

Yosry points out that the default compressor check only applies when
something else is configured and we fall back, but not if it was
configured out of the box but isn't available.  Move the test.  Kconfig
should not permit this, so replace the pr_err() with a WARN.

Link: https://lkml.kernel.org/r/20250915153640.GA828739@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-interact-directly-with-zsmalloc-fix
+++ a/mm/zswap.c
@@ -306,12 +306,12 @@ static struct zswap_pool *__zswap_pool_c
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
-			pr_err("default compressor %s not available\n",
-			       zswap_compressor);
-			zswap_compressor = ZSWAP_PARAM_UNSET;
-			return NULL;
-		}
+	}
+
+	/* Default compressor should be available. Kconfig bug? */
+	if (WARN_ON_ONCE(!crypto_has_acomp(zswap_compressor, 0, 0))) {
+		zswap_compressor = ZSWAP_PARAM_UNSET;
+		return NULL;
 	}
 
 	return zswap_pool_create(zswap_compressor);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-interact-directly-with-zsmalloc.patch
mm-remove-unused-zpool-layer.patch
mm-zpdesc-minor-naming-and-comment-corrections.patch
mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

