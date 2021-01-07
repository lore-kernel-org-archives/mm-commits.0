Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868C4C4332D
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E2223603
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbhAGWd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGWd1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:33:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9662E23603;
        Thu,  7 Jan 2021 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058766;
        bh=JywOZgK/5nTOctFINXLsPt0mlYqh96JPkwgCgVHz1Yw=;
        h=Date:From:To:Subject:From;
        b=rzZ8sdZwbIqVpStPQthQq446GtdXHh8E+OjLzzhnsORa2fK/dDaATnka9Ub+9FG8a
         St9ZrKDLdnvwjU1BqXpm4MC9jtuySf3hMmFf0CaaY0xukiAxuvqupxnRO9kTaMAR3D
         d39ofiDcPbUS4ZMMY3kcyz0G3ESvoMZaW9ll3VxY=
Date:   Thu, 07 Jan 2021 14:32:46 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
 removed from -mm tree
Message-ID: <20210107223246.ntwjh8TcN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: make call_rcu() print mem_dump_obj() info for double-freed callback
has been removed from the -mm tree.  Its filename was
     rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: rcu: make call_rcu() print mem_dump_obj() info for double-freed callback

The debug-object double-free checks in __call_rcu() print out the RCU
callback function, which is usually sufficient to track down the double
free.  However, all uses of things like queue_rcu_work() will have the
same RCU callback function (rcu_work_rcufn() in this case), so a
diagnostic message for a double queue_rcu_work() needs more than just the
callback function.

This commit therefore calls mem_dump_obj() to dump out any additional
available information on the double-freed callback.

Link: https://lkml.kernel.org/r/20210106011750.13709-5-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/rcu/tree.c~rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback
+++ a/kernel/rcu/tree.c
@@ -2941,6 +2941,7 @@ static void check_cb_ovld(struct rcu_dat
 static void
 __call_rcu(struct rcu_head *head, rcu_callback_t func)
 {
+	static atomic_t doublefrees;
 	unsigned long flags;
 	struct rcu_data *rdp;
 	bool was_alldone;
@@ -2954,8 +2955,10 @@ __call_rcu(struct rcu_head *head, rcu_ca
 		 * Use rcu:rcu_callback trace event to find the previous
 		 * time callback was passed to __call_rcu().
 		 */
-		WARN_ONCE(1, "__call_rcu(): Double-freed CB %p->%pS()!!!\n",
-			  head, head->func);
+		if (atomic_inc_return(&doublefrees) < 4) {
+			pr_err("%s(): Double-freed CB %p->%pS()!!!  ", __func__, head, head->func);
+			mem_dump_obj(head);
+		}
 		WRITE_ONCE(head->func, rcu_leak_callback);
 		return;
 	}
_

Patches currently in -mm which might be from paulmck@kernel.org are


