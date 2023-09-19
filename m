Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67383CE79A9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjISUWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjISUWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE16BA
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D4CC433C9;
        Tue, 19 Sep 2023 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154925;
        bh=W+w5Y6EYsp3G/zJcY+rB34h0vmG5tIgNX/jZ8Tuz58s=;
        h=Date:To:From:Subject:From;
        b=Vw61rw+C7uj/9tYcQJxJVlAYcgF8imIl4lB8CZ/zHM3MiFYLwy209KZv0Ta18BjiQ
         jqK7x+5loAADKKkrqmScDXAT2SglQw9eb51t98TZy13LFt8qdHsO5kEszZPW5dETeE
         7kPL+HLshC005jz+AOsbxWsH/O3Yg0M5pd8sfZQI=
Date:   Tue, 19 Sep 2023 13:22:04 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com, lkp@intel.com,
        axboe@kernel.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] task_work-add-kerneldoc-annotation-for-data-argument.patch removed from -mm tree
Message-Id: <20230919202205.25D4CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: task_work: add kerneldoc annotation for 'data' argument
has been removed from the -mm tree.  Its filename was
     task_work-add-kerneldoc-annotation-for-data-argument.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Oleg Nesterov <oleg@redhat.com>
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


