Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63882C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377918AbiATV37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59698 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244402AbiATV35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5C9BB81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F7C340E0;
        Thu, 20 Jan 2022 21:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714195;
        bh=N25VnkjYrYHQWoTwJXP5umd3zoP63whxKQIyVNX4raw=;
        h=Date:From:To:Subject:From;
        b=taX+3TG8wtaYSDAruONdlRyckeC9CMs1SfeWSZ0NgwIKxueCIvwTHoOboDAldY9Pc
         9x2pRt1x6IEzxFHvySOZaw+J10p/z7zLaOaCcgpZybvC/u/SWsVbqMyx0kH/ro+DkX
         wFlF3P2gPz5pBxNPYAWjkPBjf1yQ4pf+U5/1d5e0=
Date:   Thu, 20 Jan 2022 13:29:54 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch removed
 from -mm tree
Message-ID: <20220120212954.mAAXcotVP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec: replace strncpy with strscpy_pad in __get_task_comm
has been removed from the -mm tree.  Its filename was
     fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: fs/exec: replace strncpy with strscpy_pad in __get_task_comm

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer will
be without null ternimator, that may cause problem.  Using strscpy_pad()
instead of strncpy() in __get_task_comm() can make the string always nul
ternimated and zero padded.

Link: https://lkml.kernel.org/r/20211120112738.45980-3-laoar.shao@gmail.com
Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/exec.c~fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm
+++ a/fs/exec.c
@@ -1207,7 +1207,8 @@ static int unshare_sighand(struct task_s
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, buf_size);
+	/* Always NUL terminated and zero-padded */
+	strscpy_pad(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


