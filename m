Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6146C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiATVWo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiATVWo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C93C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D240DB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C8EC340E0;
        Thu, 20 Jan 2022 21:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713761;
        bh=gP9erQb+St2cRdVX7UAxFwRrdNaSioU9d06oPTplYhs=;
        h=Date:From:To:Subject:From;
        b=CkYTpE9ShpwAi/dAmFUMTuT3SMbHYb0k8CGORvvNYLXLfGMgHHypxc3QUGPQ3+kfY
         uTYS/Ix8fGsDB4gIyj6Ey4+IBlcWAqBGMLRBu74u3BZpVNlRLiGT/NNejun3dkay3P
         /GTWG8OadzO/uolilvGJ8P/FIt/czair94CHfb5E=
Date:   Thu, 20 Jan 2022 13:22:40 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  [merged]
 rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch removed
 from -mm tree
Message-ID: <20220120212240.yDZt-RZbm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/siw: make use of the helper function kthread_run_on_cpu()
has been removed from the -mm tree.  Its filename was
     rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from caihuoqing@baidu.com are


