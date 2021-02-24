Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FB1C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938BC64F0C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhBXUCL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234995AbhBXUCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085E364EF1;
        Wed, 24 Feb 2021 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196835;
        bh=+o1F19wGgMUvmhOnRYeoH2ndZPYN3vtY3RMcAPJB/ek=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dLVBJ9JiZtF0RFcNnQtHYTCKh6DDNA5l3/fJ1AA4cqgDkeDW86xcbKSI3f27NX0WL
         O7C7WBIByqnzBF278BMMQTFyaaSGaDWrN8aOVKyxA0B4VgUT+sgSOxQeR056WK1WK6
         nZueeUMS0+WCX8TJqdVWG3YeA+fsgItOphhjjx/s=
Date:   Wed, 24 Feb 2021 12:00:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, yili@winhong.com
Subject:  [patch 008/173] ocfs2: remove redundant conditional
 before iput
Message-ID: <20210224200034.HBgw5B2Gy%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
