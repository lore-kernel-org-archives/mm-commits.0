Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2B5C32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIOV0w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIOV0v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:26:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A574A51A3C
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A3F1B8226E
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076C2C433D6;
        Thu, 15 Sep 2022 21:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277208;
        bh=C2cMB52D0WIooGFQReYlfNMW95sNEre3pfmeWsceZdk=;
        h=Date:To:From:Subject:From;
        b=gzVGiFjzaCcGUUkoQv+KBG1A0/A0f8YKGF/qP8kMdnfSumaqKm5GVAjgTFHjUaBEH
         fe4fIXQXu0bUw4FazAIQJo4m6M1+0YNTTczGRyGBt917/md9zEsRAaxn+w9ECyt7am
         CCmuK7UvcFejl7CsDHVy8l0hiIyVprvvv+E60iwo=
Date:   Thu, 15 Sep 2022 14:26:47 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch added to mm-unstable branch
Message-Id: <20220915212648.076C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: use 'struct damon_target *' instead of 'void *' in target_valid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch

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
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: use 'struct damon_target *' instead of 'void *' in target_valid()
Date: Thu, 15 Sep 2022 19:33:41 +0800

We could use 'struct damon_target *' directly instead of 'void *' in
target_valid() operation to make code simple.

Link: https://lkml.kernel.org/r/1663241621-13293-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/vaddr.c      |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-use-struct-damon_target-instead-of-void-in-target_valid
+++ a/include/linux/damon.h
@@ -346,7 +346,7 @@ struct damon_operations {
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
-	bool (*target_valid)(void *target);
+	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
 
--- a/mm/damon/vaddr.c~mm-damon-use-struct-damon_target-instead-of-void-in-target_valid
+++ a/mm/damon/vaddr.c
@@ -591,9 +591,8 @@ static unsigned int damon_va_check_acces
  * Functions for the target validity check and cleanup
  */
 
-static bool damon_va_target_valid(void *target)
+static bool damon_va_target_valid(struct damon_target *t)
 {
-	struct damon_target *t = target;
 	struct task_struct *task;
 
 	task = damon_get_task_struct(t);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch

