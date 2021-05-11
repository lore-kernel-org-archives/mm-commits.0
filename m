Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ED9C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E585561166
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhEKWdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKWdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:33:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09786112F;
        Tue, 11 May 2021 22:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620772338;
        bh=5I5tQvSd/3J26+ZZztbi0yEAeRVCGqy3vXwf3mHNe3E=;
        h=Date:From:To:Subject:From;
        b=CIOdum3ruWqcikjY1fW7HCKQcv54rCmoNSTP/hA4E45vwJw60gM8/elfCoH61UOMA
         Dx5D7ethvxjDEEkmFX7xAY9Zx0q6RxBnBWVaV3LbDEMKSnLr7dTIWy5fmaJ4+706sQ
         f4OPcfKWDBEZxOPRylFIo6VFLFr/3Ho7rfWDuOAI=
Date:   Tue, 11 May 2021 15:32:17 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, hulkci@huawei.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        yangyingliang@huawei.com
Subject:  + ocfs2-remove-unnecessary-init_list_head.patch added to
 -mm tree
Message-ID: <20210511223217.QhK-Cce-3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unnecessary INIT_LIST_HEAD()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unnecessary-init_list_head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unnecessary-init_list_head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unnecessary-init_list_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: ocfs2: remove unnecessary INIT_LIST_HEAD()

The list_head o2hb_node_events is initialized statically.  It is
unnecessary to initialize by INIT_LIST_HEAD().

Link: https://lkml.kernel.org/r/20210511115847.3817395-1-yangyingliang@huawei.com
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-unnecessary-init_list_head
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1442,8 +1442,6 @@ void o2hb_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2hb_live_slots); i++)
 		INIT_LIST_HEAD(&o2hb_live_slots[i]);
 
-	INIT_LIST_HEAD(&o2hb_node_events);
-
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
 	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
 	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

ocfs2-remove-unnecessary-init_list_head.patch

