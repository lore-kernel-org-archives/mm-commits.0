Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639F2C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJZCOI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiJZCOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F0D8F6C
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82EAA61C5B
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A41C433D6;
        Wed, 26 Oct 2022 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666750445;
        bh=gTTfKecNb6NPdAF3sy4nzr6L5THEuEJElqSaELSIBiw=;
        h=Date:To:From:Subject:From;
        b=LQ74Er9ZZmEJM1c4/GwcrmdP81m5H9Mj8rMOoA3LecnsP3MROxIjsZ1g54J1smd5l
         3r57xNJGGLxgP/B1O14KJF/QQvis6ZYcKe72juZ97Cvf0zCcze0fKk+Ch0IAwNEtsR
         PNJ+YTqHcBBmMTyn1TADs6r0Xv56glZuVu4a9OdM=
Date:   Tue, 25 Oct 2022 19:14:04 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-enable-and-disable-synchronously.patch added to mm-unstable branch
Message-Id: <20221026021405.C3A41C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: enable and disable synchronously
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-enable-and-disable-synchronously.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-enable-and-disable-synchronously.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: enable and disable synchronously
Date: Tue, 25 Oct 2022 17:36:49 +0000

Writing a value to DAMON_RECLAIM's 'enabled' parameter turns on or off
DAMON in an ansychronous way.  This means the parameter cannot be used to
read the current status of DAMON_RECLAIM.  'kdamond_pid' parameter should
be used instead for the purpose.  The documentation is easy to be read as
it works in a synchronous way, so it is a little bit confusing.  It also
makes the user space tooling dirty.

There's no real reason to have the asynchronous behavior, though.  Simply
make the parameter works synchronously, rather than updating the document.

Link: https://lkml.kernel.org/r/20221025173650.90624-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-enable-and-disable-synchronously
+++ a/mm/damon/lru_sort.c
@@ -9,7 +9,6 @@
 
 #include <linux/damon.h>
 #include <linux/module.h>
-#include <linux/workqueue.h>
 
 #include "modules-common.h"
 
@@ -235,38 +234,31 @@ static int damon_lru_sort_turn(bool on)
 	return 0;
 }
 
-static struct delayed_work damon_lru_sort_timer;
-static void damon_lru_sort_timer_fn(struct work_struct *work)
-{
-	static bool last_enabled;
-	bool now_enabled;
-
-	now_enabled = enabled;
-	if (last_enabled != now_enabled) {
-		if (!damon_lru_sort_turn(now_enabled))
-			last_enabled = now_enabled;
-		else
-			enabled = last_enabled;
-	}
-}
-static DECLARE_DELAYED_WORK(damon_lru_sort_timer, damon_lru_sort_timer_fn);
-
-static bool damon_lru_sort_initialized;
-
 static int damon_lru_sort_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-	int rc = param_set_bool(val, kp);
+	bool is_enabled = enabled;
+	bool enable;
+	int err;
 
-	if (rc < 0)
-		return rc;
+	err = strtobool(val, &enable);
+	if (err)
+		return err;
 
-	if (!damon_lru_sort_initialized)
-		return rc;
+	if (is_enabled == enable)
+		return 0;
 
-	schedule_delayed_work(&damon_lru_sort_timer, 0);
+	/* Called before init function.  The function will handle this. */
+	if (!ctx)
+		goto set_param_out;
 
-	return 0;
+	err = damon_lru_sort_turn(enable);
+	if (err)
+		return err;
+
+set_param_out:
+	enabled = enable;
+	return err;
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
@@ -320,10 +312,11 @@ static int __init damon_lru_sort_init(vo
 	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
 
-	schedule_delayed_work(&damon_lru_sort_timer, 0);
+	/* 'enabled' has set before this function, probably via command line */
+	if (enabled)
+		err = damon_lru_sort_turn(true);
 
-	damon_lru_sort_initialized = true;
-	return 0;
+	return err;
 }
 
 module_init(damon_lru_sort_init);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch

