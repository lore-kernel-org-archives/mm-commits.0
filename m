Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8FAC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3EF61D00
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2Cg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC3961D02;
        Tue, 29 Jun 2021 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934039;
        bh=501VVlz7wGKtNxIL80HLBFMYRKreIqWsAko8n4esgRE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tIhhR7FpZ3t0GV+dUIf2cNJFA73zMAF5bhW8yOVfcKBtBpMSSjIjOH84eDGaF0STG
         BeDSVOX9N8j0MKmq6BFG5upV+sAzTxQTqsyQRSHQwK9gsRylXDXpxT5ILoARr40r3w
         FEZfqMrD6VJAvqWKgu2b+XKgxfqImTJxhX/R7y+g=
Date:   Mon, 28 Jun 2021 19:33:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        hulkci@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, yangyingliang@huawei.com
Subject:  [patch 013/192] ocfs2: remove unnecessary
 INIT_LIST_HEAD()
Message-ID: <20210629023358.QF4ihc-tA%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
