Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE81D6DD8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274561; cv=none; b=Ci2UdAojPmIexmvdfvnEP6LE0phzR+xT8suPVhTj+3t93em1ON1/0hP+YEhewQKcpFX3KWDdVXiSgKHQdfZHOZ210v0xBu+vOtuY9hefntLG3509u+KuhwYxiNX6GlORVcmnqqlCvcAkQ75T5QCr/FYiokOzcszobORHi2cHxbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274561; c=relaxed/simple;
	bh=9naOwMBRUXKm8Vuh3Cz65+gCQDtuEQzwbceQIWreM3g=;
	h=Date:To:From:Subject:Message-Id; b=K/1Ej7vPI7vEg7WBPo1HzpFMSrwH9UEnfg5TIxvU0H73AERvPv/O431E6Ningxt7bFJ0mkis9vphYhM1e49MIKx3nJZc8r7xiB/nTiqDzE4bVcNVv9FoYosvs4+lQOvrWKfa9GbMyq1bIc+j+hluHCZIzP54cgJ7ut8ToT1QE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZlZX4H+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlZX4H+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891EFC4CEDD;
	Tue, 18 Mar 2025 05:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274561;
	bh=9naOwMBRUXKm8Vuh3Cz65+gCQDtuEQzwbceQIWreM3g=;
	h=Date:To:From:Subject:From;
	b=ZlZX4H+63Ex6LviOsHrfCt7qhaRNI9mGPmjjMDd4s7Kln5tvvAx8eCUdkyrpwv7cG
	 YKC8A9vrB/wI3e+mVH4b5U6TCZVQ/51XSOZjLilQrgh5lFt8rX5oeVjXgMOfC3rLd8
	 M2IvDQ0gMWZI57//UlOT2/V5BsNeEXezXrA8Zx1U=
Date: Mon, 17 Mar 2025 22:09:21 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch removed from -mm tree
Message-Id: <20250318050921.891EFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: record filters of which layer should be added to the given filters directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: record filters of which layer should be added to the given filters directory
Date: Wed, 5 Mar 2025 14:27:30 -0800

Unlike their name and assumed purposes, {core,ops}_filters DAMOS sysfs
directories are allowing installing any type of filters.  As a first step
for preventing such wrong installments, add information about filters that
handled by what layer should the installed to the given filters directory
in the DAMOS sysfs internal data structures.

Link: https://lkml.kernel.org/r/20250305222733.59089-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   46 ++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -309,8 +309,18 @@ static const struct kobj_type damon_sysf
  * filter directory
  */
 
+/*
+ * enum damos_sysfs_filter_handle_layer - Layers handling filters of a dir.
+ */
+enum damos_sysfs_filter_handle_layer {
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE,
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS,
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH,
+};
+
 struct damon_sysfs_scheme_filter {
 	struct kobject kobj;
+	enum damos_sysfs_filter_handle_layer handle_layer;
 	enum damos_filter_type type;
 	bool matching;
 	bool allow;
@@ -320,9 +330,15 @@ struct damon_sysfs_scheme_filter {
 	int target_idx;
 };
 
-static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(void)
+static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(
+		enum damos_sysfs_filter_handle_layer layer)
 {
-	return kzalloc(sizeof(struct damon_sysfs_scheme_filter), GFP_KERNEL);
+	struct damon_sysfs_scheme_filter *filter;
+
+	filter = kzalloc(sizeof(struct damon_sysfs_scheme_filter), GFP_KERNEL);
+	if (filter)
+		filter->handle_layer = layer;
+	return filter;
 }
 
 /* Should match with enum damos_filter_type */
@@ -595,14 +611,20 @@ static const struct kobj_type damon_sysf
 
 struct damon_sysfs_scheme_filters {
 	struct kobject kobj;
+	enum damos_sysfs_filter_handle_layer handle_layer;
 	struct damon_sysfs_scheme_filter **filters_arr;
 	int nr;
 };
 
 static struct damon_sysfs_scheme_filters *
-damon_sysfs_scheme_filters_alloc(void)
+damon_sysfs_scheme_filters_alloc(enum damos_sysfs_filter_handle_layer layer)
 {
-	return kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
+	struct damon_sysfs_scheme_filters *filters;
+
+	filters = kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
+	if (filters)
+		filters->handle_layer = layer;
+	return filters;
 }
 
 static void damon_sysfs_scheme_filters_rm_dirs(
@@ -635,7 +657,8 @@ static int damon_sysfs_scheme_filters_ad
 	filters->filters_arr = filters_arr;
 
 	for (i = 0; i < nr_filters; i++) {
-		filter = damon_sysfs_scheme_filter_alloc();
+		filter = damon_sysfs_scheme_filter_alloc(
+				filters->handle_layer);
 		if (!filter) {
 			damon_sysfs_scheme_filters_rm_dirs(filters);
 			return -ENOMEM;
@@ -1607,11 +1630,11 @@ static int damon_sysfs_scheme_set_waterm
 }
 
 static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme,
-		const char *name,
+		enum damos_sysfs_filter_handle_layer layer, const char *name,
 		struct damon_sysfs_scheme_filters **filters_ptr)
 {
 	struct damon_sysfs_scheme_filters *filters =
-		damon_sysfs_scheme_filters_alloc();
+		damon_sysfs_scheme_filters_alloc(layer);
 	int err;
 
 	if (!filters)
@@ -1630,15 +1653,18 @@ static int damos_sysfs_set_filter_dirs(s
 {
 	int err;
 
-	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH, "filters",
 			&scheme->filters);
 	if (err)
 		return err;
-	err = damon_sysfs_scheme_set_filters(scheme, "core_filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE, "core_filters",
 			&scheme->core_filters);
 	if (err)
 		goto put_filters_out;
-	err = damon_sysfs_scheme_set_filters(scheme, "ops_filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS, "ops_filters",
 			&scheme->ops_filters);
 	if (err)
 		goto put_core_filters_out;
_

Patches currently in -mm which might be from sj@kernel.org are


