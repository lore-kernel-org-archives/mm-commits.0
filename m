Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F362E634
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215483; cv=none; b=U63Q4vzAKwSzSCy8Xp6yxepKRkJ3DG/FTi2IvK6mu7dFvKSbxfbiKu26uR6Je70t4n50a+37n+vJj7jGtE8AbFiQBDJBkwNIYnzSlxoMcMr1MfUFlg1l/yL67KQl/5DeWYBZPK+Z22hm6lgDVGyq5JBtPj9nIYqfpYteBAduw3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215483; c=relaxed/simple;
	bh=P87kacHMdPgd+6WYQ3Ytp+A9D2+hHkaJF1jvTkIE3c8=;
	h=Date:To:From:Subject:Message-Id; b=TYq+W9VowJ4nosvIPqOJYBQfynQxk/LVjjdBhiWyoVL7XPnn1pLH21qMRWwUbDWvAb3Boxt4oybsuWbI4FbHeNIrAL30MnIVuO1M1SztN2OsqmBXBzYA0nMIIeBJUYYAUT3Yjz4Q4VO0ZbrMu+HMq/M45tDDtI9OfBxzVb03wiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ym02ZUkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ym02ZUkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D1EC4CED2;
	Tue,  7 Jan 2025 02:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215483;
	bh=P87kacHMdPgd+6WYQ3Ytp+A9D2+hHkaJF1jvTkIE3c8=;
	h=Date:To:From:Subject:From;
	b=ym02ZUkdahYI7jw7FHDCvDB3ghIfrSwSpDKBuCs+wNnkdC1bRwMMBFMNfSTw6aUIl
	 tEdKJVW8g2Y2HbYi+6H+363b338s3+LXQ2Wd674a4pQUyxGNEJasSs/4B1hfL8vQPZ
	 bUzSJoWbCfDEcyoIJYXwomr2EBeDK7Aeni596kkU=
Date: Mon, 06 Jan 2025 18:04:42 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch added to mm-unstable branch
Message-Id: <20250107020443.17D1EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: pass per-region filter-passed bytes to damos_walk_control->walk_fn()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch

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
Subject: mm/damon/core: pass per-region filter-passed bytes to damos_walk_control->walk_fn()
Date: Mon, 6 Jan 2025 11:33:57 -0800

Total size of memory that passed DAMON operations set layer-handled DAMOS
filters per scheme is provided to DAMON core API and ABI (sysfs interface)
users.  Having it per-region in non-accumulated way can provide it in
finer granularity.  Provide it to damos_walk() core API users, by passing
the data to damos_walk_control->walk_fn().

Link: https://lkml.kernel.org/r/20250106193401.109161-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |    7 ++++---
 mm/damon/sysfs.c      |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn
+++ a/include/linux/damon.h
@@ -388,7 +388,7 @@ struct damos;
 struct damos_walk_control {
 	void (*walk_fn)(void *data, struct damon_ctx *ctx,
 			struct damon_target *t, struct damon_region *r,
-			struct damos *s);
+			struct damos *s, unsigned long sz_filter_passed);
 	void *data;
 /* private: internal use only */
 	/* informs if the kdamond finished handling of the walk request */
--- a/mm/damon/core.c~mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn
+++ a/mm/damon/core.c
@@ -1445,7 +1445,8 @@ static bool damos_filter_out(struct damo
  * installed by damos_walk() and not yet uninstalled, invoke it.
  */
 static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos *s)
+		struct damon_region *r, struct damos *s,
+		unsigned long sz_filter_passed)
 {
 	struct damos_walk_control *control;
 
@@ -1454,7 +1455,7 @@ static void damos_walk_call_walk(struct
 	mutex_unlock(&ctx->walk_control_lock);
 	if (!control)
 		return;
-	control->walk_fn(control->data, ctx, t, r, s);
+	control->walk_fn(control->data, ctx, t, r, s, sz_filter_passed);
 }
 
 /*
@@ -1574,7 +1575,7 @@ static void damos_apply_scheme(struct da
 			sz_applied = c->ops.apply_scheme(c, t, r, s,
 					&sz_ops_filter_passed);
 		}
-		damos_walk_call_walk(c, t, r, s);
+		damos_walk_call_walk(c, t, r, s, sz_ops_filter_passed);
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
--- a/mm/damon/sysfs.c~mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn
+++ a/mm/damon/sysfs.c
@@ -1454,7 +1454,7 @@ struct damon_sysfs_schemes_walk_data {
 /* populate the region directory */
 static void damon_sysfs_schemes_tried_regions_upd_one(void *data, struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
-		struct damos *s)
+		struct damos *s, unsigned long sz_filter_passed)
 {
 	struct damon_sysfs_schemes_walk_data *walk_data = data;
 	struct damon_sysfs_kdamond *sysfs_kdamond = walk_data->sysfs_kdamond;
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

