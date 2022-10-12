Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B041AC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJLW5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJLW5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654E41204FC
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E9B8B81BE0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA6DC433B5;
        Wed, 12 Oct 2022 22:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615445;
        bh=E4Eea9CK5SBLfvTv6UWzfkeSaYLTlBhcZwmzJpV3828=;
        h=Date:To:From:Subject:From;
        b=DncazHU9skgIcsiLLJhjsILV0Q5eP8wpTQ4WBlSh+tZKqWpTOUPBaRqpwpYQIrQPG
         RcrYy5Zh1gdVe4SGEbvHbZW9DNXi9cilocIUoIyW49S5psywnA72LKdKn4bDxPfMrU
         xiwcNhwNkq9OdlEZwEV0EsxMNuwbG5a5zAdq9bic=
Date:   Wed, 12 Oct 2022 15:57:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-move-sz_damon_region-to-damon_sz_region.patch removed from -mm tree
Message-Id: <20221012225725.BBA6DC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: move sz_damon_region to damon_sz_region
has been removed from the -mm tree.  Its filename was
     mm-damon-move-sz_damon_region-to-damon_sz_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |    9 ++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

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

mm-damon-use-damon_sz_region-in-appropriate-place.patch

