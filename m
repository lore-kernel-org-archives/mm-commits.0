Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A14DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiANWDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiANWDz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3696EC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED702B82A3E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40722C36AE9;
        Fri, 14 Jan 2022 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197832;
        bh=e20GBA0OwqvknUZTAmxB+UM/XpDlxjDw0NO9T5731pM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mi1wdk46vNVKyErSwrYPp4la6SedFc9EZQuqtwIjr9upUrWuCbs+ADNxVTr6O1bAD
         ns/vPQG+cwO4qoh7JrJsq+psq15b+LXJuh/truIMQgaBlfUdfM6uMS+ycZoxOi7BqH
         ugDcImjLwGNjnsVmZTGPq+B5/iPHvv/QOwkcSCss=
Date:   Fri, 14 Jan 2022 14:03:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 019/146] ocfs2: remove redundant assignment to
 variable free_space
Message-ID: <20220114220351.qb2sDMT4e%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>
Subject: ocfs2: remove redundant assignment to variable free_space

Variable free_space is being initialized with a value that is not read, it
is being re-assigned later in the two paths of an if statement.  The early
initialization is redundant and can be removed.

Link: https://lkml.kernel.org/r/20220112230411.1090761-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c~ocfs2-remove-redundant-assignment-to-variable-free_space
+++ a/fs/ocfs2/dir.c
@@ -3343,7 +3343,7 @@ static int ocfs2_find_dir_space_id(struc
 	struct ocfs2_dir_entry *de, *last_de = NULL;
 	char *de_buf, *limit;
 	unsigned long offset = 0;
-	unsigned int rec_len, new_rec_len, free_space = dir->i_sb->s_blocksize;
+	unsigned int rec_len, new_rec_len, free_space;
 
 	/*
 	 * This calculates how many free bytes we'd have in block zero, should
_
