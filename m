Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F6AC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF27861D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2Cgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cgc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 635C361D01;
        Tue, 29 Jun 2021 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934045;
        bh=p9AsT47x81M4cxU/eNc5Sg4JkXEF6MfSWKuoOrfCkU4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XTW9kc/FGmN8aIuGw0UeFwXJpR0h9mun2mn+ZYGFphKy4nTmicNkMZ+AhKK3UU/uV
         e87ydV70CeiIZfsg/jGzIsPYAg8LE7daAUSm4+etrIblgnEF9qgpSOsMAa8ASfNcVe
         YA5Xn+rUDapxcLdjIvFnYq8ELbCY4puJZo/fq8mE=
Date:   Mon, 28 Jun 2021 19:34:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 015/192] ocfs2: remove redundant assignment to
 pointer queue
Message-ID: <20210629023405.iMe9rVCj6%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
