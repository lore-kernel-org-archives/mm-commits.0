Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBF5748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291737; cv=none; b=SxjXJSVhWM2GeJLwqEON8pfFpDKq0BH2A/iEA52MjyZC2AdWEQCHAhLK8/H7orwdQlrm1n4WKnmFPG9j/KZED7isg+kDRCr8UKG1z8NuHrnNu+KRKw+6dhIR+/PPUKgFkzhs2Pheds4F5ZYpaMpVDnadYRqvIcsUxdqyMQd7e9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291737; c=relaxed/simple;
	bh=Je5GGL56erQfs3XHL264JiuFiADUsm4Hgz1jyMkNHVg=;
	h=Date:To:From:Subject:Message-Id; b=H9+yxOoRkH3pZxInGzgDQ7h35f9Bzs+liP44qE0NtW+c2FWbtR4Ls6ixmcKG91wEZ70R7sxlituiKAe39JSU7v+4CebmvmeSjCTMZK2ur6ODJg6lIcnQ1ycrrCnFRV9CvTbESXqJvTH4BZixqjBOz2ee+VVxX/mY8OizTve3zjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xh7E766Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xh7E766Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A88BC32789;
	Tue, 25 Jun 2024 05:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291736;
	bh=Je5GGL56erQfs3XHL264JiuFiADUsm4Hgz1jyMkNHVg=;
	h=Date:To:From:Subject:From;
	b=xh7E766Y1cEBEBTHXpDSAByUYEegrS2Yd4ud5gVV5/ruXUPZArdQY2B1RavTv8KPx
	 0OfQozsZQeCXqcBZ21ulGIaDvfJRJZS0cp9uZGpKvz8P+X3JVXQ0iCLsZ8Vr9Z5sHN
	 zWBpbWg1d2mrTfJ/J+BrEek9evRn5ryskz7FvTnw=
Date: Mon, 24 Jun 2024 22:02:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon_commit_ctx.patch removed from -mm tree
Message-Id: <20240625050216.8A88BC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damon_commit_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon_commit_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

