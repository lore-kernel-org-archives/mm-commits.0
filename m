Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8C2D94A9
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965991; cv=none; b=pBGV9FuUXEvjVhPtbao1vRRQMwGI1X+oLLHkjK1GZ6kzzHavLOsyTkhHY/JxTEA3R+A/lsUozxUr16meUO6AQ3/CdX1+DdzCRyzHSs7cMKyT0dLz6eW1AB0ALjC3a+GDC1m8R11ni2PjwL3Gu95UIXRZ+f1xUoo/a9fPDs2neTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965991; c=relaxed/simple;
	bh=WOAigAAudE9/qWJTrvE59B/0EF8V/25apiVn1rPWDdk=;
	h=Date:To:From:Subject:Message-Id; b=e8ws/3O5E7OKgBx4FRP1HRySdHDzgK3nnQUIhID1iLxmAv6WSpOnL045KZUTP17nh3Gj6Aa+JJBz8+Nlr5KL9THD3d4UKvVH5AJFUvfxHHh4jvj1T/noJ4f+lE+mOkoG+JGHJGflFL1rDk/0YqEF+2055kSwIbjUJuEDS3zsxxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IONCjnPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IONCjnPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84049C16AAE;
	Wed, 21 Jan 2026 03:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965990;
	bh=WOAigAAudE9/qWJTrvE59B/0EF8V/25apiVn1rPWDdk=;
	h=Date:To:From:Subject:From;
	b=IONCjnPQmrVACKCs8ctoLLIzI86awyBrkUCzTASmh+72YONEl9hAeR2i3NYRU+mgC
	 NK6D85iJwcDTyp6PCvq14wyt/wve2C6Vez96OWqzhCA5KzzKSHdNUyAbnun4QXrn6N
	 xWiTy/B7OiEW6rzi6ekhAFThO/7fSucxAaaFtyi4=
Date: Tue, 20 Jan 2026 19:26:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch removed from -mm tree
Message-Id: <20260121032630.84049C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix memory leak of repeat mode damon_call_control objects
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: fix memory leak of repeat mode damon_call_control objects
Date: Tue, 2 Dec 2025 16:23:40 +0800

A memory leak exists in the handling of repeat mode damon_call_control
objects by kdamond_call().  While damon_call() correctly allows multiple
repeat mode objects (with ->repeat set to true) to be added to the
per-context list, kdamond_call() incorrectly processes them.

The function moves all repeat mode objects from the context's list to a
temporary list (repeat_controls).  However, it only moves the first object
back to the context's list for future calls, leaving the remaining objects
on the temporary list where they are abandoned and leaked.

This patch fixes the leak by ensuring all repeat mode objects are properly
re-added to the context's list.

Note that the leak is not in the real world, and therefore no user is
impacted.  It is only potential for imaginaray damon_call() use cases that
do not exist in the tree for now.  In more detail, the leak happens only
when the multiple repeat mode objects are assumed to be deallocated by
kdamond_call() (damon_call_control->dealloc_on_cancel is set).  There is
no such damon_call() use cases at the moment.

Link: https://lkml.kernel.org/r/20251202082340.34178-1-lienze@kylinos.cn
Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects
+++ a/mm/damon/core.c
@@ -2606,13 +2606,19 @@ static void kdamond_call(struct damon_ct
 			list_add(&control->list, &repeat_controls);
 		}
 	}
-	control = list_first_entry_or_null(&repeat_controls,
-			struct damon_call_control, list);
-	if (!control || cancel)
-		return;
-	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
+	while (true) {
+		control = list_first_entry_or_null(&repeat_controls,
+				struct damon_call_control, list);
+		if (!control)
+			break;
+		/* Unlink from the repeate_controls list. */
+		list_del(&control->list);
+		if (cancel)
+			continue;
+		mutex_lock(&ctx->call_controls_lock);
+		list_add(&control->list, &ctx->call_controls);
+		mutex_unlock(&ctx->call_controls_lock);
+	}
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from lienze@kylinos.cn are


