Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6901C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7841764F2C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhBYTRA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234083AbhBYTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE6064F2A;
        Thu, 25 Feb 2021 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280291;
        bh=G7tN5ocBc2OmGwkv6ex1bx4rKdTp8+XauKTco15gPjo=;
        h=Date:From:To:Subject:From;
        b=CKvB1vms7w8bU3Ye0RbaLrrnmEh178+5cWMC5DcGuNCG9MinJ2qDFec8vjYx/BidS
         XpWDpC8GyfrDLMvrPS6ajCGtAi4Ax/kY8FWNrdc3ob4YtcOWRxOp2JUeK6EcNC2dKB
         aamEQWzNKhEI2A3nYO8bG6hIti+O9Yyy1L6GA9SA=
Date:   Thu, 25 Feb 2021 11:11:30 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        yili@winhong.com
Subject:  [merged]
 ocfs2-remove-redundant-conditional-before-iput.patch removed from -mm tree
Message-ID: <20210225191130.Ubt82lsOt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant conditional before iput
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-conditional-before-iput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yi Li <yili@winhong.com>
Subject: ocfs2: remove redundant conditional before iput

iput handles NULL pointers gracefully, so there's no need to check the
pointer before the call.

Link: https://lkml.kernel.org/r/20201231040535.4091761-1-yili@winhong.com
Signed-off-by: Yi Li <yili@winhong.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-remove-redundant-conditional-before-iput
+++ a/fs/ocfs2/super.c
@@ -973,8 +973,6 @@ static void ocfs2_disable_quotas(struct
 		 * quota files */
 		dquot_disable(sb, type, DQUOT_USAGE_ENABLED |
 					DQUOT_LIMITS_ENABLED);
-		if (!inode)
-			continue;
 		iput(inode);
 	}
 }
_

Patches currently in -mm which might be from yili@winhong.com are


