Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED361CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiGDBJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiGDBJg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183B16274
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4358B80CEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FECAC341C6;
        Mon,  4 Jul 2022 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896973;
        bh=LWPCojrnwiK7reBeDtsbnPMAXnQdIEyTC4tGOw+Gc3Y=;
        h=Date:To:From:Subject:From;
        b=2CAKZNXmTyB0maRmCI2sO843+sZGNxSSx9OiinlAEugXO08cbiuTryKk1U6QjU10+
         djQWvX8hBC7dhX8lRpJQcBWxzaRawWBEM9rvNf8ixjkfp08+Ck1OdFEf9IniFEqxdH
         C4tREyXz8EaDIdSy+sYVriWu5khVSEwjbyxLYkxw=
Date:   Sun, 03 Jul 2022 18:09:32 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-make-enabled-checking-timer-simpler.patch removed from -mm tree
Message-Id: <20220704010933.6FECAC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: make 'enabled' checking timer simpler
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-make-enabled-checking-timer-simpler.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: make 'enabled' checking timer simpler
Date: Mon, 6 Jun 2022 18:23:09 +0000

DAMON_RECLAIM's 'enabled' parameter store callback ('enabled_store()')
schedules the parameter check timer ('damon_reclaim_timer') if the
parameter is set as 'Y'.  Then, the timer schedules itself to check if
user has set the parameter as 'N'.  It's unnecessarily complex.

This commit makes it simpler by making the parameter store callback to
schedule the timer regardless of the parameter value and disabling the
timer's self scheduling.

Link: https://lkml.kernel.org/r/20220606182310.48781-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-make-enabled-checking-timer-simpler
+++ a/mm/damon/reclaim.c
@@ -353,7 +353,6 @@ static int damon_reclaim_turn(bool on)
 	return 0;
 }
 
-#define ENABLE_CHECK_INTERVAL_MS	1000
 static struct delayed_work damon_reclaim_timer;
 static void damon_reclaim_timer_fn(struct work_struct *work)
 {
@@ -367,10 +366,6 @@ static void damon_reclaim_timer_fn(struc
 		else
 			enabled = last_enabled;
 	}
-
-	if (enabled)
-		schedule_delayed_work(&damon_reclaim_timer,
-			msecs_to_jiffies(ENABLE_CHECK_INTERVAL_MS));
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
@@ -388,9 +383,7 @@ static int enabled_store(const char *val
 	if (!damon_reclaim_initialized)
 		return rc;
 
-	if (enabled)
-		schedule_delayed_work(&damon_reclaim_timer, 0);
-
+	schedule_delayed_work(&damon_reclaim_timer, 0);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

