Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA16C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjBCGn6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBCGm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EE223D88
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B4AF61DB0
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74145C433EF;
        Fri,  3 Feb 2023 06:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406312;
        bh=L+yiTkY1Kuf2jRb2MTANQm31xHQvCqKw8SHb+eFa+U0=;
        h=Date:To:From:Subject:From;
        b=i0M/lXpEfCQton38eq3uRNaEmopXuhQBekGJuLurqk2zjpPR1j6cR4RfqDjGX6rz6
         5u9Xhv+nLNwyp/VwnTpnTUcOuVakpvXnRd2e4eI0fFuZygQB8uh87FACpjbjgo0M6D
         uQMKb5ktjROLzn3ZlqrOwDhfVl66LLCBskD91D0A=
Date:   Thu, 02 Feb 2023 22:38:31 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__vfree_deferred.patch removed from -mm tree
Message-Id: <20230203063832.74145C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove __vfree_deferred
has been removed from the -mm tree.  Its filename was
     mm-remove-__vfree_deferred.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove __vfree_deferred
Date: Sat, 21 Jan 2023 08:10:44 +0100

Fold __vfree_deferred into vfree_atomic, and call vfree_atomic early on
from vfree if called from interrupt context so that the extra low-level
helper can be avoided.

Link: https://lkml.kernel.org/r/20230121071051.1143058-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-remove-__vfree_deferred
+++ a/mm/vmalloc.c
@@ -2754,20 +2754,6 @@ static void __vunmap(const void *addr, i
 	kfree(area);
 }
 
-static inline void __vfree_deferred(const void *addr)
-{
-	/*
-	 * Use raw_cpu_ptr() because this can be called from preemptible
-	 * context. Preemption is absolutely fine here, because the llist_add()
-	 * implementation is lockless, so it works even if we are adding to
-	 * another cpu's list. schedule_work() should be fine with this too.
-	 */
-	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
-
-	if (llist_add((struct llist_node *)addr, &p->list))
-		schedule_work(&p->wq);
-}
-
 /**
  * vfree_atomic - release memory allocated by vmalloc()
  * @addr:	  memory base address
@@ -2777,13 +2763,19 @@ static inline void __vfree_deferred(cons
  */
 void vfree_atomic(const void *addr)
 {
-	BUG_ON(in_nmi());
+	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
+	BUG_ON(in_nmi());
 	kmemleak_free(addr);
 
-	if (!addr)
-		return;
-	__vfree_deferred(addr);
+	/*
+	 * Use raw_cpu_ptr() because this can be called from preemptible
+	 * context. Preemption is absolutely fine here, because the llist_add()
+	 * implementation is lockless, so it works even if we are adding to
+	 * another cpu's list. schedule_work() should be fine with this too.
+	 */
+	if (addr && llist_add((struct llist_node *)addr, &p->list))
+		schedule_work(&p->wq);
 }
 
 /**
@@ -2805,17 +2797,16 @@ void vfree_atomic(const void *addr)
  */
 void vfree(const void *addr)
 {
-	BUG_ON(in_nmi());
+	if (unlikely(in_interrupt())) {
+		vfree_atomic(addr);
+		return;
+	}
 
+	BUG_ON(in_nmi());
 	kmemleak_free(addr);
+	might_sleep();
 
-	might_sleep_if(!in_interrupt());
-
-	if (!addr)
-		return;
-	if (unlikely(in_interrupt()))
-		__vfree_deferred(addr);
-	else
+	if (addr)
 		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
_

Patches currently in -mm which might be from hch@lst.de are


