Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE96FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiEJEWw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9EB393E3
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2D761771
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE075C385C5;
        Tue, 10 May 2022 04:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156153;
        bh=+WIYQ6/OAHbU0Qm8PJATfc2XAqfaGGxBVqcQwX81Tco=;
        h=Date:To:From:Subject:From;
        b=Qmf57OFwg0d07oCiT674CNyC/w/+0/ZbA0ollC4mf/Vmpfc5h9+sFAL8TooUfFjeY
         9mlX2fdka6pMF42og8DD8C/Z+ZVh0iDqB8U3s5HYN8QVSGU6d8fZb947nTbKv61ZWy
         GvrFqKbQZbh+aiEuwCoWOQF9D9tly9ZPjmcscLiY=
Date:   Mon, 09 May 2022 21:15:53 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch removed from -mm tree
Message-Id: <20220510041553.AE075C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: reuse damon_set_regions() for regions setting
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: reuse damon_set_regions() for regions setting

'damon_set_regions()' is general enough so that it can also be used for
only creating regions.  This commit makes DAMON sysfs interface to reuse
the function rather keeping two implementations for a same purpose.

Link: https://lkml.kernel.org/r/20220429160606.127307-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting
+++ a/mm/damon/sysfs.c
@@ -2096,28 +2096,31 @@ static void damon_sysfs_destroy_targets(
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions)
 {
-	int i;
+	struct damon_addr_range *ranges = kmalloc_array(sysfs_regions->nr,
+			sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
+	int i, err = -EINVAL;
 
+	if (!ranges)
+		return -ENOMEM;
 	for (i = 0; i < sysfs_regions->nr; i++) {
 		struct damon_sysfs_region *sys_region =
 			sysfs_regions->regions_arr[i];
-		struct damon_region *prev, *r;
 
 		if (sys_region->start > sys_region->end)
-			return -EINVAL;
-		r = damon_new_region(sys_region->start, sys_region->end);
-		if (!r)
-			return -ENOMEM;
-		damon_add_region(r, t);
-		if (damon_nr_regions(t) > 1) {
-			prev = damon_prev_region(r);
-			if (prev->ar.end > r->ar.start) {
-				damon_destroy_region(r, t);
-				return -EINVAL;
-			}
-		}
+			goto out;
+
+		ranges[i].start = sys_region->start;
+		ranges[i].end = sys_region->end;
+		if (i == 0)
+			continue;
+		if (ranges[i - 1].end > ranges[i].start)
+			goto out;
 	}
-	return 0;
+	err = damon_set_regions(t, ranges, sysfs_regions->nr);
+out:
+	kfree(ranges);
+	return err;
+
 }
 
 static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
_

Patches currently in -mm which might be from sj@kernel.org are


