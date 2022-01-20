Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0684C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377804AbiATVXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiATVXR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D3AC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACD3E61892
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C99C340E0;
        Thu, 20 Jan 2022 21:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713796;
        bh=GkuZD23Tgxlk7FvmDjUf2PffeqrF9TAqI8Nla9Ei1Dg=;
        h=Date:From:To:Subject:From;
        b=AP4VNMFyguDJffuhG3Rac+yipv/W/pDvZefw7RjmoIFMawXujFB/8V9Es0S/DXG/J
         0YH0S5NYd1QxR1rBlfZtAWowZdPJ9HM2a6mJvAQoeHfUkAzWR4KRlFahg9X+r5tj5Q
         PX69mxdu9BQxzaShHyngiVRXyTAUevDAnsHCzvYo=
Date:   Thu, 20 Jan 2022 13:23:15 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        zealci@zte.com.cn, zhang.mingyu@zte.com.cn
Subject:  [merged]
 ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch removed from
 -mm tree
Message-ID: <20220120212315.d3T28YYDV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use BUG_ON instead of if condition followed by BUG.
has been removed from the -mm tree.  Its filename was
     ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from zhang.mingyu@zte.com.cn are


