Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1794FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiLPX7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLPX7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC7E73B02
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F364DB81E4A
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA009C433D2;
        Fri, 16 Dec 2022 23:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235178;
        bh=WN0AJEb8B4i0NIMOQwUTxEL2+25s7WNwjFtm5/rwjY0=;
        h=Date:To:From:Subject:From;
        b=jkJapuboo4ek9SIuRb2901dKbYaVNFFRKal2Aohw+H8yhh7jSZuLGvP43xvmWcA7C
         5DTR3KkSa/+K0mglQc6qXy949tjc0rDmv4nxZR8zD2osWCcroPWUa9Z2dNUiwlXQ3p
         GBedLFSybIMvdZSWEDq9hhFp1+IyUzSiX2rJCcts=
Date:   Fri, 16 Dec 2022 15:59:37 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-filters-directory.patch added to mm-unstable branch
Message-Id: <20221216235938.AA009C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement filters directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-filters-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-filters-directory.patch

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

