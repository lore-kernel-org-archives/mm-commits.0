Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D484B25EFBD
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 22:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754431444; cv=none; b=Gp68MKb0eskwh1kebhX/QzGafZlxO4gys2h9hB75TwQWcsd53uJZhw2mTvvgCWjSeyEK8jgPBd9Q9r8xHC5sBXMYXkbApOoM/thFeJxSTmpS7irHnjUOU/+GNJ3ylqXShhhpTmOnRW695jqqFs1D/tzh295LLfXY+ePZdbrOuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754431444; c=relaxed/simple;
	bh=//X+fZe2bImneSb7g4HkH/Vv8XxMpj1g+f98nCj6H9w=;
	h=Date:To:From:Subject:Message-Id; b=d3XvRTB374j5wD13l5v99UADOE1e0RkbPZxU8eXdJCTy2pa2p8C7Ny6KOYmOHaorKLGcfHMZf4AlwVTw2k+jwK5Y6Jeulpj0XEBrqCix1LixggujJ90KBt+/qOpAwMx0+02yzsx5ZTyKkXUBFOZt7GanVCJocHKwGqKaXAvrehE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GFFdYEuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFFdYEuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EAEC4CEF0;
	Tue,  5 Aug 2025 22:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754431444;
	bh=//X+fZe2bImneSb7g4HkH/Vv8XxMpj1g+f98nCj6H9w=;
	h=Date:To:From:Subject:From;
	b=GFFdYEucidMEWVydYBD3L1mB8DE2ryef6jg9j6JKTcmZYHcB0SnL3kYBJbzyWGGrB
	 u7J6ZAnXpy5FH9Knqz6BW5WqlF36DAui7zqAXLSBRh+dQzdWRk7oZ1EK/NmctNHO2D
	 I3HtFeUieRvPwJryHl1gePdBIJCSgY/IBRyZPDjA=
Date: Tue, 05 Aug 2025 15:04:03 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,imandevel@gmail.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-protect-recomp_algorithm_show-with-init_lock.patch added to mm-new branch
Message-Id: <20250805220404.43EAEC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: protect recomp_algorithm_show() with ->init_lock
has been added to the -mm mm-new branch.  Its filename is
     zram-protect-recomp_algorithm_show-with-init_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-protect-recomp_algorithm_show-with-init_lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: protect recomp_algorithm_show() with ->init_lock
Date: Tue, 5 Aug 2025 19:19:29 +0900

sysfs handlers should be called under ->init_lock and are not supposed to
unlock it until return, otherwise e.g.  a concurrent reset() can occur. 
There is one handler that breaks that rule: recomp_algorithm_show().

Move ->init_lock handling outside of __comp_algorithm_show() (also drop it
and call zcomp_available_show() directly) so that the entire
recomp_algorithm_show() loop is protected by the lock, as opposed to
protecting individual iterations.

Link: https://lkml.kernel.org/r/20250805101946.1774112-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Seyediman Seyedarab <imandevel@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-protect-recomp_algorithm_show-with-init_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -1225,18 +1225,6 @@ static void comp_algorithm_set(struct zr
 	zram->comp_algs[prio] = alg;
 }
 
-static ssize_t __comp_algorithm_show(struct zram *zram, u32 prio,
-				     char *buf, ssize_t at)
-{
-	ssize_t sz;
-
-	down_read(&zram->init_lock);
-	sz = zcomp_available_show(zram->comp_algs[prio], buf, at);
-	up_read(&zram->init_lock);
-
-	return sz;
-}
-
 static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
 {
 	char *compressor;
@@ -1387,8 +1375,12 @@ static ssize_t comp_algorithm_show(struc
 				   char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
+	ssize_t sz;
 
-	return __comp_algorithm_show(zram, ZRAM_PRIMARY_COMP, buf, 0);
+	down_read(&zram->init_lock);
+	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_COMP], buf, 0);
+	up_read(&zram->init_lock);
+	return sz;
 }
 
 static ssize_t comp_algorithm_store(struct device *dev,
@@ -1412,14 +1404,15 @@ static ssize_t recomp_algorithm_show(str
 	ssize_t sz = 0;
 	u32 prio;
 
+	down_read(&zram->init_lock);
 	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
 
 		sz += sysfs_emit_at(buf, sz, "#%d: ", prio);
-		sz += __comp_algorithm_show(zram, prio, buf, sz);
+		sz += zcomp_available_show(zram->comp_algs[prio], buf, sz);
 	}
-
+	up_read(&zram->init_lock);
 	return sz;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-protect-recomp_algorithm_show-with-init_lock.patch

