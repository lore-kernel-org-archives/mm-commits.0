Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9C2451CE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837170; cv=none; b=X/ADhD3nz9MTu0q2daoWzu5EQwnlA0OYALIiOZJ3pWxyH3plVa1Ifsw+dl6Xh8rv+PWOHl7LovP8F3518vl/+GuJVK8LPdv0PCnnkUlE1gMhN5e100UY3W0vLKBAJzqsqKQrkeCuyGtcVgQm0BrMC3DRDbZ0dCAz56edgn0sbhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837170; c=relaxed/simple;
	bh=CuA/n9rxLS6ze6h6JB02npdowCoODN4LkazXC5mckKE=;
	h=Date:To:From:Subject:Message-Id; b=YE/SjNTLYhOkcGP4JyvMUZAdaqnYdoeSmW/wWWln+jPK56tjsN+cAMpBThCvsh+gWeC319sCoWfAU334QTlN22HNwA2SNBUsPatzmAzlGl0ytEkjhBYb2DSSJj0m/z7zJfHU8YugMjuupdgKR3Rm83J3KRkZoJbxbNN9UzhDy7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaUn2utC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaUn2utC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872D5C4CEDD;
	Tue, 14 Jan 2025 06:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837169;
	bh=CuA/n9rxLS6ze6h6JB02npdowCoODN4LkazXC5mckKE=;
	h=Date:To:From:Subject:From;
	b=kaUn2utChIO2McmfYi9VSEeO4rhoDyNSwH+Nb+vZkDxB5nHQMQDgp/6RUys3U4/LY
	 0zim6OHM8mKcxHqm2rhgVVoqTWtf32BNL35APUjyVk7Oc/RcfAL6EWpdsaMN474TCl
	 mDJ3rZLNl1InGyKrTUJ46w7cuEYYnNyB2YtdEMms=
Date: Mon, 13 Jan 2025 22:46:09 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch removed from -mm tree
Message-Id: <20250114064609.872D5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: expose per-region filter-passed bytes
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: expose per-region filter-passed bytes
Date: Mon, 6 Jan 2025 11:33:58 -0800

Per-region operations set-handled DAMOS filters passed memory size
information is provided to only DAMON core API users.  Further expose it
to the user space by adding a new DAMON sysfs interface file under each
scheme tried region directory.

Link: https://lkml.kernel.org/r/20250106193401.109161-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 +-
 mm/damon/sysfs-schemes.c |   19 ++++++++++++++++++-
 mm/damon/sysfs.c         |    3 ++-
 3 files changed, 21 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs.c
@@ -1461,7 +1461,8 @@ static void damon_sysfs_schemes_tried_re
 
 	damos_sysfs_populate_region_dir(
 			sysfs_kdamond->contexts->contexts_arr[0]->schemes,
-			ctx, t, r, s, walk_data->total_bytes_only);
+			ctx, t, r, s, walk_data->total_bytes_only,
+			sz_filter_passed);
 }
 
 static int damon_sysfs_update_schemes_tried_regions(
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs-common.h
@@ -48,7 +48,7 @@ void damon_sysfs_schemes_update_stats(
 void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s,
-		bool total_bytes_only);
+		bool total_bytes_only, unsigned long sz_filter_passed);
 
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs-schemes.c
@@ -19,6 +19,7 @@ struct damon_sysfs_scheme_region {
 	struct damon_addr_range ar;
 	unsigned int nr_accesses;
 	unsigned int age;
+	unsigned long sz_filter_passed;
 	struct list_head list;
 };
 
@@ -74,6 +75,15 @@ static ssize_t age_show(struct kobject *
 	return sysfs_emit(buf, "%u\n", region->age);
 }
 
+static ssize_t sz_filter_passed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->sz_filter_passed);
+}
+
 static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 {
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
@@ -95,11 +105,15 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_region_age_attr =
 		__ATTR_RO_MODE(age, 0400);
 
+static struct kobj_attribute damon_sysfs_scheme_region_sz_filter_passed_attr =
+		__ATTR_RO_MODE(sz_filter_passed, 0400);
+
 static struct attribute *damon_sysfs_scheme_region_attrs[] = {
 	&damon_sysfs_scheme_region_start_attr.attr,
 	&damon_sysfs_scheme_region_end_attr.attr,
 	&damon_sysfs_scheme_region_nr_accesses_attr.attr,
 	&damon_sysfs_scheme_region_age_attr.attr,
+	&damon_sysfs_scheme_region_sz_filter_passed_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_region);
@@ -2105,12 +2119,14 @@ void damon_sysfs_schemes_update_stats(
  * @r:			DAMON region to populate the directory for.
  * @s:			Corresponding scheme.
  * @total_bytes_only:	Whether the request is for bytes update only.
+ * @sz_filter_passed:	Bytes of @r that passed filters of @s.
  *
  * Called from DAMOS walk callback while holding damon_sysfs_lock.
  */
 void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos *s, bool total_bytes_only)
+		struct damon_region *r, struct damos *s, bool total_bytes_only,
+		unsigned long sz_filter_passed)
 {
 	struct damos *scheme;
 	struct damon_sysfs_scheme_regions *sysfs_regions;
@@ -2135,6 +2151,7 @@ void damos_sysfs_populate_region_dir(str
 	region = damon_sysfs_scheme_region_alloc(r);
 	if (!region)
 		return;
+	region->sz_filter_passed = sz_filter_passed;
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

