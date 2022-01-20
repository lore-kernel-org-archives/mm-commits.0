Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2840BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbiATVWs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiATVWs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:22:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF36461898
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA168C340E0;
        Thu, 20 Jan 2022 21:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713767;
        bh=H3qgPBJp7OOyPG5y0otM4z00NE5jdCM03nRN0BoGrGc=;
        h=Date:From:To:Subject:From;
        b=Uez5/fMMXw6w97P8ETzSDwYPWRTWvB9cCfA8KpedcdNxj0ztB4E+ZtcmgRszDLN/R
         zMFrmoaRW3W/MHshkaV9AIDfN4g0L7Z7bR+UIQRGB7JK/ZyGPRDZV83WV8yDL/jya1
         SFYD8+lRhgmCljCvdZhPUDJCLI0+ngCOVJbat6Ng=
Date:   Thu, 20 Jan 2022 13:22:46 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  [merged]
 rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch removed
 from -mm tree
Message-ID: <20220120212246.MK07wJYAM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcutorture: make use of the helper function kthread_run_on_cpu()
has been removed from the -mm tree.  Its filename was
     rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


