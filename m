Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812FE158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739393; cv=none; b=AOFHaztse4DPdiPrcCE1v6Uly3YMeTboE41itUK9QsSsP7UwuweOQtNvi0/R7R4CjTiYqzz6TSuotCNfm/jI3OpXjt+yaMcvYjHq/6DaVLW2CGiSUwYiUROATp1Y3XGGO8zUadZ+roarxr4Ys1/KB5pCNNaP8+kuakiFOmiZz9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739393; c=relaxed/simple;
	bh=QsLU5MIr0lWDfQAWjt8+EC8lg+KSvoPd6TxUxGbyuNE=;
	h=Date:To:From:Subject:Message-Id; b=CTfMu6Xj118u0GwdAOB1OLIAL5CCE9gJEytfA8iUYUl+hi7QcPkiOqWQ71xKh3YstWQ9DBZuunQDQia+2wKnpSbH89BDzRTZ5wWQX8FgJ8x5gzrlEbfr923yq+daYiZv+BhoFPZW/xrC8NSw3kBa3So4xEjrEkxkJldbIbSSCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MsY2k22S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MsY2k22S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F81C3277B;
	Tue, 18 Jun 2024 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739392;
	bh=QsLU5MIr0lWDfQAWjt8+EC8lg+KSvoPd6TxUxGbyuNE=;
	h=Date:To:From:Subject:From;
	b=MsY2k22Spqh06+N6rEoCbJ+c/p3cPAMHUbfKqqRmzLHL7X6N195Gyy7+PIlNs9xMe
	 A/8ROiIoXqjeBD9UKy3tZM7LrbkJnpDsg0sjz/pV1COSkTtXZ2EIRU//DpiffQd5zN
	 z9WQGSksck1FgtwHUVjeD3l/WZMsUA+Z/ZtI04bE=
Date: Tue, 18 Jun 2024 12:36:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_commit_ctx.patch added to mm-unstable branch
Message-Id: <20240618193631.E5F81C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use damon_commit_ctx()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_commit_ctx.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use damon_commit_ctx()
Date: Tue, 18 Jun 2024 11:18:00 -0700

DAMON_SYSFS manually manipulates DAMON context structs for online
parameters update.  Since the struct contains not only input parameters
but also internal status and operation results, it is not that simple. 
Indeed, we found and fixed a few bugs in the code.  Now DAMON core layer
provides a function for the usage, namely damon_commit_ctx().  Replace the
manual manipulation logic with the function.  The core layer function
could have its own bugs, but this change removes a source of bugs.

Link: https://lkml.kernel.org/r/20240618181809.82078-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_commit_ctx
+++ a/mm/damon/sysfs.c
@@ -1345,6 +1345,9 @@ static int damon_sysfs_apply_inputs(stru
 	return damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
 }
 
+static struct damon_ctx *damon_sysfs_build_ctx(
+		struct damon_sysfs_context *sys_ctx);
+
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -1353,14 +1356,22 @@ static int damon_sysfs_apply_inputs(stru
  */
 static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
 {
+	struct damon_ctx *param_ctx;
+	int err;
+
 	if (!damon_sysfs_kdamond_running(kdamond))
 		return -EINVAL;
 	/* TODO: Support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
 
-	return damon_sysfs_apply_inputs(kdamond->damon_ctx,
-			kdamond->contexts->contexts_arr[0]);
+	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	if (IS_ERR(param_ctx))
+		return PTR_ERR(param_ctx);
+	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
+	damon_sysfs_destroy_targets(param_ctx);
+	damon_destroy_ctx(param_ctx);
+	return err;
 }
 
 static int damon_sysfs_commit_schemes_quota_goals(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

