Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1100BC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJCVNI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FC151A2C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C77EC6118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F7FC433C1;
        Mon,  3 Oct 2022 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831235;
        bh=TidA4yAdL4irhp/5/WwvRAd5/qTHVyoiG6HAGkeawBE=;
        h=Date:To:From:Subject:From;
        b=YI2EV5XUBSDGnhDh10I+Z8oW1o9nTGJsCY1/UCzb0HRsnkUd4iJrgR3EkDS9eYqlW
         lSuWvhCWesD+Rf59ZplblyQPId0oUPM+cCUwmPO+iIMdVtBg2Kos46YZhMsva+Asy4
         69qfq8qCyc7P95QYf66m0JykR+LgrTPOu1wa0CGI=
Date:   Mon, 03 Oct 2022 14:07:14 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch removed from -mm tree
Message-Id: <20221003210715.26F7FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: copy struct-to-struct instead of field-to-field in damon_new_scheme()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: copy struct-to-struct instead of field-to-field in damon_new_scheme()
Date: Tue, 13 Sep 2022 17:44:30 +0000

The function for new 'struct damos' creation, 'damon_new_scheme()', copies
each field of the struct one by one, though it could simply copied via
struct to struct.  This commit replaces the unnecessarily verbose
field-to-field copies with struct-to-struct copies to make code simple and
short.

Link: https://lkml.kernel.org/r/20220913174449.50645-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme
+++ a/mm/damon/core.c
@@ -272,22 +272,13 @@ struct damos *damon_new_scheme(struct da
 	scheme = kmalloc(sizeof(*scheme), GFP_KERNEL);
 	if (!scheme)
 		return NULL;
-	scheme->pattern.min_sz_region = pattern->min_sz_region;
-	scheme->pattern.max_sz_region = pattern->max_sz_region;
-	scheme->pattern.min_nr_accesses = pattern->min_nr_accesses;
-	scheme->pattern.max_nr_accesses = pattern->max_nr_accesses;
-	scheme->pattern.min_age_region = pattern->min_age_region;
-	scheme->pattern.max_age_region = pattern->max_age_region;
+	scheme->pattern = *pattern;
 	scheme->action = action;
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota.ms = quota->ms;
-	scheme->quota.sz = quota->sz;
-	scheme->quota.reset_interval = quota->reset_interval;
-	scheme->quota.weight_sz = quota->weight_sz;
-	scheme->quota.weight_nr_accesses = quota->weight_nr_accesses;
-	scheme->quota.weight_age = quota->weight_age;
+	scheme->quota = *quota;
+	/* caller might not zero-initialized the private fileds */
 	scheme->quota.total_charged_sz = 0;
 	scheme->quota.total_charged_ns = 0;
 	scheme->quota.esz = 0;
@@ -296,11 +287,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->quota.charge_target_from = NULL;
 	scheme->quota.charge_addr_from = 0;
 
-	scheme->wmarks.metric = wmarks->metric;
-	scheme->wmarks.interval = wmarks->interval;
-	scheme->wmarks.high = wmarks->high;
-	scheme->wmarks.mid = wmarks->mid;
-	scheme->wmarks.low = wmarks->low;
+	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
 
 	return scheme;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

