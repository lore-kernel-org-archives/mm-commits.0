Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6ADC4332F
	for <mm-commits@archiver.kernel.org>; Sat, 17 Dec 2022 00:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiLQAAK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 19:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLPX7t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DEC73B1F
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69B05B81E4C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098B7C433EF;
        Fri, 16 Dec 2022 23:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235185;
        bh=3mL+pa9Rs9O9nHTiMH4w+fRJDGxWVpzD6Jk9l8QG66o=;
        h=Date:To:From:Subject:From;
        b=bZdyEhkK+DH3yqDqfFqedPs3IV3G8Ex1JjFhIlPcxkJ0pyUbPz/49Za6g4ORZbdzH
         IcoFmOdREePL9CcqIvnM/ln8XCTjA66mi8OOckBVZ5KAuWmdoDcGNqqMs6fVOeuveb
         3Sq8r6y5rfybk/arWeaYhvHXjvAkwxh8wJ3rL3us=
Date:   Fri, 16 Dec 2022 15:59:44 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-scheme-filters.patch added to mm-unstable branch
Message-Id: <20221216235945.098B7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement scheme filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-scheme-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-scheme-filters.patch

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
Subject: mm/damon/sysfs-schemes: implement scheme filters
Date: Mon, 5 Dec 2022 23:08:27 +0000

Implement scheme filters functionality of DAMON sysfs interface by making
the code reads the values of files under the filter directories and pass
that to DAMON using DAMON kernel API.

Link: https://lkml.kernel.org/r/20221205230830.144349-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   89 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-scheme-filters
+++ a/mm/damon/sysfs-schemes.c
@@ -1403,6 +1403,75 @@ struct kobj_type damon_sysfs_schemes_kty
 	.default_groups = damon_sysfs_schemes_groups,
 };
 
+static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
+		char *memcg_path_buf, char *path)
+{
+#ifdef CONFIG_MEMCG
+	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
+	if (sysfs_streq(memcg_path_buf, path))
+		return true;
+#endif /* CONFIG_MEMCG */
+	return false;
+}
+
+static int damon_sysfs_memcg_path_to_id(char *memcg_path, unsigned short *id)
+{
+	struct mem_cgroup *memcg;
+	char *path;
+
+	if (!memcg_path)
+		return -EINVAL;
+
+	path = kmalloc(sizeof(*path) * PATH_MAX, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
+			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
+		/* skip removed memcg */
+		if (!mem_cgroup_id(memcg))
+			continue;
+		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
+			*id = mem_cgroup_id(memcg);
+			break;
+		}
+	}
+
+	kfree(path);
+	return 0;
+}
+
+static int damon_sysfs_set_scheme_filters(struct damos *scheme,
+		struct damon_sysfs_scheme_filters *sysfs_filters)
+{
+	int i;
+	struct damos_filter *filter, *next;
+
+	damos_for_each_filter_safe(filter, next, scheme)
+		damos_destroy_filter(filter);
+
+	for (i = 0; i < sysfs_filters->nr; i++) {
+		struct damon_sysfs_scheme_filter *sysfs_filter =
+			sysfs_filters->filters_arr[i];
+		struct damos_filter *filter =
+			damos_new_filter(sysfs_filter->type,
+					sysfs_filter->matching);
+		int err;
+
+		if (!filter)
+			return -ENOMEM;
+		if (filter->type == DAMOS_FILTER_TYPE_MEMCG) {
+			err = damon_sysfs_memcg_path_to_id(
+					sysfs_filter->memcg_path,
+					&filter->memcg_id);
+			if (err)
+				return err;
+		}
+		damos_add_filter(scheme, filter);
+	}
+	return 0;
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
@@ -1411,6 +1480,10 @@ static struct damos *damon_sysfs_mk_sche
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
 	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
+	struct damon_sysfs_scheme_filters *sysfs_filters =
+		sysfs_scheme->filters;
+	struct damos *scheme;
+	int err;
 
 	struct damos_access_pattern pattern = {
 		.min_sz_region = access_pattern->sz->min,
@@ -1436,8 +1509,17 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
-	return damon_new_scheme(&pattern, sysfs_scheme->action, &quota,
+	scheme = damon_new_scheme(&pattern, sysfs_scheme->action, &quota,
 			&wmarks);
+	if (!scheme)
+		return NULL;
+
+	err = damon_sysfs_set_scheme_filters(scheme, sysfs_filters);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+	return scheme;
 }
 
 static void damon_sysfs_update_scheme(struct damos *scheme,
@@ -1448,6 +1530,7 @@ static void damon_sysfs_update_scheme(st
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
 	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
+	int err;
 
 	scheme->pattern.min_sz_region = access_pattern->sz->min;
 	scheme->pattern.max_sz_region = access_pattern->sz->max;
@@ -1470,6 +1553,10 @@ static void damon_sysfs_update_scheme(st
 	scheme->wmarks.high = sysfs_wmarks->high;
 	scheme->wmarks.mid = sysfs_wmarks->mid;
 	scheme->wmarks.low = sysfs_wmarks->low;
+
+	err = damon_sysfs_set_scheme_filters(scheme, sysfs_scheme->filters);
+	if (err)
+		damon_destroy_scheme(scheme);
 }
 
 int damon_sysfs_set_schemes(struct damon_ctx *ctx,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

