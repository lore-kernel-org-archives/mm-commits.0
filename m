Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BAAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244410AbiATV3z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiATV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2DD1B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83EC340E0;
        Thu, 20 Jan 2022 21:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714192;
        bh=4DWGuthdoYrJGBbFiKqInUkRKyi6R/OVHUSTGgaEdeQ=;
        h=Date:From:To:Subject:From;
        b=NSTg995mlMMVgqRaNodPpSFbK/R/3SoNDm2jiYQpzg1IdMyF5mIjO4fw9VxJut/pe
         +D9C5qQfgi0nkTebDllHupq4W01xoPxKsveiQFQxq9AGGzwXQgulEp1V21QGJFNyU+
         ZJt6jBkPWQx34AUaHgBieXVIecrHiZ6rXQlg+FiY=
Date:   Thu, 20 Jan 2022 13:29:51 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch removed
 from -mm tree
Message-ID: <20220120212951.LwCPSHeEg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec: replace strlcpy with strscpy_pad in __set_task_comm
has been removed from the -mm tree.  Its filename was
     fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: fs/exec: replace strlcpy with strscpy_pad in __set_task_comm

Patch series "task comm cleanups", v2.

This patchset is part of the patchset "extend task comm from 16 to 24"[1].
Now we have different opinion that dynamically allocates memory to store
kthread's long name into a separate pointer, so I decide to take the
useful cleanups apart from the original patchset and send it
separately[2].

These useful cleanups can make the usage around task comm less
error-prone.  Furthermore, it will be useful if we want to extend task
comm in the future.

[1]. https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/lkml/CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com/


This patch (of 7):

strlcpy() can trigger out-of-bound reads on the source string[1], we'd
better use strscpy() instead.  To make it be robust against full tsk->comm
copies that got noticed in other places, we should make sure it's zero
padded.

[1] https://github.com/KSPP/linux/issues/89

Link: https://lkml.kernel.org/r/20211120112738.45980-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20211120112738.45980-2-laoar.shao@gmail.com
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

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c~fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm
+++ a/fs/exec.c
@@ -1222,7 +1222,7 @@ void __set_task_comm(struct task_struct
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


