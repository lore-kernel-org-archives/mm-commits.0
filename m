Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E936C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17FCA61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhKKCrO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CD361247;
        Thu, 11 Nov 2021 02:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598665;
        bh=y+NMZ8Yyk76+41E3cWdC2kNQ/7UKMy3AdJKynx/TerI=;
        h=Date:From:To:Subject:From;
        b=wfmde3KGEf0DGHxqzvUoVaMU35c9zvyE8tW/o/uEC6YlaDNkUkDcRHx1yYVpQ2utB
         R52Re+5uJbjV0yo3kD+WvU9EaTrS3+kTTkSoqgDpghfibxLTG8Vi9/gHaL1FF0ON0f
         eeEa6gO3RG90dUU4e0emUcH7URiHnGVk7XuXoccE=
Date:   Wed, 10 Nov 2021 18:44:25 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, mm-commits@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject:  [merged]
 mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch removed
 from -mm tree
Message-ID: <20211111024425.8u3gRXYvB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: use migrate_disable() in drain_local_pages_wq()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: page_alloc: use migrate_disable() in drain_local_pages_wq()

drain_local_pages_wq() disables preemption to avoid CPU migration during
CPU hotplug and can't use cpus_read_lock().

Using migrate_disable() works here, too.  The scheduler won't take the CPU
offline until the task left the migrate-disable section.  The problem with
disabled preemption here is that drain_local_pages() acquires locks which
are turned into sleeping locks on PREEMPT_RT and can't be acquired with
disabled preemption.

Use migrate_disable() in drain_local_pages_wq().

Link: https://lkml.kernel.org/r/20211015210933.viw6rjvo64qtqxn4@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq
+++ a/mm/page_alloc.c
@@ -3141,9 +3141,9 @@ static void drain_local_pages_wq(struct
 	 * cpu which is alright but we also have to make sure to not move to
 	 * a different one.
 	 */
-	preempt_disable();
+	migrate_disable();
 	drain_local_pages(drain->zone);
-	preempt_enable();
+	migrate_enable();
 }
 
 /*
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


