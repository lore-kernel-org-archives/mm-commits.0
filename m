Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47568C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbhKXDfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhKXDfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E37360E8E;
        Wed, 24 Nov 2021 03:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724743;
        bh=8VKc9ibjIFQNCpkF8Vt+L18zdBGsH9hZlXJLTcPJS2s=;
        h=Date:From:To:Subject:From;
        b=WK3h4x0pOse4nrEuNXzQjFAL253c9AsfyWl6utlb/1bXpdyoB2MQSj9/6VD38rGEI
         XydOBW1WkefPXLk5REb/B4MUJmD/lBd4G2oKooinP3kU8DV/RzAsbw/S2zCTGi/5R6
         lFS4ml0B+tzKoHNxxhZEnhboI8qBiQDMDBBhGl5Q=
Date:   Tue, 23 Nov 2021 19:32:22 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch added to
 -mm tree
Message-ID: <20211124033222.ztC0Z4cF9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec: replace strncpy with strscpy_pad in __get_task_comm
has been added to the -mm tree.  Its filename is
     fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch

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

fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch
fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch
drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch
samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len.patch

