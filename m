Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59F7C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJCVNI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403352092
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA21611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A24C433D7;
        Mon,  3 Oct 2022 21:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831253;
        bh=RDmxGzXFtmZV6R8zDNim+99MzdVfBkA2A3Y422N4dfk=;
        h=Date:To:From:Subject:From;
        b=LWU0pc8e/feyGeqn1QjCgSGDfhOWp2i4ZXlPgftytLgK7JjVXdSpjwqa6sxVs0vxD
         ewLdjTZENqiLy5vHaJWOMCk3lU4XV08D46hY1RUqpp8SMAOheBP3kVKWZahDi0ahQE
         RNMXB28GsJ5ToBn1Lmw3nKO5u2c8nk8B7sNFaYuI=
Date:   Mon, 03 Oct 2022 14:07:32 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-common-implement-damos-time-quota-params-generator.patch removed from -mm tree
Message-Id: <20221003210732.E2A24C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/modules-common: implement damos time quota params generator
has been removed from the -mm tree.  Its filename was
     mm-damon-modules-common-implement-damos-time-quota-params-generator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/modules-common: implement damos time quota params generator
Date: Tue, 13 Sep 2022 17:44:46 +0000

DAMON_LRU_SORT have module parameters for DAMOS time quota only but size
quota.  This commit implements a macro for generating the module
parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-20-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-damos-time-quota-params-generator
+++ a/mm/damon/modules-common.h
@@ -17,12 +17,15 @@
 	module_param_named(max_nr_regions, attrs.max_nr_regions, ulong,	\
 			0600);
 
-#define DEFINE_DAMON_MODULES_DAMOS_QUOTAS(quota)			\
+#define DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(quota)			\
 	module_param_named(quota_ms, quota.ms, ulong, 0600);		\
-	module_param_named(quota_sz, quota.sz, ulong, 0600);		\
 	module_param_named(quota_reset_interval_ms,			\
 			quota.reset_interval, ulong, 0600);
 
+#define DEFINE_DAMON_MODULES_DAMOS_QUOTAS(quota)			\
+	DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(quota)			\
+	module_param_named(quota_sz, quota.sz, ulong, 0600);
+
 #define DEFINE_DAMON_MODULES_WMARKS_PARAMS(wmarks)			\
 	module_param_named(wmarks_interval, wmarks.interval, ulong,	\
 			0600);						\
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

