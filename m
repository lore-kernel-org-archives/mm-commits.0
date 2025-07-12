Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507B225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357994; cv=none; b=JTHxwdrnt4XiJus8MVCjdPTbWaGKN1C4uwptn9YxMyoI7UpyI7SJJpDQx6lDYnqKuaA5sDiF9C6Ch7VOwQHvHMbt37MPgPOePqFxl02beX5WhR5AhEx1I7BTvZkCaYpfGvt/0oh/G2KbrlRSYdzkyGoDwSGxFz+JYoMmT6fP0nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357994; c=relaxed/simple;
	bh=whpr9IaK/io/+D90yjIyICkxZT3OwZcfZ+g/klrr8Kc=;
	h=Date:To:From:Subject:Message-Id; b=V4hxcrPGg+Pb7It9P1TPM2yZCQwV3Nzm6/ddhzzlGNGtfrDwAAkRUBVk9whQPXlDhEtCRR13A5zXdDorppSuCYAnCyCVPEH96Wf+B5gI1JF2TzHmtO4K/EaDBYCuk8V+YEWb/vZpV37GsalhBryvycbK0+YRqKkuk1KpYoFyMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swmGNE2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swmGNE2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBAFC4CEEF;
	Sat, 12 Jul 2025 22:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357993;
	bh=whpr9IaK/io/+D90yjIyICkxZT3OwZcfZ+g/klrr8Kc=;
	h=Date:To:From:Subject:From;
	b=swmGNE2S2bTFWUQdEYJ3TjbnOB4I+XK6xTr4gu+zr+Qs1N+dXO4e+LwkNnkrE1q+3
	 JCoUhIcXzZPsB5Q2FlN5eq6FwNHGVBEpe7mAhbc4XcuRPakl33EBUnWxW5p64Xb3uH
	 Ehkx0dJfsAcWQuXLoYG/06qfcZn/E5wlGmzswtEo=
Date: Sat, 12 Jul 2025 15:06:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-cleanup_target-ops-callback.patch added to mm-new branch
Message-Id: <20250712220633.CCBAFC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add cleanup_target() ops callback
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-cleanup_target-ops-callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-cleanup_target-ops-callback.patch

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
Subject: mm/damon/core: add cleanup_target() ops callback
Date: Sat, 12 Jul 2025 12:50:11 -0700

Some DAMON operation sets may need additional cleanup per target.  For
example, [f]vaddr need to put pids of each target.  Each user and core
logic is doing that redundantly.  Add another DAMON ops callback that will
be used for doing such cleanups in operations set layer.

Link: https://lkml.kernel.org/r/20250712195016.151108-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h        |    4 +++-
 mm/damon/core.c              |   12 ++++++++----
 mm/damon/sysfs.c             |    4 ++--
 mm/damon/tests/core-kunit.h  |    4 ++--
 mm/damon/tests/vaddr-kunit.h |    2 +-
 5 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-cleanup_target-ops-callback
+++ a/include/linux/damon.h
@@ -608,6 +608,7 @@ enum damon_ops_id {
  * filters (&struct damos_filter) that handled by itself.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
+ * @cleanup_target is called before the target will be deallocated.
  * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
@@ -623,6 +624,7 @@ struct damon_operations {
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
+	void (*cleanup_target)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
 
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

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

