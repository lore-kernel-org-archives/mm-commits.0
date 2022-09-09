Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DF1ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiIIWo5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiIIWoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5D43E761
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74346213D
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFA9C433C1;
        Fri,  9 Sep 2022 22:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662763485;
        bh=v1YKkDIzHVRmSmBn7iqfy+BYA/EjkfAbpzUlmjxGQwY=;
        h=Date:To:From:Subject:From;
        b=1050/DYckixsoerV+uQ+L//E4CJXuy3qVRsHF5Y/6MCYx/F2Sq8RyvKUi/psMcpHi
         AXJUYDh2f1KXCubaah2Uj+GK75KxoDwwVg4cXut2gQ7DlorL/Qos/04iND7cucH3ie
         MQ14mgEIO9oG8BfQIe8uVIFdyz3WZLPNV0M4VeI4=
Date:   Fri, 09 Sep 2022 15:44:44 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-change-few-functions-execute-order.patch added to mm-unstable branch
Message-Id: <20220909224445.1DFA9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: change few functions execute order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-change-few-functions-execute-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-change-few-functions-execute-order.patch

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
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: change few functions execute order
Date: Thu, 8 Sep 2022 16:19:32 +0800

There's no need to run container_of() as early as we do.

The compiler figures this out, but the resulting code is more readable.

Link: https://lkml.kernel.org/r/20220908081932.77370-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-change-few-functions-execute-order
+++ a/mm/damon/sysfs.c
@@ -1031,8 +1031,7 @@ static ssize_t nr_schemes_show(struct ko
 static ssize_t nr_schemes_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_schemes *schemes = container_of(kobj,
-			struct damon_sysfs_schemes, kobj);
+	struct damon_sysfs_schemes *schemes;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1040,6 +1039,8 @@ static ssize_t nr_schemes_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	schemes = container_of(kobj, struct damon_sysfs_schemes, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_schemes_add_dirs(schemes, nr);
@@ -1237,8 +1238,7 @@ static ssize_t nr_regions_show(struct ko
 static ssize_t nr_regions_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_regions *regions = container_of(kobj,
-			struct damon_sysfs_regions, kobj);
+	struct damon_sysfs_regions *regions;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1246,6 +1246,8 @@ static ssize_t nr_regions_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	regions = container_of(kobj, struct damon_sysfs_regions, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_regions_add_dirs(regions, nr);
@@ -1440,8 +1442,7 @@ static ssize_t nr_targets_show(struct ko
 static ssize_t nr_targets_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_targets *targets = container_of(kobj,
-			struct damon_sysfs_targets, kobj);
+	struct damon_sysfs_targets *targets;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1449,6 +1450,8 @@ static ssize_t nr_targets_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	targets = container_of(kobj, struct damon_sysfs_targets, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_targets_add_dirs(targets, nr);
@@ -1962,8 +1965,7 @@ static ssize_t nr_contexts_show(struct k
 static ssize_t nr_contexts_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_contexts *contexts = container_of(kobj,
-			struct damon_sysfs_contexts, kobj);
+	struct damon_sysfs_contexts *contexts;
 	int nr, err;
 
 	err = kstrtoint(buf, 0, &nr);
@@ -1973,6 +1975,7 @@ static ssize_t nr_contexts_store(struct
 	if (nr < 0 || 1 < nr)
 		return -EINVAL;
 
+	contexts = container_of(kobj, struct damon_sysfs_contexts, kobj);
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_contexts_add_dirs(contexts, nr);
@@ -2737,8 +2740,7 @@ static ssize_t nr_kdamonds_show(struct k
 static ssize_t nr_kdamonds_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_kdamonds *kdamonds = container_of(kobj,
-			struct damon_sysfs_kdamonds, kobj);
+	struct damon_sysfs_kdamonds *kdamonds;
 	int nr, err;
 
 	err = kstrtoint(buf, 0, &nr);
@@ -2747,6 +2749,8 @@ static ssize_t nr_kdamonds_store(struct
 	if (nr < 0)
 		return -EINVAL;
 
+	kdamonds = container_of(kobj, struct damon_sysfs_kdamonds, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_kdamonds_add_dirs(kdamonds, nr);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch

