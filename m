Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34EEC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65CA61C84
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhGFTLV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhGFTLU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 969B661C74;
        Tue,  6 Jul 2021 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598520;
        bh=za7t3oD/3ilNrZgkoxicSbNO2WBMBk5EdHb4VjcvetM=;
        h=Date:From:To:Subject:From;
        b=M/ecKzRXP3tGQRNtuo0V1oMBw7T3lnmx71xqh0bQFAzO7Q56H2S6mUYvlbs64fnVi
         L3v/TRxYUmsLRoMhsysnLdE/4V31CY+kTh97jpaizoaBorCxWoROYaFcnqHn+Jwv6U
         ggefYa4iYiIuvgIny8fiVmVLpH9B23HLz7TmQuAg=
Date:   Tue, 06 Jul 2021 12:08:40 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-remove-redundant-initialization-of-variable-ret.patch removed from
 -mm tree
Message-ID: <20210706190840.EBo6Ipvcy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant initialization of variable ret
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-initialization-of-variable-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2: remove redundant initialization of variable ret

The variable ret is being initialized with a value that is never read, the
assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20210613135148.74658-1-colin.king@canonical.com
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

 fs/ocfs2/cluster/nodemanager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-remove-redundant-initialization-of-variable-ret
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -824,7 +824,7 @@ static void __exit exit_o2nm(void)
 
 static int __init init_o2nm(void)
 {
-	int ret = -1;
+	int ret;
 
 	o2hb_init();
 
_

Patches currently in -mm which might be from colin.king@canonical.com are


