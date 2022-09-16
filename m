Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18911ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 19:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiIPT6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 15:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIPT6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 15:58:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C813B728F
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 12:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E523B82919
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 19:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4417C433D6;
        Fri, 16 Sep 2022 19:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358306;
        bh=ThI8bh1hp7l9QeqU0PY3R92+ZKWOosthb1kqXKEAcsM=;
        h=Date:To:From:Subject:From;
        b=iZFt/C/piRjoGB1Jr8rMQuFtD7l+hSCz1Sbv4ISHhBRqouaDMQ0TCYJ39N7UEdv0m
         jWaXoMIK6C2sU+1lbKPA/Fc5SPwLvggTsnoJI/PL0kKCZrn9CkvyHrhjlcQCyP9EyV
         kXPuS/R2VdId+mHY/o4YKs0oj8rGZX9zmH40Wg9c=
Date:   Fri, 16 Sep 2022 12:58:26 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-more-simplified-code-calls-damon_target_has_pid.patch added to mm-unstable branch
Message-Id: <20220916195826.D4417C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: more simplified code calls damon_target_has_pid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-more-simplified-code-calls-damon_target_has_pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-more-simplified-code-calls-damon_target_has_pid.patch

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
Subject: mm/damon/sysfs: more simplified code calls damon_target_has_pid()
Date: Fri, 16 Sep 2022 21:35:35 +0800

This patch further simplifies the damon_target_has_pid() call and makes
the damon_sysfs_destroy_targets() look cleaner.

Link: https://lkml.kernel.org/r/20220916133535.7428-1-xhao@linux.alibaba.com
Fixes: 49fb890735ab (mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly)
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-more-simplified-code-calls-damon_target_has_pid
+++ a/mm/damon/sysfs.c
@@ -2143,10 +2143,7 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
-	bool has_pid = false;
-
-	if (damon_target_has_pid(ctx))
-		has_pid = true;
+	bool has_pid = damon_target_has_pid(ctx);
 
 	damon_for_each_target_safe(t, next, ctx) {
 		if (has_pid)
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-sysfs-more-simplified-code-calls-damon_target_has_pid.patch

