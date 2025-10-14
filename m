Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988292DC785;
	Tue, 14 Oct 2025 21:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476878; cv=none; b=o3reTsPKbP9QC+YW24DDpK2HW+m4mneop3B+rT33QZ8wU6x+8bfCzNf0eb+OHcjPpkaMUPb6omcGQd0C4FtTrC71yHzgDQUDeIGtigjsqvHdhH1SI1xusHNyt5NL1YLIKC3PcQiN36ZEnZweJ0wHXHoYaVpdqICVid2Q348/TvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476878; c=relaxed/simple;
	bh=bQYAxj7VPIAiqqMQ+2d7ob/wNAnPZK6uH4SCreGn/Yo=;
	h=Date:To:From:Subject:Message-Id; b=P5/qh+7y3reU7uFagpIbWSkrDq5nowNmL/4Lqz99wBKVAVAwPSmolpHIVl+0Hdi2+giQCsn1Ee5yb0bOUHiV1ttQqnV6Le2TXHk0oMfFNnxkoaWBkrTzcSe/n5SwmKYt1Mf4/KGGDMhllR2+kx0+j/VtDnZYP8rzPA6cahV0+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhhP5yYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhhP5yYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E7C4CEE7;
	Tue, 14 Oct 2025 21:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760476878;
	bh=bQYAxj7VPIAiqqMQ+2d7ob/wNAnPZK6uH4SCreGn/Yo=;
	h=Date:To:From:Subject:From;
	b=hhhP5yYOFtStVFZ+pQ9qko7659zz1tMKWuV8dLaENnT/5778oxldj+FX1Pb40FEiu
	 h1FY7BCnVGZbSdaL8ZSCyAERoeG3keY9aTPBO6mntVwcD1Sl8wVhX3Hc0cY4oYMgWs
	 IbJyGQdPBggFpWOevM17ktHAWkCCfBNnSsuAYVXQ=
Date: Tue, 14 Oct 2025 14:21:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-list_add_tail-call-on-damon_call.patch added to mm-hotfixes-unstable branch
Message-Id: <20251014212118.426E7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix list_add_tail() call on damon_call()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-list_add_tail-call-on-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-list_add_tail-call-on-damon_call.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix list_add_tail() call on damon_call()
Date: Tue, 14 Oct 2025 13:59:36 -0700

Each damon_ctx maintains callback requests using a linked list
(damon_ctx->call_controls).  When a new callback request is received via
damon_call(), the new request should be added to the list.  However, the
function is making a mistake at list_add_tail() invocation: putting the
new item to add and the list head to add it before, in the opposite order.
Because of the linked list manipulation implementation, the new request
can still be reached from the context's list head.  But the list items
that were added before the new request are dropped from the list.

As a result, the callbacks are unexpectedly not invocated.  Worse yet, if
the dropped callback requests were dynamically allocated, the memory is
leaked.  Actually DAMON sysfs interface is using a dynamically allocated
repeat-mode callback request for automatic essential stats update.  And
because the online DAMON parameters commit is using a non-repeat-mode
callback request, the issue can easily be reproduced, like below.

    # damo start --damos_action stat --refresh_stat 1s
    # damo tune --damos_action stat --refresh_stat 1s

The first command dynamically allocates the repeat-mode callback request
for automatic essential stat update.  Users can see the essential stats
are automatically updated for every second, using the sysfs interface.

The second command calls damon_commit() with a new callback request that
was made for the commit.  As a result, the previously added repeat-mode
callback request is dropped from the list.  The automatic stats refresh
stops working, and the memory for the repeat-mode callback request is
leaked.  It can be confirmed using kmemleak.

Fix the mistake on the list_add_tail() call.

Link: https://lkml.kernel.org/r/20251014205939.1206-1-sj@kernel.org
Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-list_add_tail-call-on-damon_call
+++ a/mm/damon/core.c
@@ -1450,7 +1450,7 @@ int damon_call(struct damon_ctx *ctx, st
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&ctx->call_controls, &control->list);
+	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch
mm-damon-sysfs-dealloc-commit-test-ctx-always.patch
mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

