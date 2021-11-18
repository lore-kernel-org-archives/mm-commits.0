Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E48C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5603061AA3
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhKRWhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRWhB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:37:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 077D361A79;
        Thu, 18 Nov 2021 22:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274840;
        bh=UGmnM32+9ESEMEXuCXnmoBpBvvf2UW2XjZaKAPYv1W8=;
        h=Date:From:To:Subject:From;
        b=S3q3TNrzH61uSm5s4wXdV2KchqHMzE4ti06BaBfdch3dF6mcbBI6JU5rONlAy++Rn
         xFo1zVOv04+b+IIXCBKzyMf8jGtW3S8Mvqu1svLErmMQOfDKKvdWD7VmofIavOL6mL
         2s7j5pFyXIv1m7zLb+rJsdGUVwblvXb4PzOvf3jc=
Date:   Thu, 18 Nov 2021 14:33:59 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  +
 ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch added
 to -mm tree
Message-ID: <20211118223359.JtxMwL6Yc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ring-buffer: make use of the helper function kthread_run_on_cpu()
has been added to the -mm tree.  Its filename is
     ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch

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
Subject: ring-buffer: make use of the helper function kthread_run_on_cpu()

Replace kthread_create/kthread_bind/wake_up_process() with
kthread_run_on_cpu() to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-4-caihuoqing@baidu.com
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
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

 kernel/trace/ring_buffer.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/trace/ring_buffer.c~ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu
+++ a/kernel/trace/ring_buffer.c
@@ -5898,16 +5898,13 @@ static __init int test_ringbuffer(void)
 		rb_data[cpu].buffer = buffer;
 		rb_data[cpu].cpu = cpu;
 		rb_data[cpu].cnt = cpu;
-		rb_threads[cpu] = kthread_create(rb_test, &rb_data[cpu],
-						 "rbtester/%d", cpu);
+		rb_threads[cpu] = kthread_run_on_cpu(rb_test, &rb_data[cpu],
+						     cpu, "rbtester/%u");
 		if (WARN_ON(IS_ERR(rb_threads[cpu]))) {
 			pr_cont("FAILED\n");
 			ret = PTR_ERR(rb_threads[cpu]);
 			goto out_free;
 		}
-
-		kthread_bind(rb_threads[cpu], cpu);
- 		wake_up_process(rb_threads[cpu]);
 	}
 
 	/* Now create the rb hammer! */
_

Patches currently in -mm which might be from caihuoqing@baidu.com are

kthread-add-the-helper-function-kthread_run_on_cpu.patch
rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch
ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

