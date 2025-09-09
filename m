Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F97263E;
	Tue,  9 Sep 2025 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400351; cv=none; b=L0gQC4kP3OXninIRlXvcBif3hPHSzyfr5RBatcFeE18Tk0m6BEd2eptBQS9zv0oCjTzXduD5hKwiQHQioqhhnvCy86dHg+SDTSscY+knGtkvgpECmyJOk0CfSz+RGv2dqcXsYda7YjYqssPflNCvNUqyjqgKeCMO4ae8UU7lix0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400351; c=relaxed/simple;
	bh=pdbDf0pdQcQsFH4vU2nKhQ0xvN63zntAP19irykXRGg=;
	h=Date:To:From:Subject:Message-Id; b=dJ24+CGxwoGC28b9Y6ZL9E4IDaoc+hGtRd1yHEUaD9a4BB+WO0a1VdLqdM3iI5lfyYqyLwi3/Qa5u5PzhKNLBpBmnF+QpgiMnJGRd6IuCDwTfM8p3VvIumAmw5amcEfeRJFNT5X0N1dnxsjiH+ZKatppXrjCHnQpY+HM561rkXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1g/RIuqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1g/RIuqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C465C4CEF8;
	Tue,  9 Sep 2025 06:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400350;
	bh=pdbDf0pdQcQsFH4vU2nKhQ0xvN63zntAP19irykXRGg=;
	h=Date:To:From:Subject:From;
	b=1g/RIuqfZILiDyH3BHV3tm92lxbuxabATiojd1vqidA/mWd8UW8HK0UjakSVyw8Sq
	 KVQorMPrOICXHH05viLUC/x1ii88za8y6wdIjpZdnJPl+1hmOYrafhHu30Ly2OxoCK
	 x7nK6nTh2WNaW4rhx+XbUJikIVeR/eQ+WK25j/hg=
Date: Mon, 08 Sep 2025 23:45:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,disclosure@aisle.com,stanislav.fort@aisle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-fix-use-after-free-in-state_show.patch removed from -mm tree
Message-Id: <20250909064550.9C465C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: fix use-after-free in state_show()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-fix-use-after-free-in-state_show.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislav Fort <stanislav.fort@aisle.com>
Subject: mm/damon/sysfs: fix use-after-free in state_show()
Date: Fri, 5 Sep 2025 13:10:46 +0300

state_show() reads kdamond->damon_ctx without holding damon_sysfs_lock. 
This allows a use-after-free race:

CPU 0                         CPU 1
-----                         -----
state_show()                  damon_sysfs_turn_damon_on()
ctx = kdamond->damon_ctx;     mutex_lock(&damon_sysfs_lock);
                              damon_destroy_ctx(kdamond->damon_ctx);
                              kdamond->damon_ctx = NULL;
                              mutex_unlock(&damon_sysfs_lock);
damon_is_running(ctx);        /* ctx is freed */
mutex_lock(&ctx->kdamond_lock); /* UAF */

(The race can also occur with damon_sysfs_kdamonds_rm_dirs() and
damon_sysfs_kdamond_release(), which free or replace the context under
damon_sysfs_lock.)

Fix by taking damon_sysfs_lock before dereferencing the context, mirroring
the locking used in pid_show().

The bug has existed since state_show() first accessed kdamond->damon_ctx.

Link: https://lkml.kernel.org/r/20250905101046.2288-1-disclosure@aisle.com
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
Reported-by: Stanislav Fort <disclosure@aisle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-fix-use-after-free-in-state_show
+++ a/mm/damon/sysfs.c
@@ -1260,14 +1260,18 @@ static ssize_t state_show(struct kobject
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	bool running;
+	struct damon_ctx *ctx;
+	bool running = false;
 
-	if (!ctx)
-		running = false;
-	else
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+
+	ctx = kdamond->damon_ctx;
+	if (ctx)
 		running = damon_is_running(ctx);
 
+	mutex_unlock(&damon_sysfs_lock);
+
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
_

Patches currently in -mm which might be from stanislav.fort@aisle.com are

mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch

