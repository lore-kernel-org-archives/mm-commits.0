Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0583A4F3B
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218360; cv=none; b=RCP0vVo9ZPZ0tyNoQ7arAUzYJxgNrQsomMvudrH5RKRzWfDb59AE8bUHaR0uqRnicor0WKsYm2t6VFi1RdFkFipbQauftqqe1XXWILiGO/GyOjq/TeB9Ul44gFTA6bhJaJWLy8zllSnH7aJBNpfNjgAQswXUSo3XRHEdR9F0Fdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218360; c=relaxed/simple;
	bh=Me3v0CGFbSdLRwQvTEhqctYRA3xi0P/4A/dHIl2o/EU=;
	h=Date:To:From:Subject:Message-Id; b=P7oNicKUaWK3q0dI/hjTSS5yANr0K7pDxQTRPm8YQ7AnXf/WW0oLrjinmVj6ObH3qi1WoQpSQ4U56jmePudDubk67XwHvfNiMQ/5zI0S6EPNM3dHgkUlk8S0Ao4eJNintdTUcjQEV1IC6QCISPCZoe1tu5aUQhNgi50QFXcHu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CjyEpg0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CjyEpg0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F111F000E9;
	Mon, 31 Aug 2026 23:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218359;
	bh=Cy32dkKL4sVbdsqrl4qSg51xtwUXmon/S7fOS5XTeag=;
	h=Date:To:From:Subject;
	b=CjyEpg0kdeWp+O+cVk1pdM2jOhlOYFJl8Ax2UFi1JLV4CZae4AC+Wwvq3VlTtWWb6
	 zpX4PqepA99Pezka4IRY3c7UcAQsjMZyTD4MStsrCcH4qtO8L5yGyePl3tLErkY0LQ
	 dLD2ICA94i93i3enDbMGJffq5lL0qp9s7T2WecKw=
Date: Mon, 31 Aug 2026 16:19:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-unused-damon_targets_empty.patch added to mm-new branch
Message-Id: <20260831231918.E8F111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove unused damon_targets_empty()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-unused-damon_targets_empty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-unused-damon_targets_empty.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm/damon/core: remove unused damon_targets_empty()
Date: Mon, 31 Aug 2026 07:57:21 -0700

Patch series "mm/damon/core: remove unused helper functions", v2.

Both damon_targets_empty() and damon_nr_running_ctxs() have had no in-tree
users since commit 5ec4333b1967 ("mm/damon: remove DAMON debugfs
interface") removed their remaining callers.

Remove the unused declarations and definitions.


This patch (of 2):

damon_targets_empty() has had no in-tree users since commit 5ec4333b1967
("mm/damon: remove DAMON debugfs interface") removed its last caller.

Remove the unused declaration and definition.

Link: https://lore.kernel.org/20260831145724.82387-1-sj@kernel.org
Link: https://lore.kernel.org/20260831145724.82387-2-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |    5 -----
 2 files changed, 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-unused-damon_targets_empty
+++ a/include/linux/damon.h
@@ -1055,7 +1055,6 @@ int damos_commit_quota_goals(struct damo
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
-bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
--- a/mm/damon/core.c~mm-damon-core-remove-unused-damon_targets_empty
+++ a/mm/damon/core.c
@@ -795,11 +795,6 @@ void damon_add_target(struct damon_ctx *
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
-bool damon_targets_empty(struct damon_ctx *ctx)
-{
-	return list_empty(&ctx->adaptive_targets);
-}
-
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
_

Patches currently in -mm which might be from hank20010209@gmail.com are

mm-damon-core-remove-unused-damon_targets_empty.patch
mm-damon-core-remove-unused-damon_nr_running_ctxs.patch

