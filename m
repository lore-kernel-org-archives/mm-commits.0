Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA1AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 610D761AA3
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhKRWhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRWhE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:37:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C27E61A6C;
        Thu, 18 Nov 2021 22:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274843;
        bh=fBDSyQwKW5UrY7irfMb/kQUTug9y2SZ2hA7r1+DS2jY=;
        h=Date:From:To:Subject:From;
        b=ir5Jc5216vxtnQJp8pXRUcp1oZzqritZoblp0aPpsleXEX05T9pY47lkZ1gXxLZqr
         CmASu3rycY7Kg8FqpIMsXmjbUU2sAzBh76ypepy0w4buRg31nORALEU117tc/bqXAo
         CGngYytwOtwTueE8I0d15peTrxuiPrgoEJHGCinI=
Date:   Thu, 18 Nov 2021 14:34:02 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  +
 rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch added
 to -mm tree
Message-ID: <20211118223402.FYJkK4IPs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcutorture: make use of the helper function kthread_run_on_cpu()
has been added to the -mm tree.  Its filename is
     rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch

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
Subject: rcutorture: make use of the helper function kthread_run_on_cpu()

Replace kthread_create_on_node/kthread_bind/wake_up_process() with
kthread_run_on_cpu() to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-5-caihuoqing@baidu.com
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

 kernel/rcu/rcutorture.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/rcu/rcutorture.c~rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu
+++ a/kernel/rcu/rcutorture.c
@@ -1992,9 +1992,8 @@ static int rcutorture_booster_init(unsig
 	mutex_lock(&boost_mutex);
 	rcu_torture_disable_rt_throttle();
 	VERBOSE_TOROUT_STRING("Creating rcu_torture_boost task");
-	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
-						  cpu_to_node(cpu),
-						  "rcu_torture_boost");
+	boost_tasks[cpu] = kthread_run_on_cpu(rcu_torture_boost, NULL,
+					      cpu, "rcu_torture_boost_%u");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
 		VERBOSE_TOROUT_STRING("rcu_torture_boost task create failed");
@@ -2003,8 +2002,6 @@ static int rcutorture_booster_init(unsig
 		mutex_unlock(&boost_mutex);
 		return retval;
 	}
-	kthread_bind(boost_tasks[cpu], cpu);
-	wake_up_process(boost_tasks[cpu]);
 	mutex_unlock(&boost_mutex);
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

