Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B371531F0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188435; cv=none; b=NzzmSTt1nntmzE/oO35DiJ5MsT8Y6WW2GI87GocNZ5Y+Ip5k6GqQs9R9nAeL5bz778GVARhP19wopPtq9a2KHKpiYISA6HgHdry19SATQHM5vMIMrqFzQ1qeLPJjwI53ZGSs2f+PEdIw82xxCwNHoI4Q+M9E61mHuFht0zZa7Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188435; c=relaxed/simple;
	bh=2gSUlEvyN2WG6zU0ftnsu7BA3anbNGdbnZpHw+lZIAc=;
	h=Date:To:From:Subject:Message-Id; b=UI4Gf9XlWjZZaLBXjZdNYO16D2cp28+L0fp66mBISqRmFzOMApRnQPWpMeo4Y7IJNC02rJSFx53plWyooZDdkDAlve7GpQtLXCy4w1UF+rTA6P689OTjbNunidCne+t/exTjqBDEfOU4ulRPoQARDxJTArk9nI9bjRuwgwEUrks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LojjnXTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LojjnXTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB849C4CEEC;
	Mon, 17 Mar 2025 05:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188434;
	bh=2gSUlEvyN2WG6zU0ftnsu7BA3anbNGdbnZpHw+lZIAc=;
	h=Date:To:From:Subject:From;
	b=LojjnXTROLTOPWaIAqMGmj26UC2ZMy8xsT9/y7CeLF08E5gzzNbV/9n2Y6KdLSAwB
	 nCK1qvv4zNTm6x6Ay5CPHGqJMuZCEgd3RQOmUrpwxR/XdFhwp+J7lB5NPhdAX6KrLI
	 W3i9OrUVoOxFJevqayMvTrSKA49lRbBAUFkkZHj0=
Date: Sun, 16 Mar 2025 22:13:54 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-might_sleep-to-zcomp-api.patch removed from -mm tree
Message-Id: <20250317051354.CB849C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add might_sleep to zcomp API
has been removed from the -mm tree.  Its filename was
     zram-add-might_sleep-to-zcomp-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add might_sleep to zcomp API
Date: Mon, 3 Mar 2025 11:03:28 +0900

Explicitly state that zcomp compress/decompress must be called from
non-atomic context.

Link: https://lkml.kernel.org/r/20250303022425.285971-20-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zcomp.c~zram-add-might_sleep-to-zcomp-api
+++ a/drivers/block/zram/zcomp.c
@@ -146,6 +146,7 @@ int zcomp_compress(struct zcomp *comp, s
 	};
 	int ret;
 
+	might_sleep();
 	ret = comp->ops->compress(comp->params, &zstrm->ctx, &req);
 	if (!ret)
 		*dst_len = req.dst_len;
@@ -162,6 +163,7 @@ int zcomp_decompress(struct zcomp *comp,
 		.dst_len = PAGE_SIZE,
 	};
 
+	might_sleep();
 	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


