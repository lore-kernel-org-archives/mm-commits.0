Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B75EC6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiINWjR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINWjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B0B7F26B
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A19EDB81CE0
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA08C433D6;
        Wed, 14 Sep 2022 22:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195152;
        bh=7qibSSkCy5tV5Fn75SadsP7wYx6y/2PyhpSSs20hhqQ=;
        h=Date:To:From:Subject:From;
        b=XwqwPTsdHVqMhzjZ6MFz6fB+RjRPS09Lb0nt6MEwZMIRtydSNGccUvK0v7pUJPDXW
         HpS4hn4UxBuV/VzMBnQcIJpXRkNb97vQ3YPTf0GUsng9/YB4Xn1mIinCxrZFksioSJ
         cSGF+WbFTMTDE7goihbPL52Pg3eOMlSc8dGt5dzU=
Date:   Wed, 14 Sep 2022 15:39:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch removed from -mm tree
Message-Id: <20220914223912.4FA08C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: indicate the target is invalid when 'nr_regions' is zero
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/vaddr: indicate the target is invalid when 'nr_regions' is zero
Date: Tue, 13 Sep 2022 17:11:27 +0800

When 'init()' and 'update()' DAMON operations failed and the number of the
damon_target regions is zero, the kdamond would do nothing to this
monitoring target in this case.  It makes no sense to run kdamond when all
of monitoring targets have no regions.  So add the judgement in
'target_valid()' operation to indicate the target is invalid when
'nr_regions' is zero.

Link: https://lkml.kernel.org/r/1663060287-30201-5-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero
+++ a/mm/damon/vaddr.c
@@ -598,6 +598,9 @@ static bool damon_va_target_valid(void *
 	struct damon_target *t = target;
 	struct task_struct *task;
 
+	if (!damon_nr_regions(t))
+		return false;
+
 	task = damon_get_task_struct(t);
 	if (task) {
 		put_task_struct(task);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch

