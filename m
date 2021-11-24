Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486FDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbhKXDfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhKXDff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDCF60F6F;
        Wed, 24 Nov 2021 03:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724746;
        bh=QexH4tBZaW5B3FnFHhOaC7/59kvHWHpE+XhHFKybb7w=;
        h=Date:From:To:Subject:From;
        b=PnAjiZ4nLQMT01vuf4d5I4jlEP/EomLGX1HUqrRNqDasMhPwmVwMrlyvEgz1tJs1f
         P3VLsk5kejpB8fUCr1hI78WZ3u2e8t8lyh+N8kczsyMBuhPwQh6dJaD/6GRqLkCBZG
         w9w/kp5mVfgKQXQhXTQtunpuTydWm8mUccJRUAJo=
Date:   Tue, 23 Nov 2021 19:32:25 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
 added to -mm tree
Message-ID: <20211124033225.hjn2KBj3Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband: replace open-coded string copy with get_task_comm
has been added to the -mm tree.  Its filename is
     drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch

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
Subject: drivers/infiniband: replace open-coded string copy with get_task_comm

We'd better use the helper get_task_comm() rather than the open-coded
strlcpy() to get task comm.  As the comment above the hard-coded 16, we
can replace it with TASK_COMM_LEN.

Link: https://lkml.kernel.org/r/20211120112738.45980-4-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib.h          |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_file_ops.c~drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportda
 	rcd->tid_pg_list = ptmp;
 	rcd->pid = current->pid;
 	init_waitqueue_head(&dd->rcd[ctxt]->wait);
-	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
+	get_task_comm(rcd->comm, current);
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
 	dd->freectxts--;
--- a/drivers/infiniband/hw/qib/qib.h~drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm
+++ a/drivers/infiniband/hw/qib/qib.h
@@ -196,7 +196,7 @@ struct qib_ctxtdata {
 	pid_t pid;
 	pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
 	/* same size as task_struct .comm[], command that opened context */
-	char comm[16];
+	char comm[TASK_COMM_LEN];
 	/* pkeys set by this use of this ctxt */
 	u16 pkeys[4];
 	/* so file ops can get at unit */
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch
fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch
drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch
samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len.patch

