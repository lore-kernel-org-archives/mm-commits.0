Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA48C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiANWC6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:02:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWC5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:02:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832BD61FEE
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FFBC36AE9;
        Fri, 14 Jan 2022 22:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197776;
        bh=sGsAq+0wKXeYRkrjJAef+zs4S7vgZ9DsnZbpsQb14OU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WQNl6nB0Vj/1xOaKobpAEpI0BZ0YOVVcZWRWD5zU6VH52FZX9+kYxMq3+fxzaxeXw
         VIxiJEi0xntXKNIPr4Wsl5nBhovnw70ZMWQCt6RhIyuioGa64R/nhwFZAKIiVM21Q/
         ZHlm84kNE9KaHbEei/ksSi/b26Py8lW6e5bZ8xFo=
Date:   Fri, 14 Jan 2022 14:02:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bmt@zurich.ibm.com, bristot@kernel.org,
        caihuoqing@baidu.com, dave@stgolabs.net, dledford@redhat.com,
        jgg@ziepe.ca, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 002/146] RDMA/siw: make use of the helper function
 kthread_run_on_cpu()
Message-ID: <20220114220255.ZPEpuUjOn%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>
Subject: RDMA/siw: make use of the helper function kthread_run_on_cpu()

Replace kthread_create/kthread_bind/wake_up_process() with
kthread_run_on_cpu() to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-3-caihuoqing@baidu.com
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

 drivers/infiniband/sw/siw/siw_main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_main.c~rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu
+++ a/drivers/infiniband/sw/siw/siw_main.c
@@ -98,15 +98,14 @@ static int siw_create_tx_threads(void)
 			continue;
 
 		siw_tx_thread[cpu] =
-			kthread_create(siw_run_sq, (unsigned long *)(long)cpu,
-				       "siw_tx/%d", cpu);
+			kthread_run_on_cpu(siw_run_sq,
+					   (unsigned long *)(long)cpu,
+					   cpu, "siw_tx/%u");
 		if (IS_ERR(siw_tx_thread[cpu])) {
 			siw_tx_thread[cpu] = NULL;
 			continue;
 		}
-		kthread_bind(siw_tx_thread[cpu], cpu);
 
-		wake_up_process(siw_tx_thread[cpu]);
 		assigned++;
 	}
 	return assigned;
_
