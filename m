Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDDBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347249AbiATVWq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiATVWp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:22:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA2C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7F536188A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69EAC340E0;
        Thu, 20 Jan 2022 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713764;
        bh=Qkubc0QW+pUTo2C/3TtQcx3qkWPY8wzzGf+PDmnusNk=;
        h=Date:From:To:Subject:From;
        b=Yz3ShHaLPY9UREwiZCrVMcbSRdtu3IUGyiRO+kC1RmuT9cBt74iSmcJymRGG39CYx
         rSECmbvIXDjPcC6k38A8Du8/we+HGICKuaL2Tei2k5WWubsGzL8TT/EOyqjq+nyRJi
         jd79W/4g9NbWU7/ve4+iUCXLc9F4mJ9jvh9nqIhY=
Date:   Thu, 20 Jan 2022 13:22:43 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  [merged]
 ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
 removed from -mm tree
Message-ID: <20220120212243.G7aHuD9CL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ring-buffer: make use of the helper function kthread_run_on_cpu()
has been removed from the -mm tree.  Its filename was
     ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


