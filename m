Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425C21519A6
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976938; cv=none; b=HUdnD695lvBzlb8r+O7Q+HJlJwXMVizQcqV5go5eoMl0W4mTBEHpZhaSx0y6jZbo2kciUbtvG7KCT9lQP/NasbCe3n2M2UokNIsJUFnXr7ihzJlqpm3uQuts86t2QUTcqt8U45FtSAULKurGyjlqevX3RVYGynhEYUz8oowFRqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976938; c=relaxed/simple;
	bh=dnAvNo/eT6Ve12P0CrQgMivxpvaRA6w/nULt+px23KY=;
	h=Date:To:From:Subject:Message-Id; b=pFK8sZUcYMzcBNSXAnEPAk22D0FQllUo8QLY6MaNRaIdWPT8wDqdd/rix+vxTpIyg6CVhFRt81UkwrgHZqzUFJcOKfJvWDw3gXmkT3UEHyMbrV6Ip+bG1LX/c0eEWaSq9YNfU9ZuJdNsa2tGogNE/5Zv+LcJiaEtN8nENeos9Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dWth+RcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dWth+RcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18577C4CEE3;
	Sun, 20 Jul 2025 02:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976938;
	bh=dnAvNo/eT6Ve12P0CrQgMivxpvaRA6w/nULt+px23KY=;
	h=Date:To:From:Subject:From;
	b=dWth+RcTiIW99wLhYndaRcxzdPtbs/hMbMUxVCCnr50EJrRiWS8u96v2b9PyxmeEn
	 dvwN90JFtDDq9cl3CeItpCHiL2IFNZ1EHA71H0jaaz8V4DC3ocQBf58RzI99kh9Rfq
	 ViqMCVYx15Eqowe0kjgWS3bmVnmcZXr4HkxtCgkE=
Date: Sat, 19 Jul 2025 19:02:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-cleanup_target-ops-callback.patch removed from -mm tree
Message-Id: <20250720020218.18577C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add cleanup_target() ops callback
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-cleanup_target-ops-callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add cleanup_target() ops callback
Date: Sat, 12 Jul 2025 12:50:11 -0700

Some DAMON operation sets may need additional cleanup per target.  For
example, [f]vaddr need to put pids of each target.  Each user and core
logic is doing that redundantly.  Add another DAMON ops callback that will
be used for doing such cleanups in operations set layer.

[sj@kernel.org: add kernel-doc comment for damon_operations->cleanup_target]
  Link: https://lkml.kernel.org/r/20250715185239.89152-2-sj@kernel.org
[sj@kernel.org: remove damon_ctx->callback kernel-doc comment]
  Link: https://lkml.kernel.org/r/20250715185239.89152-3-sj@kernel.org
Link: https://lkml.kernel.org/r/20250712195016.151108-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h        |    6 ++++--
 mm/damon/core.c              |   12 ++++++++----
 mm/damon/sysfs.c             |    4 ++--
 mm/damon/tests/core-kunit.h  |    4 ++--
 mm/damon/tests/vaddr-kunit.h |    2 +-
 5 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-cleanup_target-ops-callback
+++ a/include/linux/damon.h
@@ -576,6 +576,7 @@ enum damon_ops_id {
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
+ * @cleanup_target:		Clean up each target before deallocation.
  * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
@@ -608,6 +609,7 @@ enum damon_ops_id {
  * filters (&struct damos_filter) that handled by itself.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
+ * @cleanup_target is called before the target will be deallocated.
  * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
@@ -623,6 +625,7 @@ struct damon_operations {
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
+	void (*cleanup_target)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
 
@@ -771,7 +774,6 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- * @callback:	Set of callbacks for monitoring events notifications.
  *
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
@@ -933,7 +935,7 @@ struct damon_target *damon_new_target(vo
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
 bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
-void damon_destroy_target(struct damon_target *t);
+void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
 
 struct damon_ctx *damon_new_ctx(void);
--- a/mm/damon/core.c~mm-damon-core-add-cleanup_target-ops-callback
+++ a/mm/damon/core.c
@@ -502,8 +502,12 @@ void damon_free_target(struct damon_targ
 	kfree(t);
 }
 
-void damon_destroy_target(struct damon_target *t)
+void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 {
+
+	if (ctx && ctx->ops.cleanup_target)
+		ctx->ops.cleanup_target(t);
+
 	damon_del_target(t);
 	damon_free_target(t);
 }
@@ -551,7 +555,7 @@ static void damon_destroy_targets(struct
 	struct damon_target *t, *next_t;
 
 	damon_for_each_target_safe(t, next_t, ctx)
-		damon_destroy_target(t);
+		damon_destroy_target(t, ctx);
 }
 
 void damon_destroy_ctx(struct damon_ctx *ctx)
@@ -1137,7 +1141,7 @@ static int damon_commit_targets(
 
 			if (damon_target_has_pid(dst))
 				put_pid(dst_target->pid);
-			damon_destroy_target(dst_target);
+			damon_destroy_target(dst_target, dst);
 			damon_for_each_scheme(s, dst) {
 				if (s->quota.charge_target_from == dst_target) {
 					s->quota.charge_target_from = NULL;
@@ -1156,7 +1160,7 @@ static int damon_commit_targets(
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src));
 		if (err) {
-			damon_destroy_target(new_target);
+			damon_destroy_target(new_target, NULL);
 			return err;
 		}
 		damon_add_target(dst, new_target);
--- a/mm/damon/sysfs.c~mm-damon-core-add-cleanup_target-ops-callback
+++ a/mm/damon/sysfs.c
@@ -1303,7 +1303,7 @@ static void damon_sysfs_destroy_targets(
 	damon_for_each_target_safe(t, next, ctx) {
 		if (has_pid)
 			put_pid(t->pid);
-		damon_destroy_target(t);
+		damon_destroy_target(t, ctx);
 	}
 }
 
@@ -1389,7 +1389,7 @@ static void damon_sysfs_before_terminate
 
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid(t->pid);
-		damon_destroy_target(t);
+		damon_destroy_target(t, ctx);
 	}
 }
 
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-add-cleanup_target-ops-callback
+++ a/mm/damon/tests/core-kunit.h
@@ -58,7 +58,7 @@ static void damon_test_target(struct kun
 	damon_add_target(c, t);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(c));
 
-	damon_destroy_target(t);
+	damon_destroy_target(t, c);
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 
 	damon_destroy_ctx(c);
@@ -310,7 +310,7 @@ static void damon_test_set_regions(struc
 		KUNIT_EXPECT_EQ(test, r->ar.start, expects[expect_idx++]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expects[expect_idx++]);
 	}
-	damon_destroy_target(t);
+	damon_destroy_target(t, NULL);
 }
 
 static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-core-add-cleanup_target-ops-callback
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -149,7 +149,7 @@ static void damon_do_test_apply_three_re
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
-	damon_destroy_target(t);
+	damon_destroy_target(t, NULL);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

