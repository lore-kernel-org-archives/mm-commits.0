Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E4AC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358157AbiATCIG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41456 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8512615C2
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF03BC004E1;
        Thu, 20 Jan 2022 02:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644484;
        bh=AflCnBXLUWeAvAcbs1hf0gtmL5D1A0nl1HN1bIdEWsg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XoZz1iQoTqAMJmw0ERavmVfB4KHleSEpn06oUCDdGiV40ZccwwsaoTYL0nLCytYGV
         ox0WGtCMxfe7MXa66HVbXfbvy3dC1Snq7AidvN3XNYRZx7U7qIq0S/5S7G5HhUpgWv
         NrNOGcco8z+GX04kJYJ1ZtadCrLwC/O47eGIaxic=
Date:   Wed, 19 Jan 2022 18:08:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhengqi.arch@bytedance.com
Subject:  [patch 07/55] proc: convert the return type of
 proc_fd_access_allowed() to be boolean
Message-ID: <20220120020803.B1AdljNwl%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
