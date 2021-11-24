Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79DFC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240278AbhKXDfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhKXDfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:35:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BC0C60F50;
        Wed, 24 Nov 2021 03:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724740;
        bh=bSDJSer4Qx25PDw1oI4HD3g0mDzOeM8Y1GagEA3WpwI=;
        h=Date:From:To:Subject:From;
        b=TO86YZEpYevCXLZF+tl3Au7mblGxYdKMyLiWu8jpBpN2FXGt+OGqdJvL+FarHhbuX
         oWC3OPuRpih2b/OyK+ZDibo/J8ieWPPG5/iPrlFpJBd377S/HFAMAnqUknOFaFivgE
         Ku9Tq68eejlZcFNzKYYoUu5xvSZ7mSeV6PYF5Ngk=
Date:   Tue, 23 Nov 2021 19:32:19 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch added to
 -mm tree
Message-ID: <20211124033219.vqqWKRZ27%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec: replace strlcpy with strscpy_pad in __set_task_comm
has been added to the -mm tree.  Its filename is
     fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch
fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch
drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch
samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len.patch

