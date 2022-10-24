Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66181FA373D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJYAIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiJYAHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:07:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A0B83052
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72AFCB811FB
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FBBC433C1;
        Mon, 24 Oct 2022 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650345;
        bh=1S1/TMA7IpxDXSrqedFM0moTtwUw17C1yaORMWvAQJU=;
        h=Date:To:From:Subject:From;
        b=hTf2qrCKoPayCqw85pYdqfIQVNKrlpGwU6Jl+V/Y2HYrnEeem1Emsh98zTjG2QqiF
         UCwleVF/SK0eyGwanath3jdUcN/sbhXWclKujm+JZyt5Jj/YxpckjzaN9VB6ObERr8
         pS9uWI+f7HfN98Jt1Fv2xi9VOdz2tik+PRcypyUQ=
Date:   Mon, 24 Oct 2022 15:25:44 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch added to mm-unstable branch
Message-Id: <20221024222545.12FBBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: remove parameters of damon_sysfs_region_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch

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
Subject: mm/damon/sysfs: remove parameters of damon_sysfs_region_alloc()
Date: Mon, 24 Oct 2022 20:49:14 +0000

'damon_sysfs_region_alloc()' is always called with zero-filled 'struct
damon_addr_range', because the start and end addresses should set by
users.  Remove unnecessary parameters of the function and simplify the
body by using 'kzalloc()'.

Link: https://lkml.kernel.org/r/20221024204919.18524-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc
+++ a/mm/damon/sysfs.c
@@ -1065,17 +1065,9 @@ struct damon_sysfs_region {
 	struct damon_addr_range ar;
 };
 
-static struct damon_sysfs_region *damon_sysfs_region_alloc(
-		struct damon_addr_range ar)
+static struct damon_sysfs_region *damon_sysfs_region_alloc(void)
 {
-	struct damon_sysfs_region *region = kmalloc(sizeof(*region),
-			GFP_KERNEL);
-
-	if (!region)
-		return NULL;
-	region->kobj = (struct kobject){};
-	region->ar = ar;
-	return region;
+	return kzalloc(sizeof(struct damon_sysfs_region), GFP_KERNEL);
 }
 
 static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1184,7 +1176,7 @@ static int damon_sysfs_regions_add_dirs(
 	regions->regions_arr = regions_arr;
 
 	for (i = 0; i < nr_regions; i++) {
-		region = damon_sysfs_region_alloc((struct damon_addr_range){});
+		region = damon_sysfs_region_alloc();
 		if (!region) {
 			damon_sysfs_regions_rm_dirs(regions);
 			return -ENOMEM;
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
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

