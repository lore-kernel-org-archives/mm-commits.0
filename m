Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC564C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiBOU6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:58:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244233AbiBOU6F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:58:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CEE096
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 358AEB81CEF
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD7AC340EB;
        Tue, 15 Feb 2022 20:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958671;
        bh=DkrcoimoVjqHVRe+4xqMupdb+2Jt9CePV+RtR8Z7Jnw=;
        h=Date:To:From:Subject:From;
        b=hk8bvOibq0bHQBvhza6N1mxyJVU1kPOZ3y1AENSaR3MIVDSM0g9rL8bPzA++j9p/r
         NEx3gpybSxEmUQodzyuJdFAqwt+H/QPh9B53ECjaw7xVSTGSlxWzVmkYiYLB4qsQCN
         mO5geTvqhwe45Oqdz3hapbVdYYsJbVwrB0p6VkEA=
Date:   Tue, 15 Feb 2022 12:57:51 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-test-fix-is_target_id-change.patch added to -mm tree
Message-Id: <20220215205751.CCD7AC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs-test: fix is_target_id() change
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-test-fix-is_target_id-change.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-test-fix-is_target_id-change.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-test-fix-is_target_id-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

