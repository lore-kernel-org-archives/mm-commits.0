Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F92C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B29C61ACE
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhKRWhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRWhK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:37:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02F3B60EB4;
        Thu, 18 Nov 2021 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274849;
        bh=Ugc6lPXKvDXMhmXkUTW2Mz32QZQbIlgK3NGSIJV46tA=;
        h=Date:From:To:Subject:From;
        b=qurhXP5w47ETJCzzai0GbttdKUtVNPAB43Z/e+EjPz8GM1wGUqYqrcMpWhOeXjQ3b
         x9cIjdsXMcTuNcayiNmnxkgRb/Mu3hBWf7doeu7MhgqQ1xR93oGsKZjIrvqbC4dgDZ
         iMHmyWwFgwACqfjqq3GAIUNdo9B8KcznzHAGjzOY=
Date:   Thu, 18 Nov 2021 14:34:08 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  +
 trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch added
 to -mm tree
Message-ID: <20211118223408.qyV0Axazr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: trace/hwlat: make use of the helper function kthread_run_on_cpu()
has been added to the -mm tree.  Its filename is
     trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

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

Patches currently in -mm which might be from caihuoqing@baidu.com are

kthread-add-the-helper-function-kthread_run_on_cpu.patch
rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch
ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

