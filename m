Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41B1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358180AbiATCIx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42070 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358175AbiATCIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 109C361522
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28DDC004E1;
        Thu, 20 Jan 2022 02:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644514;
        bh=sNUdxeGWDdjZ5sTIBjypyvsoG32kxwKMhMmDOFwDaJY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gi9CHoSefOUzIvYnnAvI5Whh5jvWD76zMKXZcOKmhKHVN3g0nCLm+TtDnklN751YP
         j7AVZDZPTQ0SpZ/zDGtcAh1r0zdTBNEQ56aqIhDibc6i0Y6lCTetWo2BHt51vKw0e+
         yEaG0A7f3mxRLw06to3PJWlOyxw937YW5T2CU1Ek=
Date:   Wed, 19 Jan 2022 18:08:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexei.starovoitov@gmail.com,
        andrii.nakryiko@gmail.com, andrii@kernel.org,
        arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mirq-linux@rere.qmqm.pl,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 16/55] samples/bpf/test_overhead_kprobe_kern:
 replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task
 comm
Message-ID: <20220120020833.EAvz32t9w%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: samples/bpf/test_overhead_kprobe_kern: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then we
don't care about if the dst size is big enough.  This patch also replaces
the hard-coded 16 with TASK_COMM_LEN to make it grepable.

Link: https://lkml.kernel.org/r/20211120112738.45980-6-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/bpf/offwaketime_kern.c          |    4 ++--
 samples/bpf/test_overhead_kprobe_kern.c |   11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c     |    5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)

--- a/samples/bpf/offwaketime_kern.c~samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm
+++ a/samples/bpf/offwaketime_kern.c
@@ -113,11 +113,11 @@ static inline int update_counts(void *ct
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
--- a/samples/bpf/test_overhead_kprobe_kern.c~samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm
+++ a/samples/bpf/test_overhead_kprobe_kern.c
@@ -6,6 +6,7 @@
  */
 #include <linux/version.h>
 #include <linux/ptrace.h>
+#include <linux/sched.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
@@ -22,17 +23,17 @@ int prog(struct pt_regs *ctx)
 {
 	struct signal_struct *signal;
 	struct task_struct *tsk;
-	char oldcomm[16] = {};
-	char newcomm[16] = {};
+	char oldcomm[TASK_COMM_LEN] = {};
+	char newcomm[TASK_COMM_LEN] = {};
 	u16 oom_score_adj;
 	u32 pid;
 
 	tsk = (void *)PT_REGS_PARM1(ctx);
 
 	pid = _(tsk->pid);
-	bpf_probe_read_kernel(oldcomm, sizeof(oldcomm), &tsk->comm);
-	bpf_probe_read_kernel(newcomm, sizeof(newcomm),
-			      (void *)PT_REGS_PARM2(ctx));
+	bpf_probe_read_kernel_str(oldcomm, sizeof(oldcomm), &tsk->comm);
+	bpf_probe_read_kernel_str(newcomm, sizeof(newcomm),
+				  (void *)PT_REGS_PARM2(ctx));
 	signal = _(tsk->signal);
 	oom_score_adj = _(signal->oom_score_adj);
 	return 0;
--- a/samples/bpf/test_overhead_tp_kern.c~samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm
+++ a/samples/bpf/test_overhead_tp_kern.c
@@ -4,6 +4,7 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
+#include <linux/sched.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
@@ -11,8 +12,8 @@
 struct task_rename {
 	__u64 pad;
 	__u32 pid;
-	char oldcomm[16];
-	char newcomm[16];
+	char oldcomm[TASK_COMM_LEN];
+	char newcomm[TASK_COMM_LEN];
 	__u16 oom_score_adj;
 };
 SEC("tracepoint/task/task_rename")
_
