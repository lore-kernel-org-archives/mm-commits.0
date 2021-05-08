Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331EEC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1616861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWka (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWk2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD83610D2;
        Sat,  8 May 2021 22:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513565;
        bh=X0laib/8hPk2cBC1bhAZjsRYI0bwFIG5AVnaP3Rs4PY=;
        h=Date:From:To:Subject:From;
        b=uM3zxfiPRRaX8cIwA02n5ZwcM+9mOFq9GCteSMbMNipiRHNdoUEGqMHEEGKNJ3iSf
         vkKHwJ4hd/uODXSBJ6aNDy/HPLolGEkTuUFBDURrCNcjRzkSbEVvCsUjHNOr7YtRKj
         XAeuOoXH4bQPos7LdiRiEWhbH5w0qOLBKlwmLZNk=
Date:   Sat, 08 May 2021 15:39:25 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, yang.lee@linux.alibaba.com
Subject:  [merged]
 ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch
 removed from -mm tree
Message-ID: <20210508223925.okg56PCO5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: ocfs2: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE

Fix the following coccicheck warning:
./fs/ocfs2/blockcheck.c:232:0-23: WARNING: blockcheck_fops should be
defined with DEFINE_DEBUGFS_ATTRIBUTE

Link: https://lkml.kernel.org/r/1614155230-57292-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/blockcheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/blockcheck.c~ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute
+++ a/fs/ocfs2/blockcheck.c
@@ -229,7 +229,7 @@ static int blockcheck_u64_get(void *data
 	*val = *(u64 *)data;
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
 
 static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 {
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


