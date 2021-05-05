Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CAC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C6E61429
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhEEBlV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232220AbhEEBlV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27B3E61421;
        Wed,  5 May 2021 01:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178825;
        bh=tfdbJkuFH3/dByCU6kEhVjxSiwnbikqzqjqb0+Os5rs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0HB3c3+X6qusO9G3GOKAlOpFj4VclS3rNMvejgPEmCQutBuH0/lcqYoTiEwcc9LoV
         D2Sn29ukF33OO89jRtRcFa00yObvqSbwf1vlOi/pyEtt5beYkjW2iFogBE5+qMw1B/
         g2z7jkl03d/g4tpObASctpsPnIk2pM4MVQizvDIE=
Date:   Tue, 04 May 2021 18:40:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, hdanton@sina.com, jannh@google.com,
        linux-mm@kvack.org, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 142/143] kfence: maximize allocation wait timeout
 duration
Message-ID: <20210505014024.lgQWcD2gw%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: maximize allocation wait timeout duration

The allocation wait timeout was initially added because of warnings due to
CONFIG_DETECT_HUNG_TASK=y [1].  While the 1 sec timeout is sufficient to
resolve the warnings (given the hung task timeout must be 1 sec or larger)
it may cause unnecessary wake-ups if the system is idle.  [1]
https://lkml.kernel.org/r/CADYN=9J0DQhizAGB0-jz4HOBBh+05kMBXb4c0cXMS7Qi5NAJiw@mail.gmail.com

Fix it by computing the timeout duration in terms of the current
sysctl_hung_task_timeout_secs value.

Link: https://lkml.kernel.org/r/20210421105132.3965998-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-maximize-allocation-wait-timeout-duration
+++ a/mm/kfence/core.c
@@ -20,6 +20,7 @@
 #include <linux/moduleparam.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -621,7 +622,16 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate), HZ);
+	if (sysctl_hung_task_timeout_secs) {
+		/*
+		 * During low activity with no allocations we might wait a
+		 * while; let's avoid the hung task warning.
+		 */
+		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+				   sysctl_hung_task_timeout_secs * HZ / 2);
+	} else {
+		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+	}
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
_
