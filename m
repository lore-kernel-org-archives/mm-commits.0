Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC15C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiANWDD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44774 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiANWDB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10DCE61FF0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB76BC36AE5;
        Fri, 14 Jan 2022 22:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197780;
        bh=A5j0iXSb71HCjCe29rW2IIzeZqi11B2GacRE/qA5+tQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JRxuJiz/8epe+gGw3IOCLJ2cSlLEDitSszf1O3TV8OOI2NS1DQ/SAQhIftVzioJIy
         Uop/lpaW5/MxmJukGxKK75SPuCz6o8Q2Aj+eeXskyf3Q06CxYOR2lPn/kRb59gBq2T
         zBroNw1KSEGGShFDaHaVdwyi9/XBpzde48SYZbdQ=
Date:   Fri, 14 Jan 2022 14:02:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 003/146] ring-buffer: make use of the helper
 function kthread_run_on_cpu()
Message-ID: <20220114220259.m6-lQwjxH%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
