Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBAF145A11
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379874; cv=none; b=EnipGGWd8IMbDl3Elu0ZY6O3Uu7BBnCjwsFcLR1Kv6yegRSuo4Ts1ZBkcW9s+rHUN+9/lHUnxRet0gyRzZZj6laaw2C6J/jBRZww1P1wyGMXJhPYWu/wTMFsCsxlvoYETgetuxYxIhZ5LWvv5woNISMhJEP8HNKjsPxi4yd1zhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379874; c=relaxed/simple;
	bh=QSOhgLwRMHdAh/r/oPJYC8Xs3nHmBelX9hnpL6IbKNw=;
	h=Date:To:From:Subject:Message-Id; b=SYuQq5N8PGPOzPz9QFd3sBYMQOJZvPNeiL7/inoKE7bD9pYcvLtHj8VWmV5hFR0vrYISBjyxKNPUCtMeDRzIfa73vx4QRXAA3cJho52UxCq+XRQSr31Ljxn739gvOA3AAb4zstkbTqw1SQn0XsL4CdEbdxYz+AxiVVj8N8e050A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gtnow6iN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gtnow6iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085F2C32782;
	Tue, 30 Jul 2024 22:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722379874;
	bh=QSOhgLwRMHdAh/r/oPJYC8Xs3nHmBelX9hnpL6IbKNw=;
	h=Date:To:From:Subject:From;
	b=Gtnow6iNpQI6eNPVQ20rUZqt9NoivpItoDiKcCBGDAaw/VxxxedrU7wo6ntATHSMH
	 Spq4zMN97eQKOHGCIz8UeYJBMjGtJbcDig9LI9TvIY3gvwHIPWyCWG6ZAlDjVWzp66
	 k7C8kh0ygvX79vnWaRYLUP6GmBi44uRIJ1IzB2As=
Date: Tue, 30 Jul 2024 15:51:13 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch added to mm-unstable branch
Message-Id: <20240730225114.085F2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix
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
Subject: zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix
Date: Tue, 30 Jul 2024 15:47:16 -0700

I put the referenced bit documentation in the wrong order. Fix this.

Link: https://lkml.kernel.org/r/20240730224716.2392068-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix
+++ a/mm/zswap.c
@@ -184,13 +184,13 @@ static struct shrinker *zswap_shrinker;
  * page within zswap.
  *
  * swpentry - associated swap entry, the offset indexes into the red-black tree
+ * length - the length in bytes of the compressed page data.  Needed during
+ *          decompression. For a same value filled page length is 0, and both
+ *          pool and lru are invalid and must be ignored.
  * referenced - true if the entry recently entered the zswap pool. Unset by the
  *              dynamic shrinker. The entry is only reclaimed by the dynamic
  *              shrinker if referenced is unset. See comments in the shrinker
  *              section for context.
- * length - the length in bytes of the compressed page data.  Needed during
- *          decompression. For a same value filled page length is 0, and both
- *          pool and lru are invalid and must be ignored.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
  * value - value of the same-value filled pages which have same content
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch
zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch
zswap-increment-swapin-count-for-non-pivot-swapped-in-pages.patch

