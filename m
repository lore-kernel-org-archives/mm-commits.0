Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CDA23353A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837168; cv=none; b=VASe/Ztd/h7qc3MhDFG50UW4p12xdAKXfqS4tKqGp02WKui295+uAkXI8Apym4oo/WO1fbGJK/E1WDKowiWC/htfrmRbDsTHxPvSzylJmp7Shm2jiGLY35cJLlK+VsbSQU/9MtqTYNG4kqC1ut03CIvAmiN+4hLGtPt+BXrC8c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837168; c=relaxed/simple;
	bh=8i3vYCfTuBg72aPWOyLzusX/NfbslLwhudWnOzmwAZ4=;
	h=Date:To:From:Subject:Message-Id; b=ljDLe3FebmwSvW8JnOE92Y1A0/hAxqJZ//Qmbi1rW6ngyW9QLlaACDBbdJVY1WzqCwIruF0LQv44IAAoeKGvOkXTcTsatQqLqmQYdB3nVGXUhkz+BVQ5wwzsl5MRM2iDd2rBy7Fey1fyat04HxLoEwARuB0/IaA88BDgK+GhBXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8SwZM67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8SwZM67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D340C4CEDD;
	Tue, 14 Jan 2025 06:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837168;
	bh=8i3vYCfTuBg72aPWOyLzusX/NfbslLwhudWnOzmwAZ4=;
	h=Date:To:From:Subject:From;
	b=B8SwZM67fgwx64KY5ZJo0yzgQXWfv7xWUZ9IWm1GUq3Jzz1NEqZzr1HaMgdBLk0aL
	 Q4sqQkpRa5n6r6oCHpQeNuNoG1mxtj3r6xRE8XfReQ2YEE5KpkVR/ZPXPykrKPFXF/
	 44P0p3DLe55xhgK12q8SZrKltKVJGC1GiOGdVJl4=
Date: Mon, 13 Jan 2025 22:46:08 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch removed from -mm tree
Message-Id: <20250114064608.7D340C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: pass per-region filter-passed bytes to damos_walk_control->walk_fn()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

