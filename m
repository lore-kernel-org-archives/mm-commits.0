Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C2BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391632AbiDUTAN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 15:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391648AbiDUTAJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 15:00:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C77261F
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6124461AC6
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69DEC385B9;
        Thu, 21 Apr 2022 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650567438;
        bh=cKRWCJso8zhDooaOnC3FuZqz6Du/3yVYbYa2QVOViXo=;
        h=Date:To:From:Subject:From;
        b=Hh+7QmAeJzxeWD5TjhqdOxfxFsz9PhSm5RrigYjK+220VdiV97mCsO2KtuXC35CFh
         OnkytXmM6Le4j0B8DDZOZOixAmHixFV+G+C5P2/YQvsVZoFY9ukIJ7cL+JYbRrHdCs
         3X5IroTTKnhhqVpnUL4g5OTF+egJW3U34gO3lS+E=
Date:   Thu, 21 Apr 2022 11:57:17 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        quic_qiancai@quicinc.com, hanshenghong2019@email.szu.edu.cn,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch removed from -mm tree
Message-Id: <20220421185718.A69DEC385B9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: use get_task_comm() to record task command name with the protection of task_lock()
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-use-get_task_comm-to-record-task-command-name-with-the-protection-of-task_lock.patch

This patch was dropped because it had testing failures

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
Cc: Qian Cai <quic_qiancai@quicinc.com>
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
mm-vmalloc-fix-a-comment.patch

