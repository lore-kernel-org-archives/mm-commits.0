Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D410F4
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560325; cv=none; b=a3fkyhAw+TTQPXLCSGMQH6ZNlUz1+JAU7Q23KiSN7VW+uUj0RWMl1Ow3T2f0AfxitCELPNJBX1u26unKAfQLBOHy+QXurYuuh+ED19fyrmsy5TFhacD7LMf46tk2APtc8xNB+y85+1pY5vJfkiavOAYwdLojQYHhKrkkSpdTUaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560325; c=relaxed/simple;
	bh=OmR9+xS1Xog0P9SwJh2xYkuK7KETYdzKNpiedtiVEuw=;
	h=Date:To:From:Subject:Message-Id; b=uZnxkl2BCxKTerlmuD1yelNoN7uIti/uzNeWkMfb8JOMrQoSWfbX4vX8wXf2v8oO2oVlZ0ME9wgl7/ocYdmipqwyCqXGgo5BNuSrdlNUCWuOldV3g8p8ndClN2cU+CTyfM98JZrBSEuriw6RDgQKCSiHjkXaaaFItXqcnfVHLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZsWiIla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZsWiIla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035A1C4CEC6;
	Tue, 17 Sep 2024 08:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560324;
	bh=OmR9+xS1Xog0P9SwJh2xYkuK7KETYdzKNpiedtiVEuw=;
	h=Date:To:From:Subject:From;
	b=XZsWiIlam86lgE4PZjJYPOYxmtRsy+sTvFKuLs7xYfmErWjsyNAU4HTppMrE4pyJX
	 BldCJ6Y2k40xwY8UoraEiTWIfBd5G15V2BPKqmZAhORQSkiL7GsUmHS5NPZpCP4jLz
	 rkHuFmwK5e2V8omX09zWj3Ycyo8MvXNp6adulmmw=
Date: Tue, 17 Sep 2024 01:05:21 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-free-secondary-algorithms-names-v2.patch removed from -mm tree
Message-Id: <20240917080524.035A1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram-free-secondary-algorithms-names-v2
has been removed from the -mm tree.  Its filename was
     zram-free-secondary-algorithms-names-v2.patch

This patch was dropped because it was folded into zram-free-secondary-algorithms-names.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-free-secondary-algorithms-names-v2
Date: Tue, 17 Sep 2024 10:30:05 +0900

kfree(NULL) is legal

Link: https://lkml.kernel.org/r/20240917013021.868769-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-free-secondary-algorithms-names-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -2113,8 +2113,6 @@ static void zram_destroy_comps(struct zr
 	}
 
 	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		if (!zram->comp_algs[prio])
-			continue;
 		kfree(zram->comp_algs[prio]);
 		zram->comp_algs[prio] = NULL;
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-secondary-algorithms-names.patch

