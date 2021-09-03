Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA130C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0F2610E9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhICU4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhICU4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99ECB610C8;
        Fri,  3 Sep 2021 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702520;
        bh=cHbNlQR4TiqbE2Nu/r49G70qRM3Q2e5dYQ6O3MbbS9A=;
        h=Date:From:To:Subject:From;
        b=PFgFmwxq1dOGug5XNtOsvUZcfbY/gwKg3jtmo9FBAcksIqL53h7U55Yq3I0KDeZ+o
         JkrQgjGCRf8dtJD+MWRYV1z9r6ySHNPKl0YKG6sLT//pzOxKBqrD+ynm5Jl7nyyI1F
         AiPw1tJhrym4ZWlwlPf+AY+ClB1sw1EAq9P2+RGY=
Date:   Fri, 03 Sep 2021 13:55:20 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, islituo@gmail.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        oslab@tsinghua.edu.cn, piaojun@huawei.com
Subject:  [merged]
 =?US-ASCII?Q?ocfs2-quota=5Flocal-fix-possible-uninitialized-variable-a?=
 =?US-ASCII?Q?ccess-in-ocfs2=5Flocal=5Fread=5Finfo.patch?= removed from -mm
 tree
Message-ID: <20210903205520.4L4-rv9Nx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()
has been removed from the -mm tree.  Its filename was
     ocfs2-quota_local-fix-possible-uninitialized-variable-access-in-ocfs2_local_read_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tuo Li <islituo@gmail.com>
Subject: ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()

A memory block is allocated through kmalloc(), and its return value is
assigned to the pointer oinfo. However, oinfo->dqi_gqinode is not
initialized but it is accessed in:
  iput(oinfo->dqi_gqinode);

To fix this possible uninitialized-variable access, assign NULL to
oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init() behind the
assignment in ocfs2_local_read_info().  Remove ocfs2_qinfo_lock_res_init()
in ocfs2_global_read_info().

Link: https://lkml.kernel.org/r/20210804031832.57154-1-islituo@gmail.com
Signed-off-by: Tuo Li <islituo@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    1 -
 fs/ocfs2/quota_local.c  |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-quota_local-fix-possible-uninitialized-variable-access-in-ocfs2_local_read_info
+++ a/fs/ocfs2/quota_global.c
@@ -357,7 +357,6 @@ int ocfs2_global_read_info(struct super_
 	}
 	oinfo->dqi_gi.dqi_sb = sb;
 	oinfo->dqi_gi.dqi_type = type;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
 	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
 	oinfo->dqi_gqi_bh = NULL;
--- a/fs/ocfs2/quota_local.c~ocfs2-quota_local-fix-possible-uninitialized-variable-access-in-ocfs2_local_read_info
+++ a/fs/ocfs2/quota_local.c
@@ -702,6 +702,8 @@ static int ocfs2_local_read_info(struct
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
+	oinfo->dqi_gqinode = NULL;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
_

Patches currently in -mm which might be from islituo@gmail.com are


