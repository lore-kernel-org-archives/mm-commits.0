Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECAFCCA473
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiFFTSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiFFTR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:17:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F5D8216B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671EA6145A
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC12DC34115;
        Mon,  6 Jun 2022 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654543073;
        bh=wlz/kc8slmc+dyLCiNsKqHjggw6PS5rSrPViPzDRGK0=;
        h=Date:To:From:Subject:From;
        b=QIzM2df6+pcv0G1ctKKLHC4RXZ3APtUmgDfXYMfVxk6w+5AuyDBKwvnDcWdsh/7sN
         1uQ5lV5DmecR2934fX4px6+oNb1eo9ofUWIcf1ipFbwuIeapiB4/kum4stl3yYhkWF
         gbSicb3MVzK6shKUZbaP1ZEU6THcqvtvvFl1Fxf4=
Date:   Mon, 06 Jun 2022 12:17:53 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-deduplicate-commit_inputs-handling.patch added to mm-unstable branch
Message-Id: <20220606191753.BC12DC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: deduplicate 'commit_inputs' handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-deduplicate-commit_inputs-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-deduplicate-commit_inputs-handling.patch

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
Subject: mm/damon/reclaim: deduplicate 'commit_inputs' handling
Date: Mon, 6 Jun 2022 18:23:07 +0000

DAMON_RECLAIM's handling of 'commit_inputs' parameter is duplicated in
'after_aggregation()' and 'after_wmarks_check()' callbacks.  This commit
deduplicates the code for better maintenance.

Link: https://lkml.kernel.org/r/20220606182310.48781-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-deduplicate-commit_inputs-handling
+++ a/mm/damon/reclaim.c
@@ -397,10 +397,21 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
+static int damon_reclaim_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_reclaim_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
 static int damon_reclaim_after_aggregation(struct damon_ctx *c)
 {
 	struct damos *s;
-	int err = 0;
 
 	/* update the stats parameter */
 	damon_for_each_scheme(s, c) {
@@ -411,22 +422,12 @@ static int damon_reclaim_after_aggregati
 		nr_quota_exceeds = s->stat.qt_exceeds;
 	}
 
-	if (commit_inputs) {
-		err = damon_reclaim_apply_parameters();
-		commit_inputs = false;
-	}
-	return err;
+	return damon_reclaim_handle_commit_inputs();
 }
 
 static int damon_reclaim_after_wmarks_check(struct damon_ctx *c)
 {
-	int err = 0;
-
-	if (commit_inputs) {
-		err = damon_reclaim_apply_parameters();
-		commit_inputs = false;
-	}
-	return err;
+	return damon_reclaim_handle_commit_inputs();
 }
 
 static int __init damon_reclaim_init(void)
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

