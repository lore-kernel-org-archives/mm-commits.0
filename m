Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8406C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiI1Oxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiI1OxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99EF8689D
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9F5361ED1
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FE4C433D6;
        Wed, 28 Sep 2022 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376796;
        bh=ArEW0svYhXr0KunlIlsfdrwSRb8PMMX40pEAlyaRDF0=;
        h=Date:To:From:Subject:From;
        b=olX4HOtjtGST1IcuvR4wYZEEOjIZLZzraN461hjGrlgFVvoUGuNpMWhO3sOdNzOHM
         2STQkW10EFcuGvo7raxeYGMf3Vcx3AGzXn5l8FIvihtrTGUzZ8LrwPE+Mx8/lnQPR2
         gElCJsWmx4LYTHQc/tv3XUyldarpu5EER/UdgzpY=
Date:   Wed, 28 Sep 2022 07:53:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-move-sz_damon_region-to-damon_sz_region.patch added to mm-unstable branch
Message-Id: <20220928145315.F1FE4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: move sz_damon_region to damon_sz_region
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-move-sz_damon_region-to-damon_sz_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-move-sz_damon_region-to-damon_sz_region.patch

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
Subject: mm/damon: move sz_damon_region to damon_sz_region
Date: Tue, 27 Sep 2022 08:19:45 +0800

Rename sz_damon_region() to damon_sz_region(), and move it to
"include/linux/damon.h", because in many places, we can to use this func.

Link: https://lkml.kernel.org/r/20220927001946.85375-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/damon.h~mm-damon-move-sz_damon_region-to-damon_sz_region
+++ a/include/linux/damon.h
@@ -484,6 +484,12 @@ static inline struct damon_region *damon
 	return list_first_entry(&t->regions_list, struct damon_region, list);
 }
 
+static inline unsigned long damon_sz_region(struct damon_region *r)
+{
+	return r->ar.end - r->ar.start;
+}
+
+
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
 
--- a/mm/damon/core.c~mm-damon-move-sz_damon_region-to-damon_sz_region
+++ a/mm/damon/core.c
@@ -864,18 +864,13 @@ static void kdamond_apply_schemes(struct
 	}
 }
 
-static inline unsigned long sz_damon_region(struct damon_region *r)
-{
-	return r->ar.end - r->ar.start;
-}
-
 /*
  * Merge two adjacent regions into one region
  */
 static void damon_merge_two_regions(struct damon_target *t,
 		struct damon_region *l, struct damon_region *r)
 {
-	unsigned long sz_l = sz_damon_region(l), sz_r = sz_damon_region(r);
+	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
@@ -904,7 +899,7 @@ static void damon_merge_regions_of(struc
 
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
-		    sz_damon_region(prev) + sz_damon_region(r) <= sz_limit)
+		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
 			prev = r;
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch
mm-hugetlb-add-available_huge_pages-func.patch
mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

