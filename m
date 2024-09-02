Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B110C1804A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246810; cv=none; b=nQ7raQl0rlNkbzoEJ6iRilto8RIST9ATrfuI82TIJ7mAddoaygWHr0F1KXgPju2kho+BGPi6f1H4XlSliHh6m/kIv/TxxZkpFu07ce9J0FRysEv8vDyZQFoXVN9XCcmqu0/4AogjaY8fYhJP06ipOhG8kezQnbb6uQwsswbKR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246810; c=relaxed/simple;
	bh=HA5slxnPExIJ4Yo5Y1O4nZe4DNwtGajbLO79Kla/z4c=;
	h=Date:To:From:Subject:Message-Id; b=r8CVUfg/GxvQOepgODpasAWTd4EjJ1XQTPK/6Jm2nZFCYJAjdZc3dlTdifDz3MP51mTEWClMks+BHOSAPKqnbkMduKglil0Oy8ZwUKl8bb46+zbcSPDx6gjn2aVe4fuhF3HuqFCszObhuW81V0SYSAi2yMrmtAtxnVeYt2tWboo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Skkw/5k1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Skkw/5k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A77C4CEC3;
	Mon,  2 Sep 2024 03:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246809;
	bh=HA5slxnPExIJ4Yo5Y1O4nZe4DNwtGajbLO79Kla/z4c=;
	h=Date:To:From:Subject:From;
	b=Skkw/5k1OJ8HYlAMCetV1+iuKwg9Z8kFkl5nkmbNs0AdFtMx71/Gk1bYewbs741fD
	 G4sCaZhqxAqOVI+AhyzVDogi0ey110LAwLJqg/r5InhodbTd3ArVS3TMwYdrVbuzbP
	 ah44mvWTFg1APBYwcPJ6B+R/BxNC6KeFEiHeI/TQ=
Date: Sun, 01 Sep 2024 20:13:29 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch removed from -mm tree
Message-Id: <20240902031329.D5A77C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: implement a second chance algorithm for dynamic zswap shrinker (fix)
has been removed from the -mm tree.  Its filename was
     zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch

This patch was dropped because it was folded into zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: implement a second chance algorithm for dynamic zswap shrinker (fix)
Date: Mon, 5 Aug 2024 17:34:03 -0700

Fix a small mistake in the referenced bit documentation.

Link: https://lkml.kernel.org/r/20240806003403.3142387-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix
+++ a/mm/zswap.c
@@ -188,8 +188,8 @@ static struct shrinker *zswap_shrinker;
  *          decompression. For a same value filled page length is 0, and both
  *          pool and lru are invalid and must be ignored.
  * referenced - true if the entry recently entered the zswap pool. Unset by the
- *              dynamic shrinker. The entry is only reclaimed by the dynamic
- *              shrinker if referenced is unset. See comments in the shrinker
+ *              writeback logic. The entry is only reclaimed by the writeback
+ *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch
zswap-track-swapins-from-disk-more-accurately.patch
zswap-track-swapins-from-disk-more-accurately-fix.patch

