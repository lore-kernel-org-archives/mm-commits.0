Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63712CA0EC3
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbjILCmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240098AbjILCl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:41:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3354104894
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 19:07:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C725C433AB;
        Mon, 11 Sep 2023 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466398;
        bh=5gQG1NNW6euMtArj4E4lkK1X+wSjwxy2NOUul0Plzu0=;
        h=Date:To:From:Subject:From;
        b=0XT9567XPw7pC1J9TwY11rYbZUAtFypu9XFHMEwVtV66DWhll3VAfz0cccVx6rY5k
         R+5qztJ9XTLwwHz7iMW0EVn0UyDdnn71gyuSRie/Bn4lhfNckQLNH/7v4GSxfd8IXZ
         AE2ZtvBwkQmqWlaW3/JdFOM7VlmE65bYmu0e4a3Q=
Date:   Mon, 11 Sep 2023 14:06:37 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, axboe@kernel.dk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + task_work-add-kerneldoc-annotation-for-data-argument.patch added to mm-hotfixes-unstable branch
Message-Id: <20230911210638.3C725C433AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: task_work: add kerneldoc annotation for 'data' argument
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     task_work-add-kerneldoc-annotation-for-data-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_work-add-kerneldoc-annotation-for-data-argument.patch

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
From: Jens Axboe <axboe@kernel.dk>
Subject: task_work: add kerneldoc annotation for 'data' argument
Date: Mon, 11 Sep 2023 14:24:06 -0600

A previous commit changed the arguments to task_work_cancel_match(), but
didn't document all of them.

Link: https://lkml.kernel.org/r/93938bff-baa3-4091-85f5-784aae297a07@kernel.dk
Fixes: c7aab1a7c52b ("task_work: add helper for more targeted task_work canceling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309120307.zis3yQGe-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/task_work.c~task_work-add-kerneldoc-annotation-for-data-argument
+++ a/kernel/task_work.c
@@ -78,6 +78,7 @@ int task_work_add(struct task_struct *ta
  * task_work_cancel_match - cancel a pending work added by task_work_add()
  * @task: the task which should execute the work
  * @match: match function to call
+ * @data: data to be passed in to match function
  *
  * RETURNS:
  * The found work or NULL if not found.
_

Patches currently in -mm which might be from axboe@kernel.dk are

task_work-add-kerneldoc-annotation-for-data-argument.patch

