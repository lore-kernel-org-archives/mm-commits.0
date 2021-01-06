Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01A5C433DB
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBD52333B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbhAFVuE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbhAFVuE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 16:50:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048272332A;
        Wed,  6 Jan 2021 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609969757;
        bh=Db4WqwuRMUBEIewqJ8/WpOTXu2TrgcCWx0mxQuk9Od8=;
        h=Date:From:To:Subject:From;
        b=mM5zVGj2S/nTWhBPJVVmB9rUSDkAKKBTjQcfL+ToK7R4yyE6ztcU++6inyO0gxwCx
         3ztU58jPuZy+BbnafBFO7IB4qWwOhcOe9TREaK53pfvcMa9arTfWHOMPGcJqXzEzEp
         gdfRwWI6cxi22iiwYJAQic5lQPgfabiXnF2GI22k=
Date:   Wed, 06 Jan 2021 13:49:16 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
 added to -mm tree
Message-ID: <20210106214916.jAyr_OqMT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: make call_rcu() print mem_dump_obj() info for double-freed callback
has been added to the -mm tree.  Its filename is
     rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-mem_dump_obj-to-print-source-of-memory-block.patch
mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch
mm-make-mem_dump_obj-handle-vmalloc-memory.patch
mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch
rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch

