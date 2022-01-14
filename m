Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08975C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiANWC4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWC4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:02:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9B8C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6E64B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67BCC36AE9;
        Fri, 14 Jan 2022 22:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197773;
        bh=M50U5r7x5oJoUWEw7VcxXcqN6SqJM1Cm+EW7ABDoeLE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sHIIGvx31y98h6JICGIIcuLf02izC5wXBQYoayVZMMwo7ZCC1f3T4YIeslTa6W5c0
         ntQ6QYHK1dQ+WWCrcJZLD2WK7pj6NQP/z2FgHsvER+Lr58I0TWLPLBVbsidMtCX+b1
         C87JhHXX7VcoZy0+j4XaU5d3pQ0e2oXaGvgK71i0=
Date:   Fri, 14 Jan 2022 14:02:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 001/146] kthread: add the helper function
 kthread_run_on_cpu()
Message-ID: <20220114220252.FkLY1R14S%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>
Subject: kthread: add the helper function kthread_run_on_cpu()

the helper function kthread_run_on_cpu() includes
kthread_create_on_cpu/wake_up_process().  In some cases, use
kthread_run_on_cpu() directly instead of
kthread_create_on_node/kthread_bind/wake_up_process() or
kthread_create_on_cpu/wake_up_process() or
kthreadd_create/kthread_bind/wake_up_process() to simplify the code.

[akpm@linux-foundation.org: export kthread_create_on_cpu to modules]
Link: https://lkml.kernel.org/r/20211022025711.3673-2-caihuoqing@baidu.com
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Cai Huoqing <caihuoqing@baidu.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   25 +++++++++++++++++++++++++
 kernel/kthread.c        |    1 +
 2 files changed, 26 insertions(+)

--- a/include/linux/kthread.h~kthread-add-the-helper-function-kthread_run_on_cpu
+++ a/include/linux/kthread.h
@@ -56,6 +56,31 @@ bool kthread_is_per_cpu(struct task_stru
 	__k;								   \
 })
 
+/**
+ * kthread_run_on_cpu - create and wake a cpu bound thread.
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @cpu: The cpu on which the thread should be bound,
+ * @namefmt: printf-style name for the thread. Format is restricted
+ *	     to "name.*%u". Code fills in cpu number.
+ *
+ * Description: Convenient wrapper for kthread_create_on_cpu()
+ * followed by wake_up_process().  Returns the kthread or
+ * ERR_PTR(-ENOMEM).
+ */
+static inline struct task_struct *
+kthread_run_on_cpu(int (*threadfn)(void *data), void *data,
+			unsigned int cpu, const char *namefmt)
+{
+	struct task_struct *p;
+
+	p = kthread_create_on_cpu(threadfn, data, cpu, namefmt);
+	if (!IS_ERR(p))
+		wake_up_process(p);
+
+	return p;
+}
+
 void free_kthread_struct(struct task_struct *k);
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 void kthread_bind_mask(struct task_struct *k, const struct cpumask *mask);
--- a/kernel/kthread.c~kthread-add-the-helper-function-kthread_run_on_cpu
+++ a/kernel/kthread.c
@@ -523,6 +523,7 @@ struct task_struct *kthread_create_on_cp
 	to_kthread(p)->cpu = cpu;
 	return p;
 }
+EXPORT_SYMBOL(kthread_create_on_cpu);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu)
 {
_
