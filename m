Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F13C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 18:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiCASNO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 13:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiCASNL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 13:13:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A2B6514C
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 10:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF053B81BF2
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 18:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB8C340EE;
        Tue,  1 Mar 2022 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646158347;
        bh=mkSeu8saSGZWuHAeaXWmcIg3hb52ymdWIzp36lH6mGI=;
        h=Date:To:From:Subject:From;
        b=UtnGGq9CzJ/QCHTtNTH81TvtRuqgvfKKM63/vOGvN9uYyLCcAhZlyUeWijY0fFma9
         N09OxAufMQt9a6hAYyXi9fVfHXf0wmtFroj6zMkkGMr7tMgszvwTT4al56mgMGjCQb
         BnufF6m7dFWrrXzZSMsOY+F/QXZ/MCsLvlI2AASw=
Date:   Tue, 01 Mar 2022 10:12:26 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch added to -mm tree
Message-Id: <20220301181227.8DEB8C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: replace IRQ-off check with a lockdep assert.
has been added to the -mm tree.  Its filename is
     mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: workingset: replace IRQ-off check with a lockdep assert.

Commit 68d48e6a2df57 ("mm: workingset: add vmstat counter for shadow
nodes") introduced an IRQ-off check to ensure that a lock is held which
also disabled interrupts.  This does not work the same way on PREEMPT_RT
because none of the locks, that are held, disable interrupts.

Replace this check with a lockdep assert which ensures that the lock is
held.

Link: https://lkml.kernel.org/r/20220301122143.1521823-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/workingset.c~mm-workingset-replace-irq-off-check-with-a-lockdep-assert
+++ a/mm/workingset.c
@@ -433,6 +433,8 @@ static struct list_lru shadow_nodes;
 
 void workingset_update_node(struct xa_node *node)
 {
+	struct address_space *mapping;
+
 	/*
 	 * Track non-empty nodes that contain only shadow entries;
 	 * unlink those that contain pages or are being freed.
@@ -441,7 +443,8 @@ void workingset_update_node(struct xa_no
 	 * already where they should be. The list_empty() test is safe
 	 * as node->private_list is protected by the i_pages lock.
 	 */
-	VM_WARN_ON_ONCE(!irqs_disabled());  /* For __inc_lruvec_page_state */
+	mapping = container_of(node->array, struct address_space, i_pages);
+	lockdep_assert_held(&mapping->i_pages.xa_lock);
 
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch
cgroup-use-irqsave-in-cgroup_rstat_flush_locked.patch
mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch

