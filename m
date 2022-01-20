Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A13C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347581AbiATVXc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiATVXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F28C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E4061896
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B138DC340E0;
        Thu, 20 Jan 2022 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713811;
        bh=hy3TpacA1JBIvp8vZPfd8QIl9WQtseFkkvhsHFHv0gI=;
        h=Date:From:To:Subject:From;
        b=qWp0jTOshTRr07mEvJybOo8qOdF+ThR+c1LTvykQszz0SJlp1vtWhH4aKsPanVbk2
         LtG7DztR15n/B1Hb0C2B/Nc7Ca1LnlfH4qEknepm18IsIs14RKBM+7Im1pNgKOXxjp
         0FSCUUNxcHOZf0qx8hk410ppgzqHo0M5/8FWtKHM=
Date:   Thu, 20 Jan 2022 13:23:30 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-remove-redundant-assignment-to-variable-free_space.patch removed from
 -mm tree
Message-ID: <20220120212330.1GjEjOKTx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to variable free_space
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-assignment-to-variable-free_space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kernel-sysctlc-remove-unused-variable-ten_thousand.patch

