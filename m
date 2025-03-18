Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44B41D6DB5
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274599; cv=none; b=LkEU9z2cyYtVPoWw+BsIP7SsmEvPOtlkzwq1O+osLR9uY/puVyw7VQfJBMt0h+4pwdvKlg24fGQfZ8l3i8BqsUdoIgVpSNlqnNM/vmaxjA81STTHv6GZQZWZR9S12vuhojFVo5Fas6rDulicIT6rWuzw1jFE3P3w5qH3+NVTLTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274599; c=relaxed/simple;
	bh=XxPpErhI4dPQ89oj5gIBr2YPnhtQT+MyU3tYkXZRDFk=;
	h=Date:To:From:Subject:Message-Id; b=RCf+aNeJKhauUJvexqFTUCqR8N8SX7o3wlWeZ8/I65iG85NBAlZI9zvl1CKrWjAs0PjNvoph5AQQXwS0uxrxDRHazx7mB9PKtYLYlP19GM82Q9qm9E/S3js95HRSt1ge6IAPEtUCx9Mcmk1FTeaOXs0KAf9CvWWh0ItF9PYyGrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sAdrNE6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sAdrNE6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A655C4CEEA;
	Tue, 18 Mar 2025 05:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274599;
	bh=XxPpErhI4dPQ89oj5gIBr2YPnhtQT+MyU3tYkXZRDFk=;
	h=Date:To:From:Subject:From;
	b=sAdrNE6m4VUrfd2TRk8fzZ2BCuBAyRcrdkSeU0TOeITAM+aOfFV8JDuTBTRMAgjiQ
	 +LpwOC4mttbiFr37SZLaiKH/QzL0DKIq4vCnHVLQhthZ2J7OgT+2SuCz43zauwrO/J
	 WU7n9npCE5p+RthKbYhVtQWp9TimCaOiQKXVz5EU=
Date: Mon, 17 Mar 2025 22:09:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch removed from -mm tree
Message-Id: <20250318050959.7A655C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request_callback() and its callers
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request_callback() and its callers
Date: Thu, 6 Mar 2025 09:59:01 -0800

damon_sysfs_cmd_request_callback() is the damon_callback hook functions
that were used to handle user requests that need to read and/or write
DAMON internal data.  All the usages are now updated to use damon_call()
or damos_walk(), though.  Remove it and its callers.

Link: https://lkml.kernel.org/r/20250306175908.66300-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   62 ---------------------------------------------
 1 file changed, 62 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers
+++ a/mm/damon/sysfs.c
@@ -1529,65 +1529,6 @@ static int damon_sysfs_upd_tuned_interva
 	return 0;
 }
 
-/*
- * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
- * @c:		The DAMON context of the callback.
- * @active:	Whether @c is not deactivated due to watermarks.
- * @after_aggr:	Whether this is called from after_aggregation() callback.
- *
- * This function is periodically called back from the kdamond thread for @c.
- * Then, it checks if there is a waiting DAMON sysfs request and handles it.
- */
-static int damon_sysfs_cmd_request_callback(struct damon_ctx *c, bool active,
-		bool after_aggregation)
-{
-	struct damon_sysfs_kdamond *kdamond;
-	int err = 0;
-
-	/* avoid deadlock due to concurrent state_store('off') */
-	if (!mutex_trylock(&damon_sysfs_lock))
-		return 0;
-	kdamond = damon_sysfs_cmd_request.kdamond;
-	if (!kdamond || kdamond->damon_ctx != c)
-		goto out;
-	switch (damon_sysfs_cmd_request.cmd) {
-	default:
-		break;
-	}
-	/* Mark the request as invalid now. */
-	damon_sysfs_cmd_request.kdamond = NULL;
-out:
-	mutex_unlock(&damon_sysfs_lock);
-	return err;
-}
-
-static int damon_sysfs_after_wmarks_check(struct damon_ctx *c)
-{
-	/*
-	 * after_wmarks_check() is called back while the context is deactivated
-	 * by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, false, false);
-}
-
-static int damon_sysfs_after_sampling(struct damon_ctx *c)
-{
-	/*
-	 * after_sampling() is called back only while the context is not
-	 * deactivated by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, true, false);
-}
-
-static int damon_sysfs_after_aggregation(struct damon_ctx *c)
-{
-	/*
-	 * after_aggregation() is called back only while the context is not
-	 * deactivated by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, true, true);
-}
-
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx)
 {
@@ -1603,9 +1544,6 @@ static struct damon_ctx *damon_sysfs_bui
 		return ERR_PTR(err);
 	}
 
-	ctx->callback.after_wmarks_check = damon_sysfs_after_wmarks_check;
-	ctx->callback.after_sampling = damon_sysfs_after_sampling;
-	ctx->callback.after_aggregation = damon_sysfs_after_aggregation;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


