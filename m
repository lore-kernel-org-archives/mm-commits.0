Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2095C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8400260187
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347014AbhIHCVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCVM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1561F60187;
        Wed,  8 Sep 2021 02:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067605;
        bh=+KsaWMtDtnDSvix+IOhmDp7GyRYj7tGjAnynZFqqfR0=;
        h=Date:From:To:Subject:From;
        b=MIQJW3zUUCyr65OcHdS53+RwDlykUr154Rb2VB8FGcK+XWI/6nbX9FflxAMEeXLFw
         xgyl8O00jS1IjRa4F7Vj8EBxfrX2swjNGhQIa4oHwi85SU7GyXRCvZh+yMjYlD1a/m
         Yit5MZYRkXbqTgUZGRDyZck6RLUaiWY97FZ7m+Ws=
Date:   Tue, 07 Sep 2021 19:20:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  [folded-merged]
 mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch removed
 from -mm tree
Message-ID: <20210908022004.vgDg2B4Kp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch

This patch was dropped because it was folded into mm-damon-implement-a-debugfs-based-user-space-interface.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix

remove unneeded "alloc failed" printks

Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-implement-a-debugfs-based-user-space-interface-fix
+++ a/mm/damon/dbgfs.c
@@ -373,14 +373,11 @@ static int __init damon_dbgfs_init(void)
 	int rc;
 
 	dbgfs_ctxs = kmalloc(sizeof(*dbgfs_ctxs), GFP_KERNEL);
-	if (!dbgfs_ctxs) {
-		pr_err("%s: dbgfs ctxs alloc failed\n", __func__);
+	if (!dbgfs_ctxs)
 		return -ENOMEM;
-	}
 	dbgfs_ctxs[0] = dbgfs_new_ctx();
 	if (!dbgfs_ctxs[0]) {
 		kfree(dbgfs_ctxs);
-		pr_err("%s: dbgfs ctx alloc failed\n", __func__);
 		return -ENOMEM;
 	}
 	dbgfs_nr_ctxs = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

