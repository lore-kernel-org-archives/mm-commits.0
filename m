Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979613B284
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854788; cv=none; b=W+LGXRr4GT6hTF3DzoNkcfszpfp3u12vbC9Sg4Hpk67maF/hw+M0u0iDMYewAsYsK0aG91Lgi5++9o2iuNanS9hnTbDpNirLCEHJd85M/wAEC25PexBK8Yg8kSXZZUK7Qm1iBXA8jxIEN5nnkjwR8PlA57qnQB9vXONk5fDHNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854788; c=relaxed/simple;
	bh=JZK847lxsZqL53lH+eHeCljfPz53EFUBdXcHNnLkLG0=;
	h=Date:To:From:Subject:Message-Id; b=WSZ0luHk9zLzrxCZ09RCF3EF0kMbmFWl+ZSx0YKqxr3XjQyh+uayn6CcVQQFVgvjREfYBx4voYo9BvQMlAqV3tX5LtTyqBT+E0+/P4n+5JIfNl9gH7HxCMFRAnAs7hPxCFRbId4pZytCIITxj/hx+hjlf4Bjg7HW/T3E579kmok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDZWOMe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDZWOMe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31999C4CECF;
	Wed,  6 Nov 2024 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854788;
	bh=JZK847lxsZqL53lH+eHeCljfPz53EFUBdXcHNnLkLG0=;
	h=Date:To:From:Subject:From;
	b=wDZWOMe9+P5w0N+5lnRl4Tg5Oz00OQuzUDuJNzEKCGkq165bo4gH5OdG0ODHTrE6s
	 psgfZN7+aJYGK4QuuvrdXgsOgayv+YgQadsM0cUzvezVz0ZGph7XPkKtVgHHCg3MGs
	 Tke0jUjppY4ZGshZVT6gB9p9aKojr+gGq0aZiwAI=
Date: Tue, 05 Nov 2024 16:59:47 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-open-code-comp-priority-0.patch removed from -mm tree
Message-Id: <20241106005948.31999C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not open-code comp priority 0
has been removed from the -mm tree.  Its filename was
     zram-do-not-open-code-comp-priority-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not open-code comp priority 0
Date: Wed, 9 Oct 2024 13:28:00 +0900

A cosmetic change: do not open-code compression priority 0, use
ZRAM_PRIMARY_COMP instead.

Link: https://lkml.kernel.org/r/20241009042908.750260-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-open-code-comp-priority-0
+++ a/drivers/block/zram/zram_drv.c
@@ -2285,7 +2285,7 @@ static void zram_destroy_comps(struct zr
 {
 	u32 prio;
 
-	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		struct zcomp *comp = zram->comps[prio];
 
 		zram->comps[prio] = NULL;
@@ -2357,7 +2357,7 @@ static ssize_t disksize_store(struct dev
 		goto out_unlock;
 	}
 
-	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch

