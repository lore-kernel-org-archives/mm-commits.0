Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49154749C
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737095; cv=none; b=hAxtLP5d4bGCvsidMaP6b1WX+3U82ZKM0LSEC+3mAEhYOxOVONguOrJ99NcqX3vFhb+NBJNl4tKkaX90/4rJGrA61tglP+0iWNIyaluCgD7Tw8isAGdp7MEW5n+AVQI0Kkek3uVkPxoOgqSUjkb9KiA7JfFbrYoBGYSnHVaQdVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737095; c=relaxed/simple;
	bh=Dhz5R58DsfsjAg1pVLasMdQAfxnZBM6jKh+pHqUlhrI=;
	h=Date:To:From:Subject:Message-Id; b=nLeKjAoekdssKCw/oFSkWnGw3GR/lJYE9rFxH5GKD/sCBN9YSiixrWcd4e9MW5WVWqJNBDfBFpEZkpbaa6H1vv6kukvQ8+a6ObRVnU+froHi+VgG2K0t9xMdlnqREGKPx3WA43/5NUexyLNBFla5fJl1OfyAF9TBeuyUqVLmk1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SO3rIOLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SO3rIOLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635EC4CEDF;
	Mon, 13 Jan 2025 02:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737095;
	bh=Dhz5R58DsfsjAg1pVLasMdQAfxnZBM6jKh+pHqUlhrI=;
	h=Date:To:From:Subject:From;
	b=SO3rIOLvko427tyiAXyWJj7iNmPtfbsfzYTopbD6MI0u0JdHw/J+ZlS75aqKR/NT3
	 /A7QgmDL65JMaX9vSjmDwSuoPd9qY8PL188v6noAoXhjQrNquz85MvvwzMdAbr1beF
	 Lt5IzhYGbmFV26TmO2QADVZ7ztgoDC4E9dg4stTA=
Date: Sun, 12 Jan 2025 18:58:14 -0800
To: mm-commits@vger.kernel.org,vitalywool@gmail.com,samsun1006219@gmail.com,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch removed from -mm tree
Message-Id: <20250113025815.1635EC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch

This patch was dropped because it was folded into mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
Date: Wed, 8 Jan 2025 16:25:56 -0800

remove comment

Link: https://lkml.kernel.org/r/CAJD7tkaxS1wjn+swugt8QCvQ-rVF5RZnjxwPGX17k8x9zSManA@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sam Sun <samsun1006219@gmail.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
+++ a/mm/zswap.c
@@ -848,8 +848,6 @@ static int zswap_cpu_comp_prepare(unsign
 		ret = -ENOMEM;
 		goto req_fail;
 	}
-
-	/* acomp_ctx->req must be NULL if the acomp_ctx is not fully initialized */
 	acomp_ctx->req = req;
 
 	crypto_init_wait(&acomp_ctx->wait);
_

Patches currently in -mm which might be from yosryahmed@google.com are

revert-mm-zswap-fix-race-between-compression-and-cpu-hotunplug.patch
mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug.patch

