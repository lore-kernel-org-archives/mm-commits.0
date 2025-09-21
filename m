Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FF82C15B0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490023; cv=none; b=evwjhZAVXWthSqPYBiAn/ODR49NOGjTKJsWodMONp5xyxjwwGM/cJnRKyrK/YRfOuhL1cLhY75lXLMKbox/hdEu6Y46wP1gpQi8bxu57E8SYusAbIRULQH7wCP1rwVtnJ/UzMFSEXAI9McXvwmNIlOjvQUePrAAnazYRFlB+sJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490023; c=relaxed/simple;
	bh=8pEVLwe4mcerY7VhqLHnpzRtkh88fK+2221rpI1sGuQ=;
	h=Date:To:From:Subject:Message-Id; b=Gy9OCdxH4+AnDtjTtrxqa9cTv/0P2zfIaLLJ1iwb/SMRVeSg8wSseji994gUly2kX5iv3daFjdNga5omZHFtdFaJeElSf7uUF9Sy8dacNEx3QiXIJluerjohULIT9uQXzEKao2iymxS1z8pf/2hNt8thIh1KGoe5QEkIT5CEuls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIDgd5Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIDgd5Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D221C4CEE7;
	Sun, 21 Sep 2025 21:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490023;
	bh=8pEVLwe4mcerY7VhqLHnpzRtkh88fK+2221rpI1sGuQ=;
	h=Date:To:From:Subject:From;
	b=JIDgd5Mz8xh73z2++niFN5mpdurLNjIFcM35VkUbGj4yTtvuRdupv/iA8AUlOwW8E
	 iMyuBokfq0KNa0mrzNblBWZ2mPAyHhr9vyb0jkzY+K+48BzgIZzbgJZODkjR9D+CiL
	 M5h1zyUd0JZzzh41HDJkwFku+wSpfktsTsGyzOTs=
Date: Sun, 21 Sep 2025 14:27:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212703.8D221C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:07 -0700

DAMON_RECLAIM is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_initialized
+++ a/mm/damon/reclaim.c
@@ -349,7 +349,7 @@ static int damon_reclaim_enabled_store(c
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
-	if (!ctx)
+	if (!damon_initialized())
 		goto set_param_out;
 
 	err = damon_reclaim_turn(enable);
@@ -372,8 +372,13 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_reclaim_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err;
 
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 	if (err)
 		goto out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

