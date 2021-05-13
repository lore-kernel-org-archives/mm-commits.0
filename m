Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A776C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43818613B9
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhEMTqr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhEMTqr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F50613F1;
        Thu, 13 May 2021 19:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620935136;
        bh=qS2E7x7rySLxgXfrGPjT0iioeIrZSLsvTZpBoyARcNU=;
        h=Date:From:To:Subject:From;
        b=u6Xor/gBLsFuQsoSTWGIUNE8J+60MOVCYIZCORsiRdxsHR+YY+4RSK/2273ycjpTs
         N+gT/fehF+i7LDWXNzLr3DAxttvE0JEKrZbjQlol6ObrZo+XAfp6EDaxBiL/6XVYzo
         8wji1DV6gG3yPKYkYuxJW6//V4zmS61zS2lv+XWk=
Date:   Thu, 13 May 2021 12:45:35 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  +
 ocfs2-remove-redundant-assignment-to-pointer-queue.patch added to -mm tree
Message-ID: <20210513194535.Q2nvAKiqp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to pointer queue
has been added to the -mm tree.  Its filename is
     ocfs2-remove-redundant-assignment-to-pointer-queue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-redundant-assignment-to-pointer-queue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-redundant-assignment-to-pointer-queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-remove-redundant-assignment-to-pointer-queue.patch

