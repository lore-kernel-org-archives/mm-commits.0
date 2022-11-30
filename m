Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D45C47089
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiK3XCp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK3XCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB8950E6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB4461E37
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1529C433D6;
        Wed, 30 Nov 2022 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849330;
        bh=vELS25PQcgv2HFpLymY3jtWA0ifEJlzqbCb+k8Cqrho=;
        h=Date:To:From:Subject:From;
        b=QfphSQn/dh2GW5EkbtDrv376yKh1Voy6SQcfYanGkkNVD39B5HlLsvhsm96xiUALZ
         K1aeLCOqsWcSv3sTcja9EEUrdMNn81JoVfWghVR7kZrJo1UHAo2HkCm/RHr3NbFAHw
         r9Ky5dFe//euKxYKjv29L5+jAMh25Ssf3ZFO2RXU=
Date:   Wed, 30 Nov 2022 15:02:10 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-enable-and-disable-synchronously.patch removed from -mm tree
Message-Id: <20221130230210.B1529C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: enable and disable synchronously
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-enable-and-disable-synchronously.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/damon/lru_sort.c |   51 ++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

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

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

