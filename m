Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068F3C6FA83
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 19:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiILTP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiILTP2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 15:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093DC1EED2
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 12:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AD7A61257
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 19:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744E5C433C1;
        Mon, 12 Sep 2022 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663010125;
        bh=J3x1HTp+2BAwco+0ftg4OMmgHNFjWfZtWOPP4JoDo20=;
        h=Date:To:From:Subject:From;
        b=vMtjman1/X1SPE8u/i24B9X8TcAshGgxrn1jGI+f/UaCCuOiImy8SlJUXAGRj/NuK
         j2Cc3HVceB4NAhfSSetZsakXRNEjxGHY1nMbmrp4tDknahn5Xzby5dsA6rM8Y+7okj
         OxlHGRyne6Kef4qBkCKW43GonAjLNLcOnZYXpFZs=
Date:   Mon, 12 Sep 2022 12:15:24 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch added to mm-unstable branch
Message-Id: <20220912191525.744E5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: use the wrapper directly to check if the kdamond is running
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch

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
Subject: mm/damon/sysfs: use the wrapper directly to check if the kdamond is running
Date: Mon, 12 Sep 2022 23:11:53 +0800

We can use the 'damon_sysfs_kdamond_running()' wrapper directly to check
if the kdamond is running in 'damon_sysfs_turn_damon_on()'.

Link: https://lkml.kernel.org/r/1662995513-24489-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running
+++ a/mm/damon/sysfs.c
@@ -2465,8 +2465,7 @@ static int damon_sysfs_turn_damon_on(str
 	struct damon_ctx *ctx;
 	int err;
 
-	if (kdamond->damon_ctx &&
-			damon_sysfs_ctx_running(kdamond->damon_ctx))
+	if (damon_sysfs_kdamond_running(kdamond))
 		return -EBUSY;
 	if (damon_sysfs_cmd_request.kdamond == kdamond)
 		return -EBUSY;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch

