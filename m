Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B7DC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343982AbjKGPlB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343981AbjKGPlB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:41:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F39B;
        Tue,  7 Nov 2023 07:40:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6404AC433C7;
        Tue,  7 Nov 2023 15:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371658;
        bh=5rnFSukwJIRJ3cAd95vUfvTVhOhAj4lx7vQh6OM6pAA=;
        h=Date:To:From:Subject:From;
        b=RWCuafvksmqeffuMHMAd91bUnYxxxl+rVGr15rmcItx71m2HkFgmz5cKSFXbGQMgp
         eiosOA4xmYs44DWExWT60u3p90bXT11ZnejOuNcJVVVVVZ0/C1ekv3Caso9KL//AcF
         RulO3gapmmCyHl5sHEX5iJmTizH92ir7Oz/uWBIU=
Date:   Tue, 07 Nov 2023 07:40:57 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch added to mm-hotfixes-unstable branch
Message-Id: <20231107154058.6404AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: check error from damon_sysfs_update_target()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/sysfs: check error from damon_sysfs_update_target()
Date: Mon, 6 Nov 2023 23:34:06 +0000

Patch series "mm/damon/sysfs: fix unhandled return values".

Some of DAMON sysfs interface code is not handling return values from some
functions.  As a result, confusing user input handling or NULL-dereference
is possible.  Check those properly.


This patch (of 3):

damon_sysfs_update_target() returns error code for failures, but its
caller, damon_sysfs_set_targets() is ignoring that.  The update function
seems making no critical change in case of such failures, but the behavior
will look like DAMON sysfs is silently ignoring or only partially
accepting the user input.  Fix it.

Link: https://lkml.kernel.org/r/20231106233408.51159-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231106233408.51159-2-sj@kernel.org
Fixes: 19467a950b49 ("mm/damon/sysfs: remove requested targets when online-commit inputs")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-check-error-from-damon_sysfs_update_target
+++ a/mm/damon/sysfs.c
@@ -1203,8 +1203,10 @@ static int damon_sysfs_set_targets(struc
 
 	damon_for_each_target_safe(t, next, ctx) {
 		if (i < sysfs_targets->nr) {
-			damon_sysfs_update_target(t, ctx,
+			err = damon_sysfs_update_target(t, ctx,
 					sysfs_targets->targets_arr[i]);
+			if (err)
+				return err;
 		} else {
 			if (damon_target_has_pid(ctx))
 				put_pid(t->pid);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch
mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch
mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch

