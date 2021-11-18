Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91D4C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABF261526
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhKRWg4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRWg4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:36:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37948600D4;
        Thu, 18 Nov 2021 22:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274835;
        bh=YdkYOJqVi9RoCJdFv85hTjlXkyXKqjwA1TvKISUw3Os=;
        h=Date:From:To:Subject:From;
        b=wphUXorpyPa32QM4Yb148qnU/s4mogVenrXRdRksvkD4Bic/SunhELvCbxl91kY74
         6bh88rLgJ6qCcQ1gEQCyP6QYH93rYToD7l0VzegHNI1Azfa42CsccGg2QVItK+0OxU
         fSMWPq5FBwux5fIPQrxUiMnuKfayM20Hx7+L7yh0=
Date:   Thu, 18 Nov 2021 14:33:54 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  +
 kthread-add-the-helper-function-kthread_run_on_cpu.patch added to -mm tree
Message-ID: <20211118223354.bFBuInnd0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add the helper function kthread_run_on_cpu()
has been added to the -mm tree.  Its filename is
     kthread-add-the-helper-function-kthread_run_on_cpu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread-add-the-helper-function-kthread_run_on_cpu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-the-helper-function-kthread_run_on_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cai Huoqing <caihuoqing@baidu.com>
Subject: kthread: add the helper function kthread_run_on_cpu()

the helper function kthread_run_on_cpu() includes
kthread_create_on_cpu/wake_up_process().  In some cases, use
kthread_run_on_cpu() directly instead of
kthread_create_on_node/kthread_bind/wake_up_process() or
kthread_create_on_cpu/wake_up_process() or
kthreadd_create/kthread_bind/wake_up_process() to simplify the code.

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
 1 file changed, 25 insertions(+)

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
_

Patches currently in -mm which might be from caihuoqing@baidu.com are

kthread-add-the-helper-function-kthread_run_on_cpu.patch
rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch
ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

