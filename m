Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B34AC4338F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4128E61184
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbhHFAmf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 20:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241242AbhHFAmZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 20:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABEF611C2;
        Fri,  6 Aug 2021 00:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628210530;
        bh=s4r65CNHZa1t4HP93Y7XNufgAFZX5U0cOJr2Rswqoa0=;
        h=Date:From:To:Subject:From;
        b=Wmwh+tzB0/4yt9CAzyhoXMxgJxc8VmMZTgT4/eHna8yl9Dqvz2MrLi7U+GW0siHTm
         srA7ba5yh1GrHRgiHMO6Vz+wNO8s9Pkb10cFH9RwrZVujxm9nEcjnWgwMVevPxhimL
         tILn9yGsAE9c8HnE4NLS0/cha15niUia2beajQtA=
Date:   Thu, 05 Aug 2021 17:42:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjpark@amazon.de,
        akpm@linux-foundation.org
Subject:  +
 mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch added
 to -mm tree
Message-ID: <20210806004210.8ezDO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix
has been added to the -mm tree.  Its filename is
     mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix

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

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

