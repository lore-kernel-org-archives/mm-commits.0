Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380B0C6FA89
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIMWPC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIMWPA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:15:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BECDF90
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF61B810F7
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B91C433D6;
        Tue, 13 Sep 2022 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663107294;
        bh=b9HQWKUWqyX5MDLCERIyZloy4UdW6SVpkUZwdlwhbNE=;
        h=Date:To:From:Subject:From;
        b=fjJ9ae75cVnK/mkPOlUiCRi72klQpupkPd5EZjxabf3YO+FFfY/aM6ZTn24jNsy1t
         m7SuKgjX8ZYldqstkIFpFNYA6w1KK94LogQJ95ybszaFgyWIV21e78DaxeeYPbNBi4
         T6T2zUZyjwJlzrfo1d8w2YjOp/8b42Ah0MUN5I1Y=
Date:   Tue, 13 Sep 2022 15:14:54 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch added to mm-unstable branch
Message-Id: <20220913221454.D7B91C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: indicate the target is invalid when 'nr_regions' is zero
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

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
mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

