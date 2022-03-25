Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ACCC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiCYBfA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357387AbiCYBdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B6BF036
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06280B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9E4C340ED;
        Fri, 25 Mar 2022 01:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171932;
        bh=jnVjovNQCxk3/nlKJrrbRgWlDqwotureYNz5EOVqQ+Y=;
        h=Date:To:From:Subject:From;
        b=HiM9imuLZRILQstc6V5LWwo90h7u2/EOiRXSd+SbMEK4OOzycVldnhk4zSy8eSDbY
         A9zVHvNwKzfmBOCJN/VnsTqC/WFwv2/bzUScIdIFRAGRrunsffZcUxds+lbg4lORjZ
         qOFSeq1xmexu2A4IqONqJm/5uy412z5C+9yUH6gs=
Date:   Thu, 24 Mar 2022 18:32:12 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch removed from -mm tree
Message-Id: <20220325013212.9A9E4C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: replace IRQ-off check with a lockdep assert.
has been removed from the -mm tree.  Its filename was
     mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -433,6 +433,8 @@ struct list_lru shadow_nodes;
 
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


