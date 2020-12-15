Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B49C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B340F22473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgLODNv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgLODNm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:42 -0500
Date:   Mon, 14 Dec 2020 19:12:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001957;
        bh=cw6um0UqT9NSn5cP936R8YMkm65JkIFjXM29KPi18FU=;
        h=From:To:Subject:In-Reply-To:From;
        b=05rfThwdQTMt+JLaiNZBTsAVUkxrWZ4uMfweWpMcvRqZQ4zybOZoN/xwfQreCaYok
         Mx+thVIP4V44mYSc5mVhp8AuWFOGoTs1KCW/K3YByezCQZyk2h+DvuUApLhXrODFil
         vXmXsSeajezg8bbrgY8YXOaNdAqF8jqz8g/fc1Tk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 158/200] z3fold: remove preempt disabled sections
 for RT
Message-ID: <20201215031236.oTlXy-8Lh%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
