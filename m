Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA344C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKIBme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiKIBkd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30F3686A9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E220B81CD6
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B6FC433B5;
        Wed,  9 Nov 2022 01:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957991;
        bh=UPrAYE+Zu0bme9v28l/ewMNMn8NtFxiFhuqAjV74cVI=;
        h=Date:To:From:Subject:From;
        b=VcrGmGTnvYXmrmGsU15KN4RE0L/rk0AqsNsnZTVE9oADtxYQSwNUTRt9QPL891JAQ
         YeBhJ35mmUsxCgfPIWfGQKLabg2E208aicVFnavj7ZmI+3kJKZFrX2k+hMt8w73AhV
         jMPM3alt5Cu8jHCOWAOgbU+HtMFpyVL+dlxNIGL0=
Date:   Tue, 08 Nov 2022 17:39:50 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-enable-and-disable-synchronously.patch removed from -mm tree
Message-Id: <20221109013951.25B6FC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: enable and disable synchronously
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-enable-and-disable-synchronously.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: enable and disable synchronously
Date: Tue, 25 Oct 2022 17:36:47 +0000

Patch series "mm/damon/reclaim,lru_sort: enable/disable synchronously".

Writing a value to DAMON_RECLAIM and DAMON_LRU_SORT's 'enabled' parameters
turns on or off DAMON in an ansychronous way.  This means the parameter
cannot be used to read the current status of them.  'kdamond_pid'
parameter should be used instead for the purpose.  The documentation is
easy to be read as it works in a synchronous way, so it is a little bit
confusing.  It also makes the user space tooling dirty.

There's no real reason to have the asynchronous behavior, though.  Simply
make the parameter works synchronously, rather than updating the document.

The first and second patches changes the behavior of the 'enabled'
parameter for DAMON_RECLAIM and adds a selftest for the changed behavior,
respectively.  Following two patches make the same changes for
DAMON_LRU_SORT.


This patch (of 4):

Writing a value to DAMON_RECLAIM's 'enabled' parameter turns on or off
DAMON in an ansychronous way.  This means the parameter cannot be used to
read the current status of DAMON_RECLAIM.  'kdamond_pid' parameter should
be used instead for the purpose.  The documentation is easy to be read as
it works in a synchronous way, so it is a little bit confusing.  It also
makes the user space tooling dirty.

There's no real reason to have the asynchronous behavior, though.  Simply
make the parameter works synchronously, rather than updating the document.

Link: https://lkml.kernel.org/r/20221025173650.90624-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221025173650.90624-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   53 ++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-enable-and-disable-synchronously
+++ a/mm/damon/reclaim.c
@@ -9,7 +9,6 @@
 
 #include <linux/damon.h>
 #include <linux/module.h>
-#include <linux/workqueue.h>
 
 #include "modules-common.h"
 
@@ -181,38 +180,31 @@ static int damon_reclaim_turn(bool on)
 	return 0;
 }
 
-static struct delayed_work damon_reclaim_timer;
-static void damon_reclaim_timer_fn(struct work_struct *work)
-{
-	static bool last_enabled;
-	bool now_enabled;
-
-	now_enabled = enabled;
-	if (last_enabled != now_enabled) {
-		if (!damon_reclaim_turn(now_enabled))
-			last_enabled = now_enabled;
-		else
-			enabled = last_enabled;
-	}
-}
-static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
-
-static bool damon_reclaim_initialized;
-
 static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-	int rc = param_set_bool(val, kp);
+	bool is_enabled = enabled;
+	bool enable;
+	int err;
+
+	err = strtobool(val, &enable);
+	if (err)
+		return err;
 
-	if (rc < 0)
-		return rc;
+	if (is_enabled == enable)
+		return 0;
 
-	/* system_wq might not initialized yet */
-	if (!damon_reclaim_initialized)
-		return rc;
+	/* Called before init function.  The function will handle this. */
+	if (!ctx)
+		goto set_param_out;
 
-	schedule_delayed_work(&damon_reclaim_timer, 0);
-	return 0;
+	err = damon_reclaim_turn(enable);
+	if (err)
+		return err;
+
+set_param_out:
+	enabled = enable;
+	return err;
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
@@ -262,10 +254,11 @@ static int __init damon_reclaim_init(voi
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
-	schedule_delayed_work(&damon_reclaim_timer, 0);
+	/* 'enabled' has set before this function, probably via command line */
+	if (enabled)
+		err = damon_reclaim_turn(true);
 
-	damon_reclaim_initialized = true;
-	return 0;
+	return err;
 }
 
 module_init(damon_reclaim_init);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

