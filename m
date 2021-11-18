Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29ACC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A9E61A79
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhKRWg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRWg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:36:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3E8C61181;
        Thu, 18 Nov 2021 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274838;
        bh=uAjyTTzANkH3COqowlTA8jYx+CzAjkK+Q4IwN7iLHKc=;
        h=Date:From:To:Subject:From;
        b=leKYB46lW6Dt5BIsx9M8+nN6vMDM3F1uGjLzSho3yorg3ddOXZBdKNcwtXqXMnRZs
         2+gzr3UNGdJ1PSFjqNsU8bFu+ap7GpWGSZnZV+V6m0Q3/nw9KOHGEhGAJ6aTU4sAui
         5pG7h+DzRDRE/RXZZoWbhcMlVsivrDKrP08hI5TU=
Date:   Thu, 18 Nov 2021 14:33:57 -0800
From:   akpm@linux-foundation.org
To:     bmt@zurich.ibm.com, bristot@kernel.org, caihuoqing@baidu.com,
        dave@stgolabs.net, dledford@redhat.com, jgg@ziepe.ca,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org
Subject:  +
 rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch added to
 -mm tree
Message-ID: <20211118223357._CKCYAVq3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/siw: make use of the helper function kthread_run_on_cpu()
has been added to the -mm tree.  Its filename is
     rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch

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

kthread-add-the-helper-function-kthread_run_on_cpu.patch
rdma-siw-make-use-of-the-helper-function-kthread_run_on_cpu.patch
ring-buffer-make-use-of-the-helper-function-kthread_run_on_cpu.patch
rcutorture-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-osnoise-make-use-of-the-helper-function-kthread_run_on_cpu.patch
trace-hwlat-make-use-of-the-helper-function-kthread_run_on_cpu.patch

