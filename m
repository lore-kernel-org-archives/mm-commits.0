Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18DEC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94BBD610FF
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhHEXi2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239396AbhHEXi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B6E60E53;
        Thu,  5 Aug 2021 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206693;
        bh=c7X1dKUPLfV4/CpTbeSeLHOjOTZz9TF6RcC44slLJVo=;
        h=Date:From:To:Subject:From;
        b=moFjJMXN1dcx0zUHjhjgwjeTxiRbQ8gkpKpwVh5eU6abS19o9ZHzfVeU1bpbRjS46
         PrLI6XsHDEaOx8RxG4ADrghkpr/BaZngWnpZxCuuwFd/0hnZsPDoTUu9sytrG2d70l
         CcVFn6EfhYQCVAH/wlesE1yEZT7QeP+rYEazxzBk=
Date:   Thu, 05 Aug 2021 16:38:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
 added to -mm tree
Message-ID: <20210805233812.BTXzG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
has been added to the -mm tree.  Its filename is
     mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg

Jann Horn reported [1] the following theoretically possible race:

  task A: put_cpu_partial() calls preempt_disable()
  task A: oldpage = this_cpu_read(s->cpu_slab->partial)
  interrupt: kfree() reaches unfreeze_partials() and discards the page
  task B (on another CPU): reallocates page as page cache
  task A: reads page->pages and page->pobjects, which are actually
  halves of the pointer page->lru.prev
  task B (on another CPU): frees page
  interrupt: allocates page as SLUB page and places it on the percpu partial list
  task A: this_cpu_cmpxchg() succeeds

  which would cause page->pages and page->pobjects to end up containing
  halves of pointers that would then influence when put_cpu_partial()
  happens and show up in root-only sysfs files. Maybe that's acceptable,
  I don't know. But there should probably at least be a comment for now
  to point out that we're reading union fields of a page that might be
  in a completely different state.

Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() is only
safe against s->cpu_slab->partial manipulation in ___slab_alloc() if the
latter disables irqs, otherwise a __slab_free() in an irq handler could
call put_cpu_partial() in the middle of ___slab_alloc() manipulating
->partial and corrupt it.  This becomes an issue on RT after a local_lock
is introduced in later patch.  The fix means taking the local_lock also in
put_cpu_partial() on RT.

After debugging this issue, Mike Galbraith suggested [2] that to avoid
different locking schemes on RT and !RT, we can just protect
put_cpu_partial() with disabled irqs (to be converted to
local_lock_irqsave() later) everywhere.  This should be acceptable as it's
not a fast path, and moving the actual partial unfreezing outside of the
irq disabled section makes it short, and with the retry loop gone the code
can be also simplified.  In addition, the race reported by Jann should no
longer be possible.

[1] https://lore.kernel.org/lkml/CAG48ez1mvUuXwg0YPH5ANzhQLpbphqk-ZS+jbRz+H66fvm4FcA@mail.gmail.com/
[2] https://lore.kernel.org/linux-rt-users/e3470ab357b48bccfbd1f5133b982178a7d2befb.camel@gmx.de/

Link: https://lkml.kernel.org/r/20210805152000.12817-34-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Mike Galbraith <efault@gmx.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   83 ++++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 38 deletions(-)

--- a/mm/slub.c~mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg
+++ a/mm/slub.c
@@ -2006,7 +2006,12 @@ static inline void *acquire_slab(struct
 	return freelist;
 }
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+#else
+static inline void put_cpu_partial(struct kmem_cache *s, struct page *page,
+				   int drain) { }
+#endif
 static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
 
 /*
@@ -2440,14 +2445,6 @@ static void unfreeze_partials_cpu(struct
 		__unfreeze_partials(s, partial_page);
 }
 
-#else	/* CONFIG_SLUB_CPU_PARTIAL */
-
-static inline void unfreeze_partials(struct kmem_cache *s) { }
-static inline void unfreeze_partials_cpu(struct kmem_cache *s,
-				  struct kmem_cache_cpu *c) { }
-
-#endif	/* CONFIG_SLUB_CPU_PARTIAL */
-
 /*
  * Put a page that was just frozen (in __slab_free|get_partial_node) into a
  * partial page slot if available.
@@ -2457,46 +2454,56 @@ static inline void unfreeze_partials_cpu
  */
 static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
-#ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *oldpage;
-	int pages;
-	int pobjects;
+	struct page *page_to_unfreeze = NULL;
+	unsigned long flags;
+	int pages = 0;
+	int pobjects = 0;
 
-	preempt_disable();
-	do {
-		pages = 0;
-		pobjects = 0;
-		oldpage = this_cpu_read(s->cpu_slab->partial);
+	local_irq_save(flags);
+
+	oldpage = this_cpu_read(s->cpu_slab->partial);
 
-		if (oldpage) {
+	if (oldpage) {
+		if (drain && oldpage->pobjects > slub_cpu_partial(s)) {
+			/*
+			 * Partial array is full. Move the existing set to the
+			 * per node partial list. Postpone the actual unfreezing
+			 * outside of the critical section.
+			 */
+			page_to_unfreeze = oldpage;
+			oldpage = NULL;
+		} else {
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
-			if (drain && pobjects > slub_cpu_partial(s)) {
-				/*
-				 * partial array is full. Move the existing
-				 * set to the per node partial list.
-				 */
-				unfreeze_partials(s);
-				oldpage = NULL;
-				pobjects = 0;
-				pages = 0;
-				stat(s, CPU_PARTIAL_DRAIN);
-			}
 		}
+	}
 
-		pages++;
-		pobjects += page->objects - page->inuse;
+	pages++;
+	pobjects += page->objects - page->inuse;
 
-		page->pages = pages;
-		page->pobjects = pobjects;
-		page->next = oldpage;
-
-	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
-								!= oldpage);
-	preempt_enable();
-#endif	/* CONFIG_SLUB_CPU_PARTIAL */
+	page->pages = pages;
+	page->pobjects = pobjects;
+	page->next = oldpage;
+
+	this_cpu_write(s->cpu_slab->partial, page);
+
+	local_irq_restore(flags);
+
+	if (page_to_unfreeze) {
+		__unfreeze_partials(s, page_to_unfreeze);
+		stat(s, CPU_PARTIAL_DRAIN);
+	}
 }
 
+#else	/* CONFIG_SLUB_CPU_PARTIAL */
+
+static inline void unfreeze_partials(struct kmem_cache *s) { }
+static inline void unfreeze_partials_cpu(struct kmem_cache *s,
+				  struct kmem_cache_cpu *c) { }
+
+#endif	/* CONFIG_SLUB_CPU_PARTIAL */
+
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
 			      bool lock)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch
mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

