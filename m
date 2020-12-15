Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ED9C49EBB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F2822D74
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLOX7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729506AbgLOXZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:07 -0500
Date:   Tue, 15 Dec 2020 15:23:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074581;
        bh=84m4OrgOaC33qTc70MxwGL4wOJnt/xFXbskqYtncFic=;
        h=From:To:Subject:From;
        b=tCTdj4KFgNO/Sh5atU//eKHX5/6aNRDg8vHgidyu64rixXVOXp4QFZBjCfB7W4Yr+
         cto0T+8LDZ4naGoLewZ5WR21WOJ88a56dsP//QIUK4e1stfpOjiClsQpRSjnThDJ6G
         dxwwq17Gureo11IhtkDk1wG7SP9bo+UbfQaBj5ZI=
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 z3fold-remove-preempt-disabled-sections-for-rt.patch removed from -mm tree
Message-ID: <20201215232301.otMQJb_PC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: remove preempt disabled sections for RT
has been removed from the -mm tree.  Its filename was
     z3fold-remove-preempt-disabled-sections-for-rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.com>
Subject: z3fold: remove preempt disabled sections for RT

Replace get_cpu_ptr() with migrate_disable()+this_cpu_ptr() so RT can take
spinlocks that become sleeping locks.

Signed-off-by Mike Galbraith <efault@gmx.de>
Link: https://lkml.kernel.org/r/20201209145151.18994-3-vitaly.wool@konsulko.com
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/z3fold.c~z3fold-remove-preempt-disabled-sections-for-rt
+++ a/mm/z3fold.c
@@ -623,14 +623,16 @@ static inline void add_to_unbuddied(stru
 {
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0 ||
 			zhdr->middle_chunks == 0) {
-		struct list_head *unbuddied = get_cpu_ptr(pool->unbuddied);
-
+		struct list_head *unbuddied;
 		int freechunks = num_free_chunks(zhdr);
+
+		migrate_disable();
+		unbuddied = this_cpu_ptr(pool->unbuddied);
 		spin_lock(&pool->lock);
 		list_add(&zhdr->buddy, &unbuddied[freechunks]);
 		spin_unlock(&pool->lock);
 		zhdr->cpu = smp_processor_id();
-		put_cpu_ptr(pool->unbuddied);
+		migrate_enable();
 	}
 }
 
@@ -880,8 +882,9 @@ static inline struct z3fold_header *__z3
 	int chunks = size_to_chunks(size), i;
 
 lookup:
+	migrate_disable();
 	/* First, try to find an unbuddied z3fold page. */
-	unbuddied = get_cpu_ptr(pool->unbuddied);
+	unbuddied = this_cpu_ptr(pool->unbuddied);
 	for_each_unbuddied_list(i, chunks) {
 		struct list_head *l = &unbuddied[i];
 
@@ -899,7 +902,7 @@ lookup:
 		    !z3fold_page_trylock(zhdr)) {
 			spin_unlock(&pool->lock);
 			zhdr = NULL;
-			put_cpu_ptr(pool->unbuddied);
+			migrate_enable();
 			if (can_sleep)
 				cond_resched();
 			goto lookup;
@@ -913,7 +916,7 @@ lookup:
 		    test_bit(PAGE_CLAIMED, &page->private)) {
 			z3fold_page_unlock(zhdr);
 			zhdr = NULL;
-			put_cpu_ptr(pool->unbuddied);
+			migrate_enable();
 			if (can_sleep)
 				cond_resched();
 			goto lookup;
@@ -928,7 +931,7 @@ lookup:
 		kref_get(&zhdr->refcount);
 		break;
 	}
-	put_cpu_ptr(pool->unbuddied);
+	migrate_enable();
 
 	if (!zhdr) {
 		int cpu;
_

Patches currently in -mm which might be from vitaly.wool@konsulko.com are


