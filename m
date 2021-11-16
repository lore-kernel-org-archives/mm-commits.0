Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7C4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6487463217
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhKPEmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243000AbhKPEmS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:42:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C136A61AF7;
        Tue, 16 Nov 2021 04:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637037561;
        bh=GOXmuxFxv4iD0nUdhnDfxX+9zVfjKPwJMXwJherAZE8=;
        h=Date:From:To:Subject:From;
        b=HRb+iPAJvrZUuc8owmmJDAh7815ANz8g5XjTgQuKJ8kRAPSAJq2VjLck8KKGHQ/Xp
         C605htr3ZlA49UAJqFzzizqU6LtP0K3/i64Y0NYYaQbgHXDHbdWcYdZc3WEc0Twmbm
         Ytc7MqdHMIwIKd90r0lIfJiL6kinup8axdR2SNvE=
Date:   Mon, 15 Nov 2021 20:39:20 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        zealci@zte.com.cn, zhang.mingyu@zte.com.cn
Subject:  +
 ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch added to -mm
 tree
Message-ID: <20211116043920.MO4JF5737%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2:Use BUG_ON instead of if condition followed by BUG.
has been added to the -mm tree.  Its filename is
     ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
Subject: ocfs2:Use BUG_ON instead of if condition followed by BUG.

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

ocfs2-use-bug_on-instead-of-if-condition-followed-by-bug.patch

