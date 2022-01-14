Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2636AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiANWDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57124 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWDG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A21AB82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71054C36AE5;
        Fri, 14 Jan 2022 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197784;
        bh=L8uhuIiq5lt0Fka3qsyxPXra33P+FdN1wYQH6JzvxuM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TGAaP0hQw9b4ib+V4YRN9Hf9ab/58ksKtl/gcLhP5a21+YUZ1gITvH0IA2mIrmTcQ
         0uLrtkWsJO6EqAeh2XPj3uGVzEdJIkoGs3MeVzzipAM0nH6eaLthPmxxtF3UNet3d6
         Kjw2gUVTSwRkXnKrpYvIC8tsw/yvDeim57+oiCgk=
Date:   Fri, 14 Jan 2022 14:03:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 004/146] rcutorture: make use of the helper
 function kthread_run_on_cpu()
Message-ID: <20220114220302.NBU0-uX6r%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
