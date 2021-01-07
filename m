Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC32CC433E6
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE90236F9
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbhAGWd6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGWd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:33:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F10223601;
        Thu,  7 Jan 2021 22:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058769;
        bh=H4jgyd7IykIyGU+ScMw5NOTroQJzLM3TMQFNWAm1Zes=;
        h=Date:From:To:Subject:From;
        b=RkXk5zx7IhSUYn+zAGwVB9QmBy6kESe3N4R3MqHu1ZjxeJTsOfpDJYd7mgawonw1h
         HMOwoanCUVIEs7eXO/4qKERIxyIHGsY6EyqtwfAZ3WWm4foh3/pcBHw4nZ50iKiSq5
         pliPToZfBk8lCOJ3NslnWPNY4LtFLA0p705Pss+I=
Date:   Thu, 07 Jan 2021 14:32:49 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch
 removed from -mm tree
Message-ID: <20210107223249.kxVr7w66T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_ref: dump mem_dump_obj() info upon reference-count underflow
has been removed from the -mm tree.  Its filename was
     percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: percpu_ref: dump mem_dump_obj() info upon reference-count underflow

Reference-count underflow for percpu_ref is detected in the RCU callback
percpu_ref_switch_to_atomic_rcu(), and the resulting warning does not
print anything allowing easy identification of which percpu_ref use case
is underflowing.  This is of course not normally a problem when developing
a new percpu_ref use case because it is most likely that the problem
resides in this new use case.  However, when deploying a new kernel to a
large set of servers, the underflow might well be a new corner case in any
of the old percpu_ref use cases.

This commit therefore calls mem_dump_obj() to dump out any additional
available information on the underflowing percpu_ref instance.

Link: https://lkml.kernel.org/r/20210106011750.13709-6-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/percpu-refcount.c~percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow
+++ a/lib/percpu-refcount.c
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/percpu-refcount.h>
 
 /*
@@ -168,6 +169,7 @@ static void percpu_ref_switch_to_atomic_
 			struct percpu_ref_data, rcu);
 	struct percpu_ref *ref = data->ref;
 	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
+	static atomic_t underflows;
 	unsigned long count = 0;
 	int cpu;
 
@@ -191,9 +193,13 @@ static void percpu_ref_switch_to_atomic_
 	 */
 	atomic_long_add((long)count - PERCPU_COUNT_BIAS, &data->count);
 
-	WARN_ONCE(atomic_long_read(&data->count) <= 0,
-		  "percpu ref (%ps) <= 0 (%ld) after switching to atomic",
-		  data->release, atomic_long_read(&data->count));
+	if (WARN_ONCE(atomic_long_read(&data->count) <= 0,
+		      "percpu ref (%ps) <= 0 (%ld) after switching to atomic",
+		      data->release, atomic_long_read(&data->count)) &&
+	    atomic_inc_return(&underflows) < 4) {
+		pr_err("%s(): percpu_ref underflow", __func__);
+		mem_dump_obj(data);
+	}
 
 	/* @ref is viewed as dead on all CPUs, send out switch confirmation */
 	percpu_ref_call_confirm_rcu(rcu);
_

Patches currently in -mm which might be from paulmck@kernel.org are


