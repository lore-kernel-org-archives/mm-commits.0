Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06B7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiANWDN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWDN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F05B82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A7C36AE9;
        Fri, 14 Jan 2022 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197791;
        bh=GAVMvjSqQb3qKYqLPSoXyCyjKQXix2PTQ97z3GBGXaY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=O76iebov87USnie3YmN6n3CaBXftL772S9mKOI+eFfcHJoL+yZxeQ8/mYuZ8xzjn+
         actYmcKn8P3TwxFj10Mry+jByftsqyr8Hv4L6GQ/aVvSATfuYg80e9sy/1NhVsue1J
         ABppWfrzOYtxin7oKi9Xso3UGOhrqGxCyOKvZsOM=
Date:   Fri, 14 Jan 2022 14:03:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 006/146] trace/hwlat: make use of the helper
 function kthread_run_on_cpu()
Message-ID: <20220114220310.cKAJFgLZs%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>
Subject: trace/hwlat: make use of the helper function kthread_run_on_cpu()

Replace kthread_create_on_cpu/wake_up_process() with kthread_run_on_cpu()
to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-7-caihuoqing@baidu.com
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

 kernel/trace/trace_hwlat.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/trace_hwlat.c~trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu
+++ a/kernel/trace/trace_hwlat.c
@@ -491,18 +491,14 @@ static void stop_per_cpu_kthreads(void)
 static int start_cpu_kthread(unsigned int cpu)
 {
 	struct task_struct *kthread;
-	char comm[24];
 
-	snprintf(comm, 24, "hwlatd/%d", cpu);
-
-	kthread = kthread_create_on_cpu(kthread_fn, NULL, cpu, comm);
+	kthread = kthread_run_on_cpu(kthread_fn, NULL, cpu, "hwlatd/%u");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
 		return -ENOMEM;
 	}
 
 	per_cpu(hwlat_per_cpu_data, cpu).kthread = kthread;
-	wake_up_process(kthread);
 
 	return 0;
 }
_
