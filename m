Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DF01D63D6
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274560; cv=none; b=MBqSOK49wDdLwj+PdL1/Krwk/DFkuPNZolicm7zfjzpxwvzKuBruyAugVYwQcpaezBPhw9OnMJ5DbILONc1JD6ivItzyzB4ucpLK1LqSvSoa6VLgaJy07YwNc4PTpR+kIrY7OBOyYeP6C2Rqv42oMIv5ijbpX0YjUmk3C7hnRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274560; c=relaxed/simple;
	bh=kiJYCwNwJsdAd5d4Xn3uzaUX1EGf+Tf8bDyugh5fhIk=;
	h=Date:To:From:Subject:Message-Id; b=iyb8YsU4vuB3vbH6pV95Cp1MbUUHY9tcJVL1IKJwQ2yyz1CMrLkfaj4tYXSPiUf9wCjqWWmFIlahfwrjjLbXHMYWWHWgkczRUyZBw20rSbqjIP+eFZOEVoabiZtHMiheE+VjPMlTm59Sj8+9HhEW1lUfbgg0psGAGv4qnFZK6w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EaWfUoAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EaWfUoAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A8AC4CEDD;
	Tue, 18 Mar 2025 05:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274558;
	bh=kiJYCwNwJsdAd5d4Xn3uzaUX1EGf+Tf8bDyugh5fhIk=;
	h=Date:To:From:Subject:From;
	b=EaWfUoAWekT0r4301p5HG6T/lnF+VVjkBW0UNnLzOxTYI50eXtRVeC0vWZUjCQQiz
	 vWgbG7+B9T1MlJeq88xJL9gALFGm8Fs0iiXdC/i6Ek1koQ/dmxdeCvh13XUbZSrvrd
	 x/535VkSB1gm+RSNNqVfXrQmiAbK1ipkex/POugw=
Date: Mon, 17 Mar 2025 22:09:17 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch removed from -mm tree
Message-Id: <20250318050918.55A8AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement core_filters and ops_filters directories
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement core_filters and ops_filters directories
Date: Wed, 5 Mar 2025 14:27:27 -0800

Implement two DAMOS sysfs directories for managing core and operations
layer handled filters separately.  Those are named as 'core_filters' and
'ops_filters', and have files hierarchy same to 'filters'.  This commit is
only populating and cleaning up the directories, not really connecting the
files with DAMON.  Following changes will make the connections.

Link: https://lkml.kernel.org/r/20250305222733.59089-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   40 +++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -1504,6 +1504,8 @@ struct damon_sysfs_scheme {
 	unsigned long apply_interval_us;
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
+	struct damon_sysfs_scheme_filters *core_filters;
+	struct damon_sysfs_scheme_filters *ops_filters;
 	struct damon_sysfs_scheme_filters *filters;
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
@@ -1624,6 +1626,33 @@ static int damon_sysfs_scheme_set_filter
 	return err;
 }
 
+static int damos_sysfs_set_filter_dirs(struct damon_sysfs_scheme *scheme)
+{
+	int err;
+
+	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+			&scheme->filters);
+	if (err)
+		return err;
+	err = damon_sysfs_scheme_set_filters(scheme, "core_filters",
+			&scheme->core_filters);
+	if (err)
+		goto put_filters_out;
+	err = damon_sysfs_scheme_set_filters(scheme, "ops_filters",
+			&scheme->ops_filters);
+	if (err)
+		goto put_core_filters_out;
+	return 0;
+
+put_core_filters_out:
+	kobject_put(&scheme->core_filters->kobj);
+	scheme->core_filters = NULL;
+put_filters_out:
+	kobject_put(&scheme->filters->kobj);
+	scheme->filters = NULL;
+	return err;
+}
+
 static int damon_sysfs_scheme_set_stats(struct damon_sysfs_scheme *scheme)
 {
 	struct damon_sysfs_stats *stats = damon_sysfs_stats_alloc();
@@ -1672,8 +1701,7 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
-	err = damon_sysfs_scheme_set_filters(scheme, "filters",
-			&scheme->filters);
+	err = damos_sysfs_set_filter_dirs(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_stats(scheme);
@@ -1688,6 +1716,10 @@ put_tried_regions_out:
 	kobject_put(&scheme->tried_regions->kobj);
 	scheme->tried_regions = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
+	kobject_put(&scheme->ops_filters->kobj);
+	scheme->ops_filters = NULL;
+	kobject_put(&scheme->core_filters->kobj);
+	scheme->core_filters = NULL;
 	kobject_put(&scheme->filters->kobj);
 	scheme->filters = NULL;
 put_watermarks_quotas_access_pattern_out:
@@ -1711,6 +1743,10 @@ static void damon_sysfs_scheme_rm_dirs(s
 	kobject_put(&scheme->watermarks->kobj);
 	damon_sysfs_scheme_filters_rm_dirs(scheme->filters);
 	kobject_put(&scheme->filters->kobj);
+	damon_sysfs_scheme_filters_rm_dirs(scheme->core_filters);
+	kobject_put(&scheme->core_filters->kobj);
+	damon_sysfs_scheme_filters_rm_dirs(scheme->ops_filters);
+	kobject_put(&scheme->ops_filters->kobj);
 	kobject_put(&scheme->stats->kobj);
 	damon_sysfs_scheme_regions_rm_dirs(scheme->tried_regions);
 	kobject_put(&scheme->tried_regions->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are


