Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0BEC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382663AbiDTVum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiDTVum (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:50:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB2D3EF25
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C5DB81F8F
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738F3C385A1;
        Wed, 20 Apr 2022 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650491272;
        bh=HQFFHFL+XseiSZIrbBZdQCez/ieOBgQ0UTAF8UdiVXQ=;
        h=Date:To:From:Subject:From;
        b=ab9ZN2P0FQUrRhSHtvLgCZDoBkdQB5Qqma/hI8WiYfg2NOBL89TuOkn9xkiYGaTOU
         yMKOa/SarCOR/Hym+0wETvH6O7Kal4QxXlXJlg1GuwkzfX7NJfxCG3p+hptNOnQKLo
         hdzgkXR/vZstA2TvaChnv3LlhtnMCF5IfLIUYsjY=
Date:   Wed, 20 Apr 2022 14:47:51 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        hanshenghong2019@email.szu.edu.cn, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch added to -mm tree
Message-Id: <20220420214752.738F3C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: use get_task_comm() to record task command name with the protection of task_lock()
has been added to the -mm tree.  Its filename is
     mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/page_owner.c: use get_task_comm() to record task command name with the protection of task_lock()

I noticed that it is advised to access task command name with
[gs]et_task_comm() in the comment of task_struct->comm, which is safer
with the protection of task_lock().

Relative comment in include/linux/sched.h is as follows:

/*
 * executable name, excluding path.
 *
 * - normally initialized setup_new_exec()
 * - access it with [gs]et_task_comm()
 * - lock it with task_lock()
*/

Link: https://lkml.kernel.org/r/20220420122817.67181-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock
+++ a/mm/page_owner.c
@@ -168,8 +168,7 @@ static inline void __set_page_owner_hand
 		page_owner->pid = current->pid;
 		page_owner->tgid = current->tgid;
 		page_owner->ts_nsec = local_clock();
-		strlcpy(page_owner->comm, current->comm,
-			sizeof(page_owner->comm));
+		get_task_comm(page_owner->comm, current);
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch
tools-vm-page_owner_sortc-avoid-repeated-judgments.patch
mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch
mm-vmalloc-fix-a-comment.patch

