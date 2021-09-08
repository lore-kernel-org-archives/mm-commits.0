Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA3CC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A316108B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347098AbhIHCVT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCVO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F936103D;
        Wed,  8 Sep 2021 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067607;
        bh=jaiU4vVl+i7g3fvmYAA8R6U1avDZ9vooF63fLXWV+Jc=;
        h=Date:From:To:Subject:From;
        b=Jq8/htN6iOtLiaBYdOc8usY7FZqA22PHicrLEy7tLSkTyjSqjKAQK9kh8d1Mr/riB
         Z+akMCj7zmLX82SB76BZt/3+wQtRE8D8kRbGuLiU9pKa2WC1FQOH495NMY3oIfEm5R
         JnO/7jPI7+uZHP+TgCvOCl9n4ySqYNOcn1HBgrcg=
Date:   Tue, 07 Sep 2021 19:20:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  [folded-merged]
 mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
 removed from -mm tree
Message-ID: <20210908022007.8_gvKcjcX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch

This patch was dropped because it was folded into mm-damon-implement-a-debugfs-based-user-space-interface.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix

replace macro with static inline

Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix
+++ a/mm/damon/dbgfs.c
@@ -97,8 +97,10 @@ out:
 	return ret;
 }
 
-#define targetid_is_pid(ctx)	\
-	(ctx->primitive.target_valid == damon_va_target_valid)
+static inline bool targetid_is_pid(const struct damon_ctx *ctx)
+{
+	return ctx->primitive.target_valid == damon_va_target_valid;
+}
 
 static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-implement-a-debugfs-based-user-space-interface.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

