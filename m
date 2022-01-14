Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADF9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiANWDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiANWDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2184C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E6D2B82A39
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27FDC36AE9;
        Fri, 14 Jan 2022 22:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197816;
        bh=u+LK7xStWhkzJS7v1TapIAfJyzhoww3EmEoACQ3I534=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YDqU61Qf0lRKCRlJ80SD8Yc7jX/vRN2kZ2LntfVdaB2Jnvm0sIaGeqme7SMDE2Xqd
         VGxjQS96StrCTZyE/6tt2m9NBb4t4lAvDZ6UyIUwRg8ZAN4lvj/1MMmen20hlzvNhE
         y484cfc+ThkwrhHsRg4tBZLVqxlWiymBQb5p2K9o=
Date:   Fri, 14 Jan 2022 14:03:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, zealci@zte.com.cn,
        zhang.mingyu@zte.com.cn
Subject:  [patch 014/146] ocfs2: use BUG_ON instead of if condition
 followed by BUG.
Message-ID: <20220114220335.-FP0r81CP%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
Subject: ocfs2: use BUG_ON instead of if condition followed by BUG.

This issue was detected with the help of Coccinelle.

Link: https://lkml.kernel.org/r/20211105014424.75372-1-zhang.mingyu@zte.com.cn
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug
+++ a/fs/ocfs2/journal.c
@@ -1669,8 +1669,7 @@ static int ocfs2_replay_journal(struct o
 	status = jbd2_journal_load(journal);
 	if (status < 0) {
 		mlog_errno(status);
-		if (!igrab(inode))
-			BUG();
+		BUG_ON(!igrab(inode));
 		jbd2_journal_destroy(journal);
 		goto done;
 	}
@@ -1699,8 +1698,7 @@ static int ocfs2_replay_journal(struct o
 	if (status < 0)
 		mlog_errno(status);
 
-	if (!igrab(inode))
-		BUG();
+	BUG_ON(!igrab(inode));
 
 	jbd2_journal_destroy(journal);
 
_
