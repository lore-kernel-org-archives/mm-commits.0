Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38913C352B3
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F62822DD6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgLOX7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727704AbgLOXWF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:05 -0500
Date:   Tue, 15 Dec 2020 15:20:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074413;
        bh=Pshiz8OCRMpwIu009lSJRN+6gTnxgy3QCEsWo12mU+c=;
        h=From:To:Subject:From;
        b=lxZZcvrjZN6RHNDfUvNzDMvcKyq/eoZTR7dlbpeJxldX0oYVukbuUaIm8ZVooQ6Zq
         AUnLDZww2kBmdknuPkXX3A+ke58/wXQfjeoeE8PJLiblVCPPvmwvw4s9uxBVAzc9a4
         kgivm38Tenz4KP4MWkwHxJwHLSCcRU791ekuDOok=
From:   akpm@linux-foundation.org
To:     david@redhat.com, longman@redhat.com, mm-commits@vger.kernel.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged] mm-vmalloc-fix-unlock-order-in-s_stop.patch
 removed from -mm tree
Message-ID: <20201215232013.7EVma7fF-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: Fix unlock order in s_stop()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-unlock-order-in-s_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/vmalloc: Fix unlock order in s_stop()

When multiple locks are acquired, they should be released in reverse
order. For s_start() and s_stop() in mm/vmalloc.c, that is not the
case.

  s_start: mutex_lock(&vmap_purge_lock); spin_lock(&vmap_area_lock);
  s_stop : mutex_unlock(&vmap_purge_lock); spin_unlock(&vmap_area_lock);

This unlock sequence, though allowed, is not optimal. If a waiter is
present, mutex_unlock() will need to go through the slowpath of waking
up the waiter with preemption disabled. Fix that by releasing the
spinlock first before the mutex.

Link: https://lkml.kernel.org/r/20201213180843.16938-1-longman@redhat.com
Fixes: e36176be1c39 ("mm/vmalloc: rework vmap_area_lock")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-unlock-order-in-s_stop
+++ a/mm/vmalloc.c
@@ -3465,11 +3465,11 @@ static void *s_next(struct seq_file *m,
 }
 
 static void s_stop(struct seq_file *m, void *p)
-	__releases(&vmap_purge_lock)
 	__releases(&vmap_area_lock)
+	__releases(&vmap_purge_lock)
 {
-	mutex_unlock(&vmap_purge_lock);
 	spin_unlock(&vmap_area_lock);
+	mutex_unlock(&vmap_purge_lock);
 }
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
_

Patches currently in -mm which might be from longman@redhat.com are


