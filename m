Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C549C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 19:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiAMT6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 14:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiAMT6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 14:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D3FC061574
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 11:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC22A61CE8
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 19:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA8C36AE9;
        Thu, 13 Jan 2022 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642103922;
        bh=FYYbwC8StlcTc5f1Y/lqE8ECMYRKaZMW38rpZaTPSkI=;
        h=Date:From:To:Subject:From;
        b=wL/0K8whlpdYeKl5Mrd9nqDFRmYOqMiK1mqhFw5unI05loKKb0TTqvbdv+TvS8kgb
         jfINA2s15Zq/Hesl+RmvrsjoCHn3d5zLMdLP30/Da2ti8Vhk7lVeanFeS/YJ4zpv28
         Y+1+SnGjOfVo3qAGhdYdlvQrnT8nZo32gn3IZ8iY=
Date:   Thu, 13 Jan 2022 11:58:41 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  +
 ocfs2-remove-redundant-assignment-to-variable-free_space.patch added to -mm
 tree
Message-ID: <20220113195841.YdMBTtiTT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to variable free_space
has been added to the -mm tree.  Its filename is
     ocfs2-remove-redundant-assignment-to-variable-free_space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-redundant-assignment-to-variable-free_space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-redundant-assignment-to-variable-free_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from colin.i.king@gmail.com are

ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch
ocfs2-remove-redundant-assignment-to-variable-free_space.patch
mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
nilfs2-remove-redundant-pointer-sbufs.patch
lib-remove-redundant-assignment-to-variable-ret.patch
kernel-sysctlc-remove-unused-variable-ten_thousand.patch

