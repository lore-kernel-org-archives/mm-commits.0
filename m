Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A2414AD0D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976941; cv=none; b=sZebhXH8oxtFU/F8tADGMw8vt0CrC1zD4J+PEpnEC/ZPp7pwn0TGyvT2ko/ha22jzOcc6ZJdk4H9XH9CJoMZedEl8bNn/v5StF6NdHO+HCxAeBqLZi5vj0rIfBo+pft+ZOwUNQyqixNczp6xYmgLA5rygHtbJJ6j9n9n7Tf3iSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976941; c=relaxed/simple;
	bh=NqV1eF0UVLQ+jfXsV9DkQUHYcW53u4qQei0LaoGnGJc=;
	h=Date:To:From:Subject:Message-Id; b=Swwd1pG02/75vnX+T71A9SvU2WeKfKu1DvMHnoymU6yIXabCDJUvM9v9vUFkySioQOMzGxvgVUKyEXMMVmz3blW4XSdvc/He0gyTzSCRsf9+C7y1RqUEV+LnpuzOXqcUmr4U0UdRps+SQI2v2qtfd/gXMA9GhP6i28QebFR3yUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebWqHXg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebWqHXg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A5BC4CEE3;
	Sun, 20 Jul 2025 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976940;
	bh=NqV1eF0UVLQ+jfXsV9DkQUHYcW53u4qQei0LaoGnGJc=;
	h=Date:To:From:Subject:From;
	b=ebWqHXg6HOqrzYG89qVFaPj4PqPJsBb4TBUbAq9p13zQRLrE9RwbcYrsYYzGbHIUd
	 XgbmQrbUYoMmrXEmAgzOFXPvMGbJ4t5VDZ9Pdxs4KeXUvAWbFFRFZRqkyElw+9EOhZ
	 UTu7uPidvCTxXL5gz/hvyvD3mHRXVEpKk4Bl8PKk=
Date: Sat, 19 Jul 2025 19:02:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-put-pid-in-cleanup_target.patch removed from -mm tree
Message-Id: <20250720020220.C9A5BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: put pid in cleanup_target()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-put-pid-in-cleanup_target.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: put pid in cleanup_target()
Date: Sat, 12 Jul 2025 12:50:12 -0700

Implement cleanup_target() callback for [f]vaddr, which calls put_pid()
for each target that will be destroyed.  Also remove redundant put_pid()
calls in core, sysfs and sample modules, which were required to be done
redundantly due to the lack of such self cleanup in vaddr.

Link: https://lkml.kernel.org/r/20250712195016.151108-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c      |    2 --
 mm/damon/sysfs.c     |   10 ++--------
 mm/damon/vaddr.c     |    6 ++++++
 samples/damon/prcl.c |    2 --
 samples/damon/wsse.c |    2 --
 5 files changed, 8 insertions(+), 14 deletions(-)

--- a/mm/damon/core.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/core.c
@@ -1139,8 +1139,6 @@ static int damon_commit_targets(
 		} else {
 			struct damos *s;
 
-			if (damon_target_has_pid(dst))
-				put_pid(dst_target->pid);
 			damon_destroy_target(dst_target, dst);
 			damon_for_each_scheme(s, dst) {
 				if (s->quota.charge_target_from == dst_target) {
--- a/mm/damon/sysfs.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/sysfs.c
@@ -1298,13 +1298,9 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
-	bool has_pid = damon_target_has_pid(ctx);
 
-	damon_for_each_target_safe(t, next, ctx) {
-		if (has_pid)
-			put_pid(t->pid);
+	damon_for_each_target_safe(t, next, ctx)
 		damon_destroy_target(t, ctx);
-	}
 }
 
 static int damon_sysfs_set_regions(struct damon_target *t,
@@ -1387,10 +1383,8 @@ static void damon_sysfs_before_terminate
 	if (!damon_target_has_pid(ctx))
 		return;
 
-	damon_for_each_target_safe(t, next, ctx) {
-		put_pid(t->pid);
+	damon_for_each_target_safe(t, next, ctx)
 		damon_destroy_target(t, ctx);
-	}
 }
 
 /*
--- a/mm/damon/vaddr.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/vaddr.c
@@ -805,6 +805,11 @@ static bool damon_va_target_valid(struct
 	return false;
 }
 
+static void damon_va_cleanup_target(struct damon_target *t)
+{
+	put_pid(t->pid);
+}
+
 #ifndef CONFIG_ADVISE_SYSCALLS
 static unsigned long damos_madvise(struct damon_target *target,
 		struct damon_region *r, int behavior)
@@ -946,6 +951,7 @@ static int __init damon_va_initcall(void
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
 		.target_valid = damon_va_target_valid,
+		.cleanup_target = damon_va_cleanup_target,
 		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
--- a/samples/damon/prcl.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/samples/damon/prcl.c
@@ -120,8 +120,6 @@ static void damon_sample_prcl_stop(void)
 		damon_stop(&ctx, 1);
 		damon_destroy_ctx(ctx);
 	}
-	if (target_pidp)
-		put_pid(target_pidp);
 }
 
 static bool init_called;
--- a/samples/damon/wsse.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/samples/damon/wsse.c
@@ -100,8 +100,6 @@ static void damon_sample_wsse_stop(void)
 		damon_stop(&ctx, 1);
 		damon_destroy_ctx(ctx);
 	}
-	if (target_pidp)
-		put_pid(target_pidp);
 }
 
 static bool init_called;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

