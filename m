Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6837EC43217
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377913AbiATV3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59478 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377970AbiATV3k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15EFBB81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61EFC340E3;
        Thu, 20 Jan 2022 21:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714177;
        bh=ekW65EZzsPu0WB81Dg4AedKqliz9azHCrKa01MZ4iqI=;
        h=Date:From:To:Subject:From;
        b=aLhBld3wpmuHqcBUSoPRrUayilUjL8sf1cXtBPLSZAav6zUuzz+G5YfHjo67ORg0Y
         ATdz2jIyDEfzwSsON4yZdzuB9y/kEEpup5AOaB/qtDLoELsNIYr7mS/nrsDPFS8oSI
         qheFOf+QexOF8zlLWOkoKcmTcuEZRDjmeY7k3nh8=
Date:   Thu, 20 Jan 2022 13:29:37 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com
Subject:  [merged]
 proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch
 removed from -mm tree
Message-ID: <20220120212937.FoO6paQI5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert the return type of proc_fd_access_allowed() to be boolean
has been removed from the -mm tree.  Its filename was
     proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: proc: convert the return type of proc_fd_access_allowed() to be boolean

Convert return type of proc_fd_access_allowed() and the 'allowed' in it to
be boolean since the return type of ptrace_may_access() is boolean.

Link: https://lkml.kernel.org/r/20211219024404.29779-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c~proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean
+++ a/fs/proc/base.c
@@ -670,10 +670,10 @@ static int proc_pid_syscall(struct seq_f
 /************************************************************************/
 
 /* permission checks */
-static int proc_fd_access_allowed(struct inode *inode)
+static bool proc_fd_access_allowed(struct inode *inode)
 {
 	struct task_struct *task;
-	int allowed = 0;
+	bool allowed = false;
 	/* Allow access to a task's file descriptors if it is us or we
 	 * may use ptrace attach to the process and find out that
 	 * information.
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


