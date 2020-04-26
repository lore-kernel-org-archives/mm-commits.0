From: akpm@linux-foundation.org
Subject: +
 slub-remove-kmalloc-under-list_lock-from-list_slab_objects.patch added to
 -mm tree
Date: Sat, 25 Apr 2020 20:16:55 -0700
Message-ID: <20200426031655.OTxHAfNFf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgDZDQ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 23:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, penberg@kernel.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, yuzhao@google.com


The patch titled
     Subject: slub: remove kmalloc under list_lock from list_slab_objects() V2
has been added to the -mm tree.  Its filename is
     slub-remove-kmalloc-under-list_lock-from-list_slab_objects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-remove-kmalloc-under-list_lock-from-list_slab_objects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-remove-kmalloc-under-list_lock-from-list_slab_objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christopher Lameter <cl@linux.com>
Subject: slub: remove kmalloc under list_lock from list_slab_objects() V2

list_slab_objects() is called when a slab is destroyed and there are
objects still left to list the objects in the syslog.  This is a pretty
rare event.

And there it seems we take the list_lock and call kmalloc while holding
that lock.

Perform the allocation in free_partial() before the list_lock is taken.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.2002031721250.1668@www.lameter.com
Fixes: bbd7d57bfe852d9788bae5fb171c7edb4021d8ac ("slub: Potential stack overflow")
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/slub.c~slub-remove-kmalloc-under-list_lock-from-list_slab_objects
+++ a/mm/slub.c
@@ -3751,12 +3751,14 @@ error:
 }
 
 static void list_slab_objects(struct kmem_cache *s, struct page *page,
-							const char *text)
+			      const char *text, unsigned long *map)
 {
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
 	void *p;
-	unsigned long *map;
+
+	if (!map)
+		return;
 
 	slab_err(s, page, text, s->name);
 	slab_lock(page);
@@ -3769,8 +3771,6 @@ static void list_slab_objects(struct kme
 			print_tracking(s, p);
 		}
 	}
-	put_map(map);
-
 	slab_unlock(page);
 #endif
 }
@@ -3784,6 +3784,11 @@ static void free_partial(struct kmem_cac
 {
 	LIST_HEAD(discard);
 	struct page *page, *h;
+	unsigned long *map = NULL;
+
+#ifdef CONFIG_SLUB_DEBUG
+	map = bitmap_alloc(oo_objects(s->max), GFP_KERNEL);
+#endif
 
 	BUG_ON(irqs_disabled());
 	spin_lock_irq(&n->list_lock);
@@ -3793,11 +3798,16 @@ static void free_partial(struct kmem_cac
 			list_add(&page->slab_list, &discard);
 		} else {
 			list_slab_objects(s, page,
-			"Objects remaining in %s on __kmem_cache_shutdown()");
+			  "Objects remaining in %s on __kmem_cache_shutdown()",
+			  map);
 		}
 	}
 	spin_unlock_irq(&n->list_lock);
 
+#ifdef CONFIG_SLUB_DEBUG
+	bitmap_free(map);
+#endif
+
 	list_for_each_entry_safe(page, h, &discard, slab_list)
 		discard_slab(s, page);
 }
_

Patches currently in -mm which might be from cl@linux.com are

slub-remove-userspace-notifier-for-cache-add-remove.patch
slub-remove-kmalloc-under-list_lock-from-list_slab_objects.patch
