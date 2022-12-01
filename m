Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8D6C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiLAABP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLAAAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DFA87CAD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B519B61E22
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5251C433D7;
        Thu,  1 Dec 2022 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852837;
        bh=hIyMjUTFVTKmqWbDOAPkN4wjhoVEPQCK3wlMsOsNNok=;
        h=Date:To:From:Subject:From;
        b=TKzneoHeDf31F/RebkDJS/cBU+U+Y/F0vcvWLq2JB4MSFTekwq3PJJcllmyeFtqSQ
         /JfBE5cyzcxkjanB1wCkLgcBWqYZkdaN4rCdM2Hr6Jwxq/cv0iqwLbs/wjB0EE7Ye+
         G1yUx2wMUdoHfm9GdUpiEYyyeOmJofLi5unN6BtY=
Date:   Wed, 30 Nov 2022 16:00:36 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch removed from -mm tree
Message-Id: <20221201000036.E5251C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement schemes/tried_regions directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


