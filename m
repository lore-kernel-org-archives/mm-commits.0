Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292B9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 23:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhLUXu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 18:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhLUXu1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 18:50:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C866C061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 15:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B11E2617DF
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 23:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F49C36AE9;
        Tue, 21 Dec 2021 23:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640130626;
        bh=nrYnzgTcWAq8Co7N6o5gv9z8QDhE7wAjHns9We8XJcU=;
        h=Date:From:To:Subject:From;
        b=YdxL/x1Zv1eYf9Fj+23WUFnCf/m+Hgw0G6p9muEJtd58oqG1BRTrDRABG9kXlUssX
         EBXbzDsSg+w0gMWCEO5EBz2ew+PeTgJqBiqujoZ4lfAlH4a/Bmwc0nuLNlluHKLuPR
         KCso+FNzuFXXmV6uLIIgTOcYbvYJxiO+3DlpPHBE=
Date:   Tue, 21 Dec 2021 15:50:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        adobriyan@gmail.com, zhengqi.arch@bytedance.com
Subject:  +
 proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch
 added to -mm tree
Message-ID: <20211221235025.qNuab%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert the return type of proc_fd_access_allowed() to be boolean
has been added to the -mm tree.  Its filename is
     proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
proc-convert-the-return-type-of-proc_fd_access_allowed-to-be-boolean.patch

