Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EB5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiANWDJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWDJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CF4C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F5161FEE
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2FEC36AE9;
        Fri, 14 Jan 2022 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197787;
        bh=TCCbkQv3Z5Jyic4DQgXlZXah5HWhZHvALS2kVOtzjzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fTuvFWFrAoWVU2Qmp2FbZXBvLQ9sQwovpg8fohQY99QtBhyaHWnmhOdQkh+SUbxez
         hbTz6wDnf3oEmqFfrEAHbPcoobzWJ1lSpJMigXbV4/UentfIM8vw615KgyHzV8Q8Zy
         +nVPx1uZoZXLNK8Yh6NfSQ0VrAqSsHVyC8d/Qios=
Date:   Fri, 14 Jan 2022 14:03:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 005/146] trace/osnoise: make use of the helper
 function kthread_run_on_cpu()
Message-ID: <20220114220306.E3xj0fyX8%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
