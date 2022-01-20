Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881ABC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiATVWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377801AbiATVWx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:22:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2E9C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:22:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 862D5B81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2460C340E0;
        Thu, 20 Jan 2022 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713770;
        bh=4RU9PnIOMHXNNhMGBcq/C7EhTYYRA+GJ3rtX/fh2Q90=;
        h=Date:From:To:Subject:From;
        b=RCI8yjlIZAxRJKIZVkZV+e9v9YHD3b1ikATJYNn2TSI6Pu0l04i6r6pGIxwYgL37f
         jtO4yhVcMFeQm2e2jHnXG1MihKD38kIItLededUDihCNVNO3xmBYfjBgWAJaUvJZbK
         bh8Y5V8hPr9DG+2P0T0au6sHqz6YrblvloYV+O4Q=
Date:   Thu, 20 Jan 2022 13:22:49 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  [merged]
 trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch
 removed from -mm tree
Message-ID: <20220120212249.TjzBAlOCS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: trace/osnoise: make use of the helper function kthread_run_on_cpu()
has been removed from the -mm tree.  Its filename was
     trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cai Huoqing <caihuoqing@baidu.com>
Subject: trace/osnoise: make use of the helper function kthread_run_on_cpu()

Replace kthread_create_on_cpu/wake_up_process() with kthread_run_on_cpu()
to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-6-caihuoqing@baidu.com
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

 kernel/trace/trace_osnoise.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_osnoise.c~trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu
+++ a/kernel/trace/trace_osnoise.c
@@ -1701,7 +1701,7 @@ static int start_kthread(unsigned int cp
 		snprintf(comm, 24, "osnoise/%d", cpu);
 	}
 
-	kthread = kthread_create_on_cpu(main, NULL, cpu, comm);
+	kthread = kthread_run_on_cpu(main, NULL, cpu, comm);
 
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
@@ -1710,7 +1710,6 @@ static int start_kthread(unsigned int cp
 	}
 
 	per_cpu(per_cpu_osnoise_var, cpu).kthread = kthread;
-	wake_up_process(kthread);
 
 	return 0;
 }
_

Patches currently in -mm which might be from caihuoqing@baidu.com are


