Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840F1EF091;
	Wed, 24 Sep 2025 22:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758751849; cv=none; b=gzgRvDw9GLMQ5veExrgtu3nHtkiHBdA74YcyZnSf9GG0yP5jCZG0P8vlLoNlSzfsMDh1s+Qrx1gx7FnKcd31IN8kH3FHzywqwl3n/GTiBwaYETwbJqxFFiLekoSx/FPsDJtrCVzCCG0uaP2813tuhzX+JzMyDUyJNs+/xu3+FTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758751849; c=relaxed/simple;
	bh=ZHSUdoXLU/5eHX9wIMEyXf8BV1ScP0M+3QD7Zb3hdks=;
	h=Date:To:From:Subject:Message-Id; b=Akgtbxg9hWpYFs5Ud6yTsNR9Pi4XJDbFQyHOd8Im29Rwdye7GUZUzD0czQnhqg05kPXhaL7K+gxlWv6zVg6YeI9Yk/yE78JF9j76Og82ZMv/7DrfgCBnqxJyyqakQkDwdczeeyUQ2n0nWUtsA9J3GiqWOwxT67+gU3IEp9ZmkO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12hytEiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12hytEiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6D9C4CEE7;
	Wed, 24 Sep 2025 22:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758751849;
	bh=ZHSUdoXLU/5eHX9wIMEyXf8BV1ScP0M+3QD7Zb3hdks=;
	h=Date:To:From:Subject:From;
	b=12hytEiHraiZ4TRLt1p3jhmqkN/luE4xHVGjidSzhCjqE61bJyD2ltJEMhyMVTxTP
	 XGMLwUqlv6MH9GXBb+wVXhzIzMjyhL9b+RJj6MgnVAdal2B01dh9xcKjPlZduXWyME
	 kOru/caoARaiPHTyiUBDy8g5Yklhjk1MAAF8KIWc=
Date: Wed, 24 Sep 2025 15:10:48 -0700
To: mm-commits@vger.kernel.org,vz@mleia.com,stable@vger.kernel.org,p.zabel@pengutronix.de,johan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch added to mm-nonmm-unstable branch
Message-Id: <20250924221049.1F6D9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/genalloc: fix device leak in of_gen_pool_get()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Johan Hovold <johan@kernel.org>
Subject: lib/genalloc: fix device leak in of_gen_pool_get()
Date: Wed, 24 Sep 2025 10:02:07 +0200

Make sure to drop the reference taken when looking up the genpool platform
device in of_gen_pool_get() before returning the pool.

Note that holding a reference to a device does typically not prevent its
devres managed resources from being released so there is no point in
keeping the reference.

Link: https://lkml.kernel.org/r/20250924080207.18006-1-johan@kernel.org
Fixes: 9375db07adea ("genalloc: add devres support, allow to find a managed pool by device")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genalloc-fix-device-leak-in-of_gen_pool_get
+++ a/lib/genalloc.c
@@ -899,8 +899,11 @@ struct gen_pool *of_gen_pool_get(struct
 		if (!name)
 			name = of_node_full_name(np_pool);
 	}
-	if (pdev)
+	if (pdev) {
 		pool = gen_pool_get(&pdev->dev, name);
+		put_device(&pdev->dev);
+	}
+
 	of_node_put(np_pool);
 
 	return pool;
_

Patches currently in -mm which might be from johan@kernel.org are

lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch

