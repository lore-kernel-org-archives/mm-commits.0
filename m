Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44F7C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKAW6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiKAW6f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466042C2
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E47CB81FFA
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A8C433C1;
        Tue,  1 Nov 2022 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343509;
        bh=kYqoTCiMX7UIFcAuQmp4Gt0R6McLct9OCl2U9EhjsL8=;
        h=Date:To:From:Subject:From;
        b=ZL3FIpLD/iyuQXsDC+mxwxEfGK8nOkeUE8mzX6HunK7Wi7uzh1t8h4ZgwMJ8NSOm/
         GEXtHPe1stCFaQyONUmivk4S2HFASwOxp7yte+vFA4nNUBOrpS6W5UExNBl8S32deI
         GWioBG098CNACPha1d3Yd8dnlH5Qx7YgmqeDaMsU=
Date:   Tue, 01 Nov 2022 15:58:29 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch added to mm-unstable branch
Message-Id: <20221101225829.AD0A8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement schemes/tried_regions directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch

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
Subject: mm/damon/sysfs-schemes: implement schemes/tried_regions directory
Date: Tue, 1 Nov 2022 22:03:22 +0000

For efficient and simple query-like DAMON monitoring results readings and
deep level investigations of DAMOS, DAMON kernel API
(include/linux/damon.h) users can use 'before_damos_apply' DAMON callback.
However, DAMON sysfs interface users don't have such option.

Add a directory, namely 'tried_regions', under each scheme directory to
use it as the interface for the purpose.  Note that this commit is
implementing only the directory but the data filling.

After the data filling change is made, users will be able to signal DAMON
to fill the directory with the regions that corresponding scheme has tried
to be applied.  By setting the access pattern of the scheme, users could
do the efficient query-like monitoring.

Link: https://lkml.kernel.org/r/20221101220328.95765-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -10,6 +10,36 @@
 #include "sysfs-common.h"
 
 /*
+ * scheme regions directory
+ */
+
+struct damon_sysfs_scheme_regions {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_scheme_regions *
+damon_sysfs_scheme_regions_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_scheme_regions), GFP_KERNEL);
+}
+
+static void damon_sysfs_scheme_regions_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_scheme_regions, kobj));
+}
+
+static struct attribute *damon_sysfs_scheme_regions_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_scheme_regions);
+
+static struct kobj_type damon_sysfs_scheme_regions_ktype = {
+	.release = damon_sysfs_scheme_regions_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_scheme_regions_groups,
+};
+
+/*
  * schemes/stats directory
  */
 
@@ -635,6 +665,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
 	struct damon_sysfs_stats *stats;
+	struct damon_sysfs_scheme_regions *tried_regions;
 };
 
 /* This should match with enum damos_action */
@@ -743,6 +774,25 @@ static int damon_sysfs_scheme_set_stats(
 	return err;
 }
 
+static int damon_sysfs_scheme_set_tried_regions(
+		struct damon_sysfs_scheme *scheme)
+{
+	struct damon_sysfs_scheme_regions *tried_regions =
+		damon_sysfs_scheme_regions_alloc();
+	int err;
+
+	if (!tried_regions)
+		return -ENOMEM;
+	err = kobject_init_and_add(&tried_regions->kobj,
+			&damon_sysfs_scheme_regions_ktype, &scheme->kobj,
+			"tried_regions");
+	if (err)
+		kobject_put(&tried_regions->kobj);
+	else
+		scheme->tried_regions = tried_regions;
+	return err;
+}
+
 static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 {
 	int err;
@@ -759,8 +809,14 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_stats(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
+	err = damon_sysfs_scheme_set_tried_regions(scheme);
+	if (err)
+		goto put_tried_regions_out;
 	return 0;
 
+put_tried_regions_out:
+	kobject_put(&scheme->tried_regions->kobj);
+	scheme->tried_regions = NULL;
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
@@ -781,6 +837,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
 	kobject_put(&scheme->stats->kobj);
+	kobject_put(&scheme->tried_regions->kobj);
 }
 
 static ssize_t action_show(struct kobject *kobj, struct kobj_attribute *attr,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch

