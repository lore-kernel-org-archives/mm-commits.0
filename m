Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395EF224893
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757997220; cv=none; b=CedfJEU5wKW+bhzEpoQP+iSa5RhIhR0wuPOOqOAcJ5MqUU0d1TOYM+QfLr9TkeFRZd3xvmCmy+9WbiiGacWj+of2Lc8LaC8q33Nin+LvYKFMZeg2VEqAhRaABvkVFncYwRq1asD7fmZ9zdMH4gYbc8KHkKV05DqJUqPdqtv4Unc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757997220; c=relaxed/simple;
	bh=2/YMC0n8HoniM3qVKFtKp49ObZoTXrTxjapHuQBbx/c=;
	h=Date:To:From:Subject:Message-Id; b=bDqYFBP3eRr7dY+9CbYP5zE3j6d/UP9gzBxxX4d0aPdawPdsCSfQl7aPcP4CKpVt0UgFlTYtebHOUelz+3hLdCIdu1buyNvjxTjv/24Wca0calTSQwgqwC8ZHlx/ksSjDVatoZOiVyXF4qg8J+32q6fjCv0cHTqkJeCYXRLVkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUJtz3kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUJtz3kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB9EC4CEEB;
	Tue, 16 Sep 2025 04:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997219;
	bh=2/YMC0n8HoniM3qVKFtKp49ObZoTXrTxjapHuQBbx/c=;
	h=Date:To:From:Subject:From;
	b=RUJtz3kWoSUH1cWYpC3u9hJ84ee7YrUKwT6By39l4aiN5FAgXbsRWo/koR/QNMTms
	 tZK6ShP8BzfJd7lbwE+cJy/9Y928HKPnRE1DMq+YTy+JCXA1t1/UnLVs0IchxXFvYj
	 W4uLE2sVHMIFv8miHYa2ttC8j0Wn7dRdOl5trNTg=
Date: Mon, 15 Sep 2025 21:33:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-use-damon_initialized.patch added to mm-new branch
Message-Id: <20250916043339.BAB9EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: use damon_initialized()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-use-damon_initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-use-damon_initialized.patch

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
Subject: mm/damon/stat: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:06 -0700

DAMON_STAT is assuming DAMON is ready to use in module_init time, and uses
its own hack to see if it is the time.  Use damon_initialized(), which is
a way for seeing if DAMON is ready to be used that is more reliable and
better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-damon_initialized
+++ a/mm/damon/stat.c
@@ -214,8 +214,6 @@ static void damon_stat_stop(void)
 	damon_destroy_ctx(damon_stat_context);
 }
 
-static bool damon_stat_init_called;
-
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -229,7 +227,7 @@ static int damon_stat_enabled_store(
 	if (is_enabled == enabled)
 		return 0;
 
-	if (!damon_stat_init_called)
+	if (!damon_initialized())
 		/*
 		 * probably called from command line parsing (parse_args()).
 		 * Cannot call damon_new_ctx().  Let damon_stat_init() handle.
@@ -250,12 +248,16 @@ static int __init damon_stat_init(void)
 {
 	int err = 0;
 
-	damon_stat_init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* probably set via command line */
 	if (enabled)
 		err = damon_stat_start();
 
+out:
 	if (err && enabled)
 		enabled = false;
 	return err;
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

