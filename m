Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DCEAC5
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337166; cv=none; b=ptrQWvbQQdhWbzm6lUg9c8j4htJOpFI3AaOLHbcr4QtYjKCFjdFmNB1nXe8d2EKDz9HgLG0MNw7O3Baf+bqM6tS6KUrsAdU8Fw5tvwWiKYTtEGmxUPtKUjwoA2eXFrZ/pjybCjYTo4GKkjOxOPizPcwP8xKTdapljZ2iYup+xow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337166; c=relaxed/simple;
	bh=W/iahzEXZBgL179z6Zm/QbobmpkDIO0SM0RrYYmDvqc=;
	h=Date:To:From:Subject:Message-Id; b=da6XUdYqEdwjzFj/UCcClsSP+VdRbabwgI4wh3h8Ktrw95fOEzYzF3iWR1t+ipeFxAXbH0rS11UQgH+rWJiyzGQDvinktrEveKaX3y9mYSqrjbA9XTqUZnX6R4i7wMTfS05UQ4pv9kA6YMfnhg2ZJuH+5vndGG0AXg2y3Jkbhh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSRhKu7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSRhKu7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5728EC4CED6;
	Mon, 20 Jan 2025 01:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337166;
	bh=W/iahzEXZBgL179z6Zm/QbobmpkDIO0SM0RrYYmDvqc=;
	h=Date:To:From:Subject:From;
	b=pSRhKu7SlqxL+3bFq0NUOOHqOo7LEASCjpxQcIiBRGk/M6JbouXY7mIrVBxlIhF2Z
	 zR/q6hb2cMQ0iY4V5DELV+hW14Lb+hgmRsX+3OG6NgiI9xEu4R1O1On65QoGfdPBCp
	 KX4R1RKeR9JRqqKOH1ObivqqW443zFfE96rpINH4=
Date: Sun, 19 Jan 2025 17:39:25 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-zcomp_stream_put-from-write_incompressible_page.patch removed from -mm tree
Message-Id: <20250120013926.5728EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove zcomp_stream_put() from write_incompressible_page()
has been removed from the -mm tree.  Its filename was
     zram-remove-zcomp_stream_put-from-write_incompressible_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove zcomp_stream_put() from write_incompressible_page()
Date: Wed, 15 Jan 2025 16:19:16 +0900

We cannot and should not put per-CPU compression stream in
write_incompressible_page() because that function never gets any
per-CPU streams in the first place.  It's zram_write_page() that
puts the stream before it calls write_incompressible_page().

Link: https://lkml.kernel.org/r/20250115072003.380567-1-senozhatsky@chromium.org
Fixes: 485d11509d6d ("zram: factor out ZRAM_HUGE write")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-zcomp_stream_put-from-write_incompressible_page
+++ a/drivers/block/zram/zram_drv.c
@@ -1683,7 +1683,6 @@ static int write_incompressible_page(str
 		return PTR_ERR((void *)handle);
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


