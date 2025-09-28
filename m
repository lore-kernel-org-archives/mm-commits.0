Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E20244698;
	Sun, 28 Sep 2025 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084638; cv=none; b=VSPG52LGmp4yv16vntL59RiQ/1FNLznjVi0LO9mvqruBujuSIabU6zOeQ2YpmyjsdfkFNhYr4aOiqtpYkGxICrO3AqtCxqZIIDghvI6OR6aOooy1lNklgmOsORKsMDOJZRqhUf+eQNhTw0H8ran+B2KExkwhfvegkcD72YXsyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084638; c=relaxed/simple;
	bh=8C8APHI1OcYR991Q3VQuEDl6aOIGCguV/TGBO6qr+1I=;
	h=Date:To:From:Subject:Message-Id; b=lDgmlOrMPKAPYX7bh1ws4W+4Ko5BjaJDKPPnZYgMtRf4gXJkGk5QIqdKBdLke0MAJkEQuLOjA6vYQvzRjpsvcJI5vM2DJpEI+yEpeYXEkystu5JtcypWdiVXDF+hkRNzS0P/Bwz0Aa1EXtztaq235xg8xYCecJiUQwSLSRFBK10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVevZ+WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVevZ+WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E5CC4CEF7;
	Sun, 28 Sep 2025 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084637;
	bh=8C8APHI1OcYR991Q3VQuEDl6aOIGCguV/TGBO6qr+1I=;
	h=Date:To:From:Subject:From;
	b=xVevZ+WDshb0cdEEkcVxMKnJrZEjBI4M1vXlO6h8XoBZLOk9dVfLAM1ItNUPsqFJ7
	 3x99b7snKRJln2YblBnuS+d1nIaWT7HwWEkZSFcmTcvBQvZhb2Yk8ZQFSByhQoET60
	 v+EXOHLAcAnifG+1C4v/5UxtSq6DOCwOGQJ89qSY=
Date: Sun, 28 Sep 2025 11:37:17 -0700
To: mm-commits@vger.kernel.org,vz@mleia.com,stable@vger.kernel.org,p.zabel@pengutronix.de,johan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch removed from -mm tree
Message-Id: <20250928183717.C1E5CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/genalloc: fix device leak in of_gen_pool_get()
has been removed from the -mm tree.  Its filename was
     lib-genalloc-fix-device-leak-in-of_gen_pool_get.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


