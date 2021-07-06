Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B7BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A094B61C7E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhGFTLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhGFTLK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9669261C72;
        Tue,  6 Jul 2021 19:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598511;
        bh=ZNqLLxNxVRgLiafvJHwjcxw3r49yDf0m5DImGhNxsiU=;
        h=Date:From:To:Subject:From;
        b=TaI8be6NekRC3sYYGoxXH34oWVa1km9N+nnil6fwpPxrOBMImf8zmywDW55Au7Sg5
         +hgTcpFQFP5tue9tD8zD2NKG5Zl5duSAWSMnofY+0bf3Vl61qD0xkOVpWn0euw3chO
         EsJTrVrE+ba9OLHlghwbVEMunSMX4vlvn3IV+9Ps=
Date:   Tue, 06 Jul 2021 12:08:31 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-remove-redundant-assignment-to-pointer-queue.patch removed from -mm
 tree
Message-ID: <20210706190831.6gdpwmxkq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to pointer queue
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-assignment-to-pointer-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2: remove redundant assignment to pointer queue

The pointer queue is being initialized with a value that is never read and
it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20210513113957.57539-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-redundant-assignment-to-pointer-queue
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2977,7 +2977,7 @@ static u8 dlm_pick_migration_target(stru
 				    struct dlm_lock_resource *res)
 {
 	enum dlm_lockres_list idx;
-	struct list_head *queue = &res->granted;
+	struct list_head *queue;
 	struct dlm_lock *lock;
 	int noderef;
 	u8 nodenum = O2NM_MAX_NODES;
_

Patches currently in -mm which might be from colin.king@canonical.com are


