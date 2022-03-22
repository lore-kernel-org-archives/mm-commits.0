Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B59C43219
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiCVVr0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiCVVrV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D655F8C1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 574B0B81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6EAC340F2;
        Tue, 22 Mar 2022 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985551;
        bh=5y73nK+IfYhE2dzuCLdG3voFW/Zf/4PV3Up3kcCaWYI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=sjtkuscVntASDfgT3zmiaNhOOI6kH82m0qm0MTFbnF2tmYxduAtM419gkhGLEi5JB
         NXfq3dZkh2PAY1+SfTIufW58Lpgn5RlbGbSWaNBMsg6hGCxcY2BYnvXZTvOWbumwxR
         HoHjrdtu3koKT0HSbslAl2ytwOO8dusRMgdw7ihA=
Date:   Tue, 22 Mar 2022 14:45:50 -0700
To:     tj@kernel.org, tglx@linutronix.de, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 144/227] mm: workingset: replace IRQ-off check with a lockdep assert.
Message-Id: <20220322214551.0E6EAC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
