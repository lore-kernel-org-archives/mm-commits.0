Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB9BC47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA2A613BF
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhEZXDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 19:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhEZXDB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 19:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA8C86139A;
        Wed, 26 May 2021 23:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622070088;
        bh=iBo88K3ZqcJZ1EUaGHgkrc8Oxx/teH6JmsSwvZEYhgc=;
        h=Date:From:To:Subject:From;
        b=q1UD0ELSIgiboffWqqO1E6uT0ZrfGqpZDJ7jbIkZpdzBXRMrWGoLYwo4Z3LJG1Chh
         nVUaQ0CQs3VQMEj4ef8tGNIoVbBoAyIacFzJ+U6KdYMHYQKmMCyo0PxOkBd1Ao1QtU
         6bgAiTFDtzDOC9KNXpEfQV1MjADo4mpr0IhwQPHs=
Date:   Wed, 26 May 2021 16:01:27 -0700
From:   akpm@linux-foundation.org
To:     chenhuang5@huawei.com, gechangwei@live.cn, ghe@suse.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-replaced-simple_strtoull-with-kstrtoull.patch
 added to -mm tree
Message-ID: <20210526230127.dGIESyBA5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace simple_strtoull() with kstrtoull()
has been added to the -mm tree.  Its filename is
     ocfs2-replaced-simple_strtoull-with-kstrtoull.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-replaced-simple_strtoull-with-kstrtoull.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-replaced-simple_strtoull-with-kstrtoull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Huang <chenhuang5@huawei.com>
Subject: ocfs2: replace simple_strtoull() with kstrtoull()

simple_strtoull() is deprecated in some situation since it does not check
for the range overflow, use kstrtoull() instead.

Link: https://lkml.kernel.org/r/20210526092020.554341-3-chenhuang5@huawei.com
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-replaced-simple_strtoull-with-kstrtoull
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1596,12 +1596,13 @@ static ssize_t o2hb_region_start_block_s
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long long tmp;
 	char *p = (char *)page;
+	ssize_t ret;
 
 	if (reg->hr_bdev)
 		return -EINVAL;
 
-	tmp = simple_strtoull(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtoull(p, 0, &tmp);
+	if (ret)
 		return -EINVAL;
 
 	reg->hr_start_block = tmp;
_

Patches currently in -mm which might be from chenhuang5@huawei.com are

ocfs2-replaced-simple_strtoull-with-kstrtoull.patch

