Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6B37D13C;
	Wed,  4 Mar 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646299; cv=none; b=KWNYasWXA0m0VjdkH0RD9BArrRd0SXcSXdm52QDsWng0IKjNOl3cCtDhRs5OUwn+vyTUDCYEaKTqjHoW6xLWGepz1eC0Ap066t3ggANKdP6IId0NJ3R6kNLw6RqLbvVpPXfWpTvDg9fBK60ZuYyCxtZSXZgNbmYrw39C2o8fWGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646299; c=relaxed/simple;
	bh=buQ+gzgOa4Ep5hhRZzKl1M1l3gt0d0dm3Gkz/sM9Ccw=;
	h=Date:To:From:Subject:Message-Id; b=RdNu55bly2pyC7/lAebLQfN8Xf6TowSHQuShibpnvd3EIEufAqC12XeWjT/QRwll4cCcE8Kc/hc3IeOhjU/DNlVthWviSGCyRolN2OZ16A8+EHd/BAWYVQDYKNxvqdxneD/xJA8LdUbnp0Ump6ndSA6tiTv5xAbciBTUmmqe2Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=viGycx1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="viGycx1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A758AC2BC86;
	Wed,  4 Mar 2026 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646299;
	bh=buQ+gzgOa4Ep5hhRZzKl1M1l3gt0d0dm3Gkz/sM9Ccw=;
	h=Date:To:From:Subject:From;
	b=viGycx1SLqg6myzdF88LY8N4RkTWt12zYZN79INcdZvO0AknMq8SjSzP5hT1VWzW7
	 7aQp0MAnoum/zxEk0p/blYMrz5u+h/5DI4oHZWjUE37r3IjPSdOhiRZXRY69SHLXPM
	 ycFranE82y19YpHAAEYrmfptucw55xsg99IBl9pI=
Date: Wed, 04 Mar 2026 09:44:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,raul_pazemecxas@hotmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch removed from -mm tree
Message-Id: <20260304174459.A758AC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: clear walk_control on inactive context in damos_walk()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Subject: mm/damon/core: clear walk_control on inactive context in damos_walk()
Date: Mon, 23 Feb 2026 17:10:59 -0800

damos_walk() sets ctx->walk_control to the caller-provided control
structure before checking whether the context is running.  If the context
is inactive (damon_is_running() returns false), the function returns
-EINVAL without clearing ctx->walk_control.  This leaves a dangling
pointer to a stack-allocated structure that will be freed when the caller
returns.

This is structurally identical to the bug fixed in commit f9132fbc2e83
("mm/damon/core: remove call_control in inactive contexts") for
damon_call(), which had the same pattern of linking a control object and
returning an error without unlinking it.

The dangling walk_control pointer can cause:
1. Use-after-free if the context is later started and kdamond
   dereferences ctx->walk_control (e.g., in damos_walk_cancel()
   which writes to control->canceled and calls complete())
2. Permanent -EBUSY from subsequent damos_walk() calls, since the
   stale pointer is non-NULL

Nonetheless, the real user impact is quite restrictive.  The
use-after-free is impossible because there is no damos_walk() callers who
starts the context later.  The permanent -EBUSY can actually confuse
users, as DAMON is not running.  But the symptom is kept only while the
context is turned off.  Turning it on again will make DAMON internally
uses a newly generated damon_ctx object that doesn't have the invalid
damos_walk_control pointer, so everything will work fine again.

Fix this by clearing ctx->walk_control under walk_control_lock before
returning -EINVAL, mirroring the fix pattern from f9132fbc2e83.

Link: https://lkml.kernel.org/r/20260224011102.56033-1-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Reported-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Closes: https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
Signed-off-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk
+++ a/mm/damon/core.c
@@ -1562,8 +1562,13 @@ int damos_walk(struct damon_ctx *ctx, st
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx))
+	if (!damon_is_running(ctx)) {
+		mutex_lock(&ctx->walk_control_lock);
+		if (ctx->walk_control == control)
+			ctx->walk_control = NULL;
+		mutex_unlock(&ctx->walk_control_lock);
 		return -EINVAL;
+	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;
_

Patches currently in -mm which might be from raul_pazemecxas@hotmail.com are


