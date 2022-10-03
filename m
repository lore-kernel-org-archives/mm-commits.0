Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB432C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJCVOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DB351A2D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F0BB815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45292C433D7;
        Mon,  3 Oct 2022 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831236;
        bh=R9LLVjd6dW7Y3LP6BSzzq8bb1UHcGllY1XSxK/sMYLA=;
        h=Date:To:From:Subject:From;
        b=VR6PDTAdCiEv604Wk30aHT5Jd+TLhgsfRrCTeSMaH19sL784ffTrpWd0HzfVbUMVX
         NOjCFCJ0Bjoq8MCuXahuGqbbGUSF3ZUszI0PGPBfp6OGmV5LzSLb7g6nKOoUqhLZMJ
         krv3hVEmeAbqZCcmDYLuAm75fd/XkNTzDamH7/MI=
Date:   Mon, 03 Oct 2022 14:07:15 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch removed from -mm tree
Message-Id: <20221003210716.45292C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: factor out 'damos_quota' private fileds initialization
has been removed from the -mm tree.  Its filename was
     mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: factor out 'damos_quota' private fileds initialization
Date: Tue, 13 Sep 2022 17:44:31 +0000

The 'struct damos' creation function, 'damon_new_scheme()', does
initialization of private fileds of 'struct damos_quota' in it.  As its
verbose and makes the function unnecessarily long, this commit factors it
out to separate function.

Link: https://lkml.kernel.org/r/20220913174449.50645-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-factor-out-damos_quota-private-fileds-initialization
+++ a/mm/damon/core.c
@@ -263,6 +263,19 @@ int damon_set_regions(struct damon_targe
 	return 0;
 }
 
+/* initialize private fields of damos_quota and return the pointer */
+static struct damos_quota *damos_quota_init_priv(struct damos_quota *quota)
+{
+	quota->total_charged_sz = 0;
+	quota->total_charged_ns = 0;
+	quota->esz = 0;
+	quota->charged_sz = 0;
+	quota->charged_from = 0;
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+	return quota;
+}
+
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 			enum damos_action action, struct damos_quota *quota,
 			struct damos_watermarks *wmarks)
@@ -277,15 +290,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *quota;
-	/* caller might not zero-initialized the private fileds */
-	scheme->quota.total_charged_sz = 0;
-	scheme->quota.total_charged_ns = 0;
-	scheme->quota.esz = 0;
-	scheme->quota.charged_sz = 0;
-	scheme->quota.charged_from = 0;
-	scheme->quota.charge_target_from = NULL;
-	scheme->quota.charge_addr_from = 0;
+	scheme->quota = *(damos_quota_init_priv(quota));
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

