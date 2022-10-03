Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C43C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJCVOU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91952095
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D427B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB2EC433C1;
        Mon,  3 Oct 2022 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831251;
        bh=uQfa7jBX7nngEr6KSELgua1au989LAookNeezAkpSNQ=;
        h=Date:To:From:Subject:From;
        b=yQI+IRvMnfCWYDoMDrIyKEvxE2izeBA+AxtpbJy8JK3fSSBPz+CZ9VNbtz6SLWXTQ
         wdgmYO612X9uQ707qd+m8wymXUUZXeFfNxG0NQ/mFM165rsgx9TBCpcfdL7u0sG7x5
         4bB7Urz8FDOyNun+O82naFWkySfgPMRQRIVJrU8k=
Date:   Mon, 03 Oct 2022 14:07:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-common-implement-a-damos-quota-params-generator.patch removed from -mm tree
Message-Id: <20221003210731.CDB2EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/modules-common: implement a damos quota params generator
has been removed from the -mm tree.  Its filename was
     mm-damon-modules-common-implement-a-damos-quota-params-generator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/modules-common: implement a damos quota params generator
Date: Tue, 13 Sep 2022 17:44:45 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for DAMOS quotas
that having same names.  This commit implements a macro for generating
such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-a-damos-quota-params-generator
+++ a/mm/damon/modules-common.h
@@ -17,6 +17,12 @@
 	module_param_named(max_nr_regions, attrs.max_nr_regions, ulong,	\
 			0600);
 
+#define DEFINE_DAMON_MODULES_DAMOS_QUOTAS(quota)			\
+	module_param_named(quota_ms, quota.ms, ulong, 0600);		\
+	module_param_named(quota_sz, quota.sz, ulong, 0600);		\
+	module_param_named(quota_reset_interval_ms,			\
+			quota.reset_interval, ulong, 0600);
+
 #define DEFINE_DAMON_MODULES_WMARKS_PARAMS(wmarks)			\
 	module_param_named(wmarks_interval, wmarks.interval, ulong,	\
 			0600);						\
@@ -33,5 +39,5 @@
 			0400);						\
 	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
 			0400);						\
-	module_param_named(qt_exceed_name, stat.qt_exceeds, ulong,	\
+	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

