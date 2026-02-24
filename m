Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8721ABAA;
	Tue, 24 Feb 2026 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771895721; cv=none; b=M12QPVqGUAmGdRcybR0CLBGK8F+DQfysHIPwmTICfGx2dnSZR4WKWrycNSskZk0lE5fidWPXJU/vsBEdAvVYRh3RQStB2pj9jw/su+4QoTpC/pr9DBdrPxx0Oc8mg5Yw3qpr+PcITez16R0+qYVBIs72r1rP+7ZUH6FBCqLyjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771895721; c=relaxed/simple;
	bh=hSzy76o+yEL+1VjbZL6wlJpOTnTwzfUKbYy9KwvbEsE=;
	h=Date:To:From:Subject:Message-Id; b=CFzk5zOsFjGBm+dHpDouoQ+B+nXYl5x93FHEa6G38DH2xeZG3Wzwi8Oc4HSktEep5QMFLJui6HCo7yI2EL/GGbKgXt19g16JIdYDxXP0jLwZZnI7KaqyovQGc177C4Nh778SgfVKMkIRolRVqFIzpO1QJcIPbDdb4VpE5aH0wxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZuHhu+5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZuHhu+5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F3AC116C6;
	Tue, 24 Feb 2026 01:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771895721;
	bh=hSzy76o+yEL+1VjbZL6wlJpOTnTwzfUKbYy9KwvbEsE=;
	h=Date:To:From:Subject:From;
	b=ZuHhu+5BKPeYphC1eSolUK3BOiu1Bq6U3F8p4MTDMGMEMLabOIrVTFAHvT1/wwwDn
	 jP1ARQzLzeOFEc8U2mJA6SozhI4Kgi88kl3KGzEhW+xGgBEbuCHGWnayCNyYq6dUEO
	 Mybkt3mKM5GEA8xT/ap6snjUMnvPIL4WTe74bKfM=
Date: Mon, 23 Feb 2026 17:15:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,raul_pazemecxas@hotmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch added to mm-hotfixes-unstable branch
Message-Id: <20260224011521.15F3AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: clear walk_control on inactive context in damos_walk()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Reported-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Closes: https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
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

mm-damon-core-clear-walk_control-on-inactive-context-in-damos_walk.patch

