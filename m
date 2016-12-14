From: akpm@linux-foundation.org
Subject: [merged] mm-add-vfree_atomic.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:54 -0800
Message-ID: <58519cc2.+PiSjg4Wa7zVNeg/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756614AbcLNTZz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vfree_atomic()
has been removed from the -mm tree.  Its filename was
     mm-add-vfree_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: add vfree_atomic()

We are going to use sleeping lock for freeing vmap. However some
vfree() users want to free memory from atomic (but not from interrupt)
context. For this we add vfree_atomic() - deferred variation of vfree()
which can be used in any atomic context (except NMIs).

[akpm@linux-foundation.org: tweak comment grammar]
[aryabinin@virtuozzo.com: use raw_cpu_ptr() instead of this_cpu_ptr()]
  Link: http://lkml.kernel.org/r/1481553981-3856-1-git-send-email-aryabinin@virtuozzo.com
Link: http://lkml.kernel.org/r/1479474236-4139-5-git-send-email-hch@lst.de
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 
 mm/vmalloc.c            |   42 ++++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 6 deletions(-)

diff -puN include/linux/vmalloc.h~mm-add-vfree_atomic include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-add-vfree_atomic
+++ a/include/linux/vmalloc.h
@@ -82,6 +82,7 @@ extern void *__vmalloc_node_range(unsign
 			const void *caller);
 
 extern void vfree(const void *addr);
+extern void vfree_atomic(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
diff -puN mm/vmalloc.c~mm-add-vfree_atomic mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vfree_atomic
+++ a/mm/vmalloc.c
@@ -1486,7 +1486,39 @@ static void __vunmap(const void *addr, i
 	kfree(area);
 	return;
 }
- 
+
+static inline void __vfree_deferred(const void *addr)
+{
+	/*
+	 * Use raw_cpu_ptr() because this can be called from preemptible
+	 * context. Preemption is absolutely fine here, because the llist_add()
+	 * implementation is lockless, so it works even if we are adding to
+	 * nother cpu's list.  schedule_work() should be fine with this too.
+	 */
+	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
+
+	if (llist_add((struct llist_node *)addr, &p->list))
+		schedule_work(&p->wq);
+}
+
+/**
+ *	vfree_atomic  -  release memory allocated by vmalloc()
+ *	@addr:		memory base address
+ *
+ *	This one is just like vfree() but can be called in any atomic context
+ *	except NMIs.
+ */
+void vfree_atomic(const void *addr)
+{
+	BUG_ON(in_nmi());
+
+	kmemleak_free(addr);
+
+	if (!addr)
+		return;
+	__vfree_deferred(addr);
+}
+
 /**
  *	vfree  -  release memory allocated by vmalloc()
  *	@addr:		memory base address
@@ -1509,11 +1541,9 @@ void vfree(const void *addr)
 
 	if (!addr)
 		return;
-	if (unlikely(in_interrupt())) {
-		struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
-		if (llist_add((struct llist_node *)addr, &p->list))
-			schedule_work(&p->wq);
-	} else
+	if (unlikely(in_interrupt()))
+		__vfree_deferred(addr);
+	else
 		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


