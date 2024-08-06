Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456BE18D62B
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722973488; cv=none; b=mK/HkPQPxeD78QyoI02+c9+8YOX8o19a8Tu0/iXYqcjFjWUMsNncRDc3alN6uOnzUDI3Sm8l4RmsCYuYHDmOSHROwcmJ/DIQSziQaIGuRbWXCpSnTezYR/38q2i0OhkcpLnxY4vLG5pu5E/ehWu/KKW+YiQs464IOKfn6cp/+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722973488; c=relaxed/simple;
	bh=CqlADVGwZ6Xn8ifC1eTdcih2w8Y38nxKa9vE5aOjln0=;
	h=Date:To:From:Subject:Message-Id; b=P3/mpoyvNPOJCvU9d89hDQ1t9TzJ5f4DnOsYMfjfKRO2QvPRAqYkd1WE/njHpvlOevOH0tFIr79pkDwSg/hMOn/UDu6T+kTM4nHkJbsumNe7FMZ/1UM1hYqRyxMFkPug+bsFbJdoQ8nJvLjVjIjoTirwj42bq0/P9D8Ve+w9/2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBYQE6sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBYQE6sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F8C32786;
	Tue,  6 Aug 2024 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722973488;
	bh=CqlADVGwZ6Xn8ifC1eTdcih2w8Y38nxKa9vE5aOjln0=;
	h=Date:To:From:Subject:From;
	b=vBYQE6sGrht7q8r45WUNSMRVKLCDmzD1iR6pvM0tIN2O2W1BeD/UuhAwolKqFmAwX
	 dFJw+BtqGuP1RhzA2rzXyO0TI1AHcmkk+b+Er5IkjnmJ8yhZQutZcvk3boJNNA1WHR
	 Sg0MU4Y6elcphpMl+Sr5pp8J+VeLBDRdM+5JAzvw=
Date: Tue, 06 Aug 2024 12:44:47 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch added to mm-unstable branch
Message-Id: <20240806194447.ED3F8C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: implement a second chance algorithm for dynamic zswap shrinker (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch

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
zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch
zswap-track-swapins-from-disk-more-accurately.patch
zswap-track-swapins-from-disk-more-accurately-fix.patch

