Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210F7C32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIOVZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIOVZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835BE47B9A
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C046626A2
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62736C433D6;
        Thu, 15 Sep 2022 21:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277124;
        bh=J/IZcemRNUTACJSNN7sinoO7El0Tg3m10tmLXVk3KeQ=;
        h=Date:To:From:Subject:From;
        b=oN1jwU+cDd/5vi82Wi8licZAcV5nXkkKL/vZy840WYo5X+xMOeJ6wbirGWX4V98rd
         HouMAjB9qt4etHmlQxBGDYEvgOgx0lcqLAvjXpKp7olDZSXM208aFiTZP4Ctu64mpG
         WsSy1gkdYv7goJ5ovp9d2XN7KoGUYct3B3CO++Ts=
Date:   Thu, 15 Sep 2022 14:25:23 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch added to mm-unstable branch
Message-Id: <20220915212524.62736C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch

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
Subject: mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly
Date: Thu, 15 Sep 2022 22:22:36 +0800

In damon_sysfs_destroy_targets(), we call damon_target_has_pid() to check
whether the 'ctx' include a valid pid, but there no need to call
damon_target_has_pid() to check repeatedly, just need call it once.

Link: https://lkml.kernel.org/r/20220915142237.92529-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly
+++ a/mm/damon/sysfs.c
@@ -2143,9 +2143,13 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
+	bool has_pid = false;
+
+	if (damon_target_has_pid(ctx))
+		has_pid = true;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (damon_target_has_pid(ctx))
+		if (has_pid)
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-core-remove-duplicate-check-about-thp.patch

