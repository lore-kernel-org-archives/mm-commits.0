Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6CFC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjASBQ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjASBPa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077956842C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2648B81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55981C433EF;
        Thu, 19 Jan 2023 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090875;
        bh=TPWywZ90kQPgziSzjpUn1KHW8yW+BujyKGVIrtr8ZEk=;
        h=Date:To:From:Subject:From;
        b=eZWRVgqoJ0DriE1QC5juYpLSHTECCCfUxJCGWR7hVyYOkWmGq8wpSbCaFxCC3Ug5q
         z5+rCXCHbI39u/12ewau7t4yq7pJJtcPjOK1fM6V2aXpBA32WfkDEK7spuA2C99MIv
         00cACl2l4JGHWSHNH3FoaL9Uvqe+b5Sv/Cw2OoL4=
Date:   Wed, 18 Jan 2023 17:14:34 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-filters-directory.patch removed from -mm tree
Message-Id: <20230119011435.55981C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement filters directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-filters-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement filters directory
Date: Mon, 5 Dec 2022 23:08:24 +0000

DAMOS filters are currently supported by only DAMON kernel API.  To expose
the feature to user space, implement a DAMON sysfs directory named
'filters' under each scheme directory.  Please note that this is
implementing only the directory.  Following commits will implement more
files and directories, and finally connect the DAMOS filters feature.

Link: https://lkml.kernel.org/r/20221205230830.144349-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   85 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-filters-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -259,6 +259,63 @@ static struct kobj_type damon_sysfs_stat
 };
 
 /*
+ * filters directory
+ */
+
+struct damon_sysfs_scheme_filters {
+	struct kobject kobj;
+	int nr;
+};
+
+static struct damon_sysfs_scheme_filters *
+damon_sysfs_scheme_filters_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
+}
+
+static ssize_t nr_filters_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filters *filters = container_of(kobj,
+			struct damon_sysfs_scheme_filters, kobj);
+
+	return sysfs_emit(buf, "%d\n", filters->nr);
+}
+
+static ssize_t nr_filters_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	return count;
+}
+
+static void damon_sysfs_scheme_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_scheme_filters, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_scheme_filters_nr_attr =
+		__ATTR_RW_MODE(nr_filters, 0600);
+
+static struct attribute *damon_sysfs_scheme_filters_attrs[] = {
+	&damon_sysfs_scheme_filters_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_scheme_filters);
+
+static struct kobj_type damon_sysfs_scheme_filters_ktype = {
+	.release = damon_sysfs_scheme_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_scheme_filters_groups,
+};
+
+/*
  * watermarks directory
  */
 
@@ -784,6 +841,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_access_pattern *access_pattern;
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
+	struct damon_sysfs_scheme_filters *filters;
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
 };
@@ -878,6 +936,24 @@ static int damon_sysfs_scheme_set_waterm
 	return err;
 }
 
+static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme)
+{
+	struct damon_sysfs_scheme_filters *filters =
+		damon_sysfs_scheme_filters_alloc();
+	int err;
+
+	if (!filters)
+		return -ENOMEM;
+	err = kobject_init_and_add(&filters->kobj,
+			&damon_sysfs_scheme_filters_ktype, &scheme->kobj,
+			"filters");
+	if (err)
+		kobject_put(&filters->kobj);
+	else
+		scheme->filters = filters;
+	return err;
+}
+
 static int damon_sysfs_scheme_set_stats(struct damon_sysfs_scheme *scheme)
 {
 	struct damon_sysfs_stats *stats = damon_sysfs_stats_alloc();
@@ -926,9 +1002,12 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
-	err = damon_sysfs_scheme_set_stats(scheme);
+	err = damon_sysfs_scheme_set_filters(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
+	err = damon_sysfs_scheme_set_stats(scheme);
+	if (err)
+		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
 		goto put_tried_regions_out;
@@ -937,6 +1016,9 @@ static int damon_sysfs_scheme_add_dirs(s
 put_tried_regions_out:
 	kobject_put(&scheme->tried_regions->kobj);
 	scheme->tried_regions = NULL;
+put_filters_watermarks_quotas_access_pattern_out:
+	kobject_put(&scheme->filters->kobj);
+	scheme->filters = NULL;
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
@@ -956,6 +1038,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
+	kobject_put(&scheme->filters->kobj);
 	kobject_put(&scheme->stats->kobj);
 	damon_sysfs_scheme_regions_rm_dirs(scheme->tried_regions);
 	kobject_put(&scheme->tried_regions->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

