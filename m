Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF7F22332E
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962053; cv=none; b=TE2okvBba0vlXNVYMR9W/fRLpwZxTnJcdtqMO3uz/51klJqN8u3rTx1lP+HN/o6eTzNIASKi6NVO4K2bWkRff5yJkFXQyeUwuB7YEiQHLxZs4JyOB1HQ3+DQhHNcwB58lHMbayMEyPiqz40DW1gX49I2EpNra80l4AmS33sqbEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962053; c=relaxed/simple;
	bh=mMKDdyxTPW7E3RAFL+XdW0KKCvWn/tudPb8LCrF3qL8=;
	h=Date:To:From:Subject:Message-Id; b=fsgmAj0CHT9tboqv7nKA7x6kxJjX3an9ppZaBDO0XRIfCNlShO3f+6n6xkIq9NCGcneoipG0cys3brzyU/GD0hY0D+Gbs8jX+P4KPm2Q6MeCwT4tN3COx8yQL6lJU8sQaD1SBJgvh+e5Wo8diC952/3h5WC3+0Chj02Prv3YcnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NrbvLyld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NrbvLyld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EECC4CEED;
	Tue, 12 Aug 2025 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962052;
	bh=mMKDdyxTPW7E3RAFL+XdW0KKCvWn/tudPb8LCrF3qL8=;
	h=Date:To:From:Subject:From;
	b=NrbvLyldvu+rD2NrqG2R9CKlZW7tpTw4DH3t9Gw94kJEQnBS7tMyaOx6dkMOHkuBU
	 UOC09+IuqbuVZBNIDVEzk7mP68GjHS5qr98RmHlss5w8w40THue0plR0iWPA956mGE
	 PwIiMF9Wf5vgrVkPCqSCXPgg2c6tC9yfcXHxL0TY=
Date: Mon, 11 Aug 2025 18:27:32 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-update-expired-description-of-damos_action.patch added to mm-unstable branch
Message-Id: <20250812012732.B8EECC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: update expired description of damos_action
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-update-expired-description-of-damos_action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-update-expired-description-of-damos_action.patch

This patch will later appear in the mm-unstable branch at
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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon: update expired description of damos_action
Date: Tue, 5 Aug 2025 21:39:40 +0900

Nowadays, damos operation actions support a greater operation set.  But
comments (also, generated documentation) weren't updated.  So fix the
comments with current support status.

Link: https://lkml.kernel.org/r/20250805123940.13691-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-expired-description-of-damos_action
+++ a/include/linux/damon.h
@@ -110,7 +110,7 @@ struct damon_target {
  *
  * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
  * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
- * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
+ * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
@@ -121,10 +121,10 @@ struct damon_target {
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  *
  * The support of each action is up to running &struct damon_operations.
- * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
- * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
- * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
- * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
+ * Refer to 'Operation Action' section of Documentation/mm/damon/design.rst for
+ * status of the supports.
+ *
+ * Note that DAMOS_PAGEOUT doesn't trigger demotions.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-update-expired-description-of-damos_action.patch

