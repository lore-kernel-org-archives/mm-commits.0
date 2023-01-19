Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A31BC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjASBRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjASBPa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1AD69232
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD39C61B0F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F80C433D2;
        Thu, 19 Jan 2023 01:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090878;
        bh=yG11CWAFiYi0+0gLoyTHLDN+lYFPNsksgSeJ7L669T0=;
        h=Date:To:From:Subject:From;
        b=gaMqiDzmnN1fOYfHd/4xkNoeo4Je2KFZ3m6f+4ff04kj/PiD9hxgGZroFkX6oa3Oi
         W7HZCJ051SZLqR43XGSrNaas3fpQl6QbUlVs/5xk7+iNktjFRBTzoRzh8tjpoRbVdc
         isDvF2X5nr9gjb+H47Zkaq/apI9/cIrTgmpLL/PQ=
Date:   Wed, 18 Jan 2023 17:14:37 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch removed from -mm tree
Message-Id: <20230119011438.23F80C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: connect filter directory and filters directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: connect filter directory and filters directory
Date: Mon, 5 Dec 2022 23:08:26 +0000

Implement 'nr_filters' file under 'filters' directory, which will be used
to populate specific number of 'filter' directory under the directory,
similar to other 'nr_*' files in DAMON sysfs interface.

Link: https://lkml.kernel.org/r/20221205230830.144349-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   68 +++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -269,6 +269,11 @@ struct damon_sysfs_scheme_filter {
 	char *memcg_path;
 };
 
+static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_scheme_filter), GFP_KERNEL);
+}
+
 /* Should match with enum damos_filter_type */
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
@@ -392,6 +397,7 @@ static struct kobj_type damon_sysfs_sche
 
 struct damon_sysfs_scheme_filters {
 	struct kobject kobj;
+	struct damon_sysfs_scheme_filter **filters_arr;
 	int nr;
 };
 
@@ -401,6 +407,57 @@ damon_sysfs_scheme_filters_alloc(void)
 	return kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
 }
 
+static void damon_sysfs_scheme_filters_rm_dirs(
+		struct damon_sysfs_scheme_filters *filters)
+{
+	struct damon_sysfs_scheme_filter **filters_arr = filters->filters_arr;
+	int i;
+
+	for (i = 0; i < filters->nr; i++)
+		kobject_put(&filters_arr[i]->kobj);
+	filters->nr = 0;
+	kfree(filters_arr);
+	filters->filters_arr = NULL;
+}
+
+static int damon_sysfs_scheme_filters_add_dirs(
+		struct damon_sysfs_scheme_filters *filters, int nr_filters)
+{
+	struct damon_sysfs_scheme_filter **filters_arr, *filter;
+	int err, i;
+
+	damon_sysfs_scheme_filters_rm_dirs(filters);
+	if (!nr_filters)
+		return 0;
+
+	filters_arr = kmalloc_array(nr_filters, sizeof(*filters_arr),
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!filters_arr)
+		return -ENOMEM;
+	filters->filters_arr = filters_arr;
+
+	for (i = 0; i < nr_filters; i++) {
+		filter = damon_sysfs_scheme_filter_alloc();
+		if (!filter) {
+			damon_sysfs_scheme_filters_rm_dirs(filters);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&filter->kobj,
+				&damon_sysfs_scheme_filter_ktype,
+				&filters->kobj, "%d", i);
+		if (err) {
+			kobject_put(&filter->kobj);
+			damon_sysfs_scheme_filters_rm_dirs(filters);
+			return err;
+		}
+
+		filters_arr[i] = filter;
+		filters->nr++;
+	}
+	return 0;
+}
+
 static ssize_t nr_filters_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -413,6 +470,7 @@ static ssize_t nr_filters_show(struct ko
 static ssize_t nr_filters_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
+	struct damon_sysfs_scheme_filters *filters;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -420,6 +478,15 @@ static ssize_t nr_filters_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	filters = container_of(kobj, struct damon_sysfs_scheme_filters, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_scheme_filters_add_dirs(filters, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
 	return count;
 }
 
@@ -1166,6 +1233,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
+	damon_sysfs_scheme_filters_rm_dirs(scheme->filters);
 	kobject_put(&scheme->filters->kobj);
 	kobject_put(&scheme->stats->kobj);
 	damon_sysfs_scheme_regions_rm_dirs(scheme->tried_regions);
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

