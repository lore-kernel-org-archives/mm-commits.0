Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A86C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE1861C78
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGFTLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhGFTLF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E4461C75;
        Tue,  6 Jul 2021 19:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598505;
        bh=/SUqvuUblBCLuQXo/VK9lw4i8hnXFnB5ec0jfUE/sLc=;
        h=Date:From:To:Subject:From;
        b=SwT8KWGJWBL6G0hk0ELDdJHNVZRqSqjyKy3nB+norQyge7HgHjiU2J5WJgMUa/i68
         UtdweA1TjR5U+lU2XD9VQP67NJL2iX5CQRf40lsKBXRva7iFxz4Zfuc/8QQsGQsHhP
         LysfrYf8R13mS5sf4MguaKcBBq6Kdf6fbeE++KL4=
Date:   Tue, 06 Jul 2021 12:08:25 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, hulkci@huawei.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        yangyingliang@huawei.com
Subject:  [merged] ocfs2-remove-unnecessary-init_list_head.patch
 removed from -mm tree
Message-ID: <20210706190825.P8w7xfwpU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unnecessary INIT_LIST_HEAD()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unnecessary-init_list_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


