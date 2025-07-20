Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B1208CA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976872; cv=none; b=I4+MlD8iKut3Rbx1dEaeeZEB7li/tFaDQTI+f9JS19qcaTyJdcl8dx/A63oLSEyzAGsC8hV8zTBY6KuizwEvDyCCWtaVncgHRKDKMsEQ9LSGKV99f6eO01+6sJoV54tDvZ2PPMFpCf7V4vMmBGKIT9tLwHJ/79vi9ocZGtfBlu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976872; c=relaxed/simple;
	bh=XcdkTOtXEwjFRXXhbXVEIdiq43H7GjD+vIbP4ipNkgc=;
	h=Date:To:From:Subject:Message-Id; b=kFEGDYd0KThEGM3FSVAVJiGPNpJPo0dEk4Sx23nlriSPS4p07fh3kCIcLPn17zS0rdR1oienzoN104wNTsrfEvngq+OLXg5dZpBWwLhUeOK0B4nV8vSJ0jUhSShojLl/of03roPoiWl9naiT1mGuMQA7473ztnz5bdxjgfe2R1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXZxyutq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXZxyutq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E65C4CEE3;
	Sun, 20 Jul 2025 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976872;
	bh=XcdkTOtXEwjFRXXhbXVEIdiq43H7GjD+vIbP4ipNkgc=;
	h=Date:To:From:Subject:From;
	b=hXZxyutq8MrmVPdWedpyjfCx9MZx+aT5hl09YEBh8WLDMWbQemmOGNr+A9QHqmUrb
	 nKTC+w6fs/JCrOgU3x8Sc2qEC4xsmpkP5lWpww83T8mZfz11i0omJ4pRVaLe00X9eh
	 GBGG3KPAxNDB49IGcgPjVNPEOimAfiTdAnIv7y0o=
Date: Sat, 19 Jul 2025 19:01:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch removed from -mm tree
Message-Id: <20250720020112.21E65C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: don't hold kdamond_lock in before_terminate()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: don't hold kdamond_lock in before_terminate()
Date: Sat, 5 Jul 2025 10:49:59 -0700

damon_sysfs_before_terminate() is a DAMON callback that is executed from
the kdamond's context.  Hence it is safe to access DAMON context internal
data.  But the function is unnecessarily holding kdamond_lock of the
context.  It is just unnecessary.  Remove the locking code.

Link: https://lkml.kernel.org/r/20250705175000.56259-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate
+++ a/mm/damon/sysfs.c
@@ -1387,12 +1387,10 @@ static void damon_sysfs_before_terminate
 	if (!damon_target_has_pid(ctx))
 		return;
 
-	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid(t->pid);
 		damon_destroy_target(t);
 	}
-	mutex_unlock(&ctx->kdamond_lock);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

