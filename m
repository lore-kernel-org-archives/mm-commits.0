Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397F038DD8
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757997224; cv=none; b=fTtV9aGzqJ+E/VlU6yghZM1kUlhM7Xcyyp9ZOkaCje0WCQB1k8z7dyPyYObcKdL6r3X6ZQcDbaG5R3BRV+k8KoSG0uEvYFRAKmCnTyr7Y02Pt2WARTHEgndvz9Xb2wUQN2f3ZxNAq+oaKo3fRBWQq4OnKKeRK2c9l2qDGjZJRjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757997224; c=relaxed/simple;
	bh=8tZTDKJL+8IhZD4gpuS6RwGSM8g2iLxI7lET5P26eXk=;
	h=Date:To:From:Subject:Message-Id; b=AOYkG6eO/nTh/kyraCr93dmioGSQ7HLlYCnQInL+jCTKa2KsiJQ/CtJzQGY1ECsb2iFa7I6rBQ9irctNro3zwxcxrjd7ncYo3OaJPQZhhhhCjf0DNf4SC0NmSnmzoxT3QFKqLf4FSV76vyFN7pOqRZFIDgbcr8dTOOryTqjNfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uiahIQmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiahIQmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFF0C4CEEB;
	Tue, 16 Sep 2025 04:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997223;
	bh=8tZTDKJL+8IhZD4gpuS6RwGSM8g2iLxI7lET5P26eXk=;
	h=Date:To:From:Subject:From;
	b=uiahIQmzgVRAa5cA06CkhCJHiA6VEb3wV7YzGW4VDI1ea4IryHpTD5F0ACUfx1bra
	 9QQjz56G2LClW1slDkOkNF5vQGPwZA1ciALLpqxHldFBhhzdbs6bcwg57fNtlre6Yx
	 d9Nw7yQR1WRIEjEb46jPoxtA6+rIWqNX4wwYk9YE=
Date: Mon, 15 Sep 2025 21:33:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-damon_initialized.patch added to mm-new branch
Message-Id: <20250916043343.9DFF0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use damon_initialized()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-use-damon_initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-damon_initialized.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:08 -0700

DAMON_LRU_SORT is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_initialized
+++ a/mm/damon/lru_sort.c
@@ -345,7 +345,7 @@ static int damon_lru_sort_enabled_store(
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
-	if (!ctx)
+	if (!damon_initialized())
 		goto set_param_out;
 
 	err = damon_lru_sort_turn(enable);
@@ -368,8 +368,13 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_lru_sort_init(void)
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

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch
mm-damon-core-implement-damon_initialized-function.patch
mm-damon-stat-use-damon_initialized.patch
mm-damon-reclaim-use-damon_initialized.patch
mm-damon-lru_sort-use-damon_initialized.patch
samples-damon-wsse-use-damon_initialized.patch
samples-damon-prcl-use-damon_initialized.patch
samples-damon-mtier-use-damon_initialized.patch

