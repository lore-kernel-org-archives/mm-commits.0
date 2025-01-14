Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11336243321
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837155; cv=none; b=ZNP+g95oX5FGyV/3QWIHCZLXSoq9tZ/pp3g0vVK3A3/3QppQj90vXOBNarQ1L4FrqKh0uRAjJY+EGbEhFgkyF1ZcwBPpK/9+BO3gDCwnLTmdkoIv2eGsXTJxL7RgOA/V9JI+wpuKPDkkq3Gl3hMV3Ai2azD1nsHFR4nNeuAH8yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837155; c=relaxed/simple;
	bh=hqWpMqImZG4ZHlECfyyDlRn7SvGGXVIyk7HiBx8UOkM=;
	h=Date:To:From:Subject:Message-Id; b=N/Wvy6e3UYBQdckYIKuZxiVPc8IvcyCq3iNcvVLUBu5lQTu0YkDMSQpJGMTTNuOq38cbrWqXvI/JbPe/OiHDpU/9QKhZRZkPGxsGMWVKI1p4ezk+ije5ZmP1fGDyh9QGpXTR8k6HxQg/ziAT6RBq/Xf7znGUv95aymxzrm5MnpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BiJGXBAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BiJGXBAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E014C4CEDD;
	Tue, 14 Jan 2025 06:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837154;
	bh=hqWpMqImZG4ZHlECfyyDlRn7SvGGXVIyk7HiBx8UOkM=;
	h=Date:To:From:Subject:From;
	b=BiJGXBAj9tia29yEnqp6eRt85XFI3Unegy5eI2EkZd1uM+SUqBNv8IyTapO1L5RnN
	 BwO2o7polAcORvs8cIaY7cGaKzOYPsdVUaGq/CfCCQNBEF6f/+p2pX5uXEQ94/1/Mt
	 WWpeUQ7WLAAqsIl4igWV3f/7+fu5vt8flYZc2u4c=
Date: Mon, 13 Jan 2025 22:45:54 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch removed from -mm tree
Message-Id: <20250114064554.9E014C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}
Date: Fri, 3 Jan 2025 09:43:59 -0800

DAMON sysfs interface uses damon_callback with its own complicated
synchronization facility to handle update_schemes_tried_bytes and
update_schemes_tried_regions commands.  But damos_walk() can support the
use case without the additional synchronizations.  Convert the code to use
damos_walk() instead.

Link: https://lkml.kernel.org/r/20250103174400.54890-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    5 +++
 mm/damon/sysfs-schemes.c |   48 +++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs.c         |   43 +++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions
+++ a/mm/damon/sysfs.c
@@ -1512,6 +1512,45 @@ static int damon_sysfs_damon_call(int (*
 	return damon_call(kdamond->damon_ctx, &call_control);
 }
 
+struct damon_sysfs_schemes_walk_data {
+	struct damon_sysfs_kdamond *sysfs_kdamond;
+	bool total_bytes_only;
+};
+
+/* populate the region directory */
+static void damon_sysfs_schemes_tried_regions_upd_one(void *data, struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s)
+{
+	struct damon_sysfs_schemes_walk_data *walk_data = data;
+	struct damon_sysfs_kdamond *sysfs_kdamond = walk_data->sysfs_kdamond;
+
+	damos_sysfs_populate_region_dir(
+			sysfs_kdamond->contexts->contexts_arr[0]->schemes,
+			ctx, t, r, s, walk_data->total_bytes_only);
+}
+
+static int damon_sysfs_update_schemes_tried_regions(
+		struct damon_sysfs_kdamond *sysfs_kdamond, bool total_bytes_only)
+{
+	struct damon_sysfs_schemes_walk_data walk_data = {
+		.sysfs_kdamond = sysfs_kdamond,
+		.total_bytes_only = total_bytes_only,
+	};
+	struct damos_walk_control control = {
+		.walk_fn = damon_sysfs_schemes_tried_regions_upd_one,
+		.data = &walk_data,
+	};
+	struct damon_ctx *ctx = sysfs_kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+
+	damon_sysfs_schemes_clear_regions(
+			sysfs_kdamond->contexts->contexts_arr[0]->schemes);
+	return damos_walk(ctx, &control);
+}
+
 /*
  * damon_sysfs_handle_cmd() - Handle a command for a specific kdamond.
  * @cmd:	The command to handle.
@@ -1542,6 +1581,10 @@ static int damon_sysfs_handle_cmd(enum d
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_schemes_stats, kdamond);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES:
+		return damon_sysfs_update_schemes_tried_regions(kdamond, true);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
+		return damon_sysfs_update_schemes_tried_regions(kdamond, false);
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		return damon_sysfs_schemes_clear_regions(
 			kdamond->contexts->contexts_arr[0]->schemes);
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions
+++ a/mm/damon/sysfs-common.h
@@ -55,6 +55,11 @@ bool damos_sysfs_regions_upd_done(void);
 
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
 
+void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos *s,
+		bool total_bytes_only);
+
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes);
 
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions
+++ a/mm/damon/sysfs-schemes.c
@@ -2183,6 +2183,54 @@ static int damon_sysfs_before_damos_appl
 	return 0;
 }
 
+/**
+ * damos_sysfs_populate_region_dir() - Populate a schemes tried region dir.
+ * @sysfs_schemes:	Schemes directory to populate regions directory.
+ * @ctx:		Corresponding DAMON context.
+ * @t:			DAMON target of @r.
+ * @r:			DAMON region to populate the directory for.
+ * @s:			Corresponding scheme.
+ * @total_bytes_only:	Whether the request is for bytes update only.
+ *
+ * Called from DAMOS walk callback while holding damon_sysfs_lock.
+ */
+void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos *s, bool total_bytes_only)
+{
+	struct damos *scheme;
+	struct damon_sysfs_scheme_regions *sysfs_regions;
+	struct damon_sysfs_scheme_region *region;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		if (scheme == s)
+			break;
+		schemes_idx++;
+	}
+
+	/* user could have removed the scheme sysfs dir */
+	if (schemes_idx >= sysfs_schemes->nr)
+		return;
+
+	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
+	sysfs_regions->total_bytes += r->ar.end - r->ar.start;
+	if (total_bytes_only)
+		return;
+
+	region = damon_sysfs_scheme_region_alloc(r);
+	if (!region)
+		return;
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
+	if (kobject_init_and_add(&region->kobj,
+				&damon_sysfs_scheme_region_ktype,
+				&sysfs_regions->kobj, "%d",
+				sysfs_regions->nr_regions++)) {
+		kobject_put(&region->kobj);
+	}
+}
+
 /*
  * DAMON callback that called after each accesses sampling.  While this
  * callback is registered, damon_sysfs_lock should be held to ensure the
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

