Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3E2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiATCIx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50640 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358172AbiATCIn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EF77B81911
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F59C004E1;
        Thu, 20 Jan 2022 02:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644521;
        bh=Z9huB5XFFpA6qnJjzCHNjvXXEguu4cL9VWWXsfmRC5s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HFrqKIrNSpyuNjvhWhFMD8B7gnYJiHyhWkk2QhKoQBHkvyu64ERaCQY5kq9MBTrUD
         ePVu0sWO/4uWy/rwdd8I9GboBHF4k45aDSsQ6qE6KOl5ZsBnajwlXxxWmOqRakVevb
         SmLGOzYFnDQRNRtFjjjN+yXgJIHNkmXhs210zD7Y=
Date:   Wed, 19 Jan 2022 18:08:40 -0800
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
Subject:  [patch 18/55] tools/testing/selftests/bpf: replace
 open-coded 16 with TASK_COMM_LEN
Message-ID: <20220120020840.Ztiy8H2wZ%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN

As the sched:sched_switch tracepoint args are derived from the kernel,
we'd better make it same with the kernel.  So the macro TASK_COMM_LEN is
converted to type enum, then all the BPF programs can get it through BTF.

The BPF program which wants to use TASK_COMM_LEN should include the header
vmlinux.h.  Regarding the test_stacktrace_map and test_tracepoint, as the
type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
need to include linux/bpf.h again.

Link: https://lkml.kernel.org/r/20211120112738.45980-8-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h                                   |    9 +++++++--
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c |    6 +++---
 tools/testing/selftests/bpf/progs/test_tracepoint.c     |    6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/include/linux/sched.h~tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len
+++ a/include/linux/sched.h
@@ -274,8 +274,13 @@ struct task_group;
 
 #define get_current_state()	READ_ONCE(current->__state)
 
-/* Task command name length: */
-#define TASK_COMM_LEN			16
+/*
+ * Define the task command name length as enum, then it can be visible to
+ * BPF programs.
+ */
+enum {
+	TASK_COMM_LEN = 16,
+};
 
 extern void scheduler_tick(void);
 
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c~tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len
+++ a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2018 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 #ifndef PERF_MAX_STACK_DEPTH
@@ -41,11 +41,11 @@ struct {
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
--- a/tools/testing/selftests/bpf/progs/test_tracepoint.c~tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len
+++ a/tools/testing/selftests/bpf/progs/test_tracepoint.c
@@ -1,17 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2017 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
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
_
