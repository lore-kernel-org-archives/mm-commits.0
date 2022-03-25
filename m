Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8A6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355246AbiCYBgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357441AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB653286E5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB8DB82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1757DC340ED;
        Fri, 25 Mar 2022 01:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171999;
        bh=YYXz3u/zEZ9ptK0MYe36aninSZojSKF96hXi+JqNPVs=;
        h=Date:To:From:Subject:From;
        b=o9eWOKLO9BXT1KYRUyG6KYJ3ruMFSnCO/7+z8e+hKqCCbm6/5glCtLEVNuhUjDw09
         yP+CAv1WIRBIkXk8hWqsuZp/ghxRGnBwLrx5NEize3rv7mzevaeUAHIwfzMuA1nyTG
         sLsZnTwfAV2p/RHs6fEbE6tVb07VQtZkKEM6+vII=
Date:   Thu, 24 Mar 2022 18:33:18 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-dbgfs-test-fix-is_target_id-change.patch removed from -mm tree
Message-Id: <20220325013319.1757DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs-test: fix is_target_id() change
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-test-fix-is_target_id-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs-test: fix is_target_id() change

DAMON kunit tests for DAMON debugfs interface fails because it still
assumes setting empty monitoring operations makes DAMON debugfs interface
believe the target of the context don't have pid.  This commit fixes the
kunit test fails by explicitly setting the context's monitoring operations
with the operations for the physical address space, which let debugfs
knows the target will not have pid.

Link: https://lkml.kernel.org/r/20220215184603.1479-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-test-fix-is_target_id-change
+++ a/mm/damon/dbgfs-test.h
@@ -74,7 +74,7 @@ static void damon_dbgfs_test_set_targets
 	char buf[64];
 
 	/* Make DAMON consider target has no pid */
-	ctx->ops = (struct damon_operations){};
+	damon_select_ops(ctx, DAMON_OPS_PADDR);
 
 	dbgfs_set_targets(ctx, 0, NULL);
 	sprint_target_ids(ctx, buf, 64);
@@ -111,6 +111,8 @@ static void damon_dbgfs_test_set_init_re
 	int i, rc;
 	char buf[256];
 
+	damon_select_ops(ctx, DAMON_OPS_PADDR);
+
 	dbgfs_set_targets(ctx, 3, NULL);
 
 	/* Put valid inputs and check the results */
_

Patches currently in -mm which might be from sj@kernel.org are


