From: akpm@linux-foundation.org
Subject: - slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:09 -0700
Message-ID: <200705092148.l49Lm9Hx002552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203AbXEIVsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: move tracking definitions and check_valid_pointer() away from debug code
has been removed from the -mm tree.  Its filename was
     slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: move tracking definitions and check_valid_pointer() away from debug code
From: Christoph Lameter <clameter@sgi.com>

Move the tracking definitions and the check_valid_pointer() function away from
the debugging related functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   58 ++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN mm/slub.c~slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code mm/slub.c
--- a/mm/slub.c~slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code
+++ a/mm/slub.c
@@ -195,6 +195,18 @@ static enum {
 static DECLARE_RWSEM(slub_lock);
 LIST_HEAD(slab_caches);
 
+/*
+ * Tracking user of a slab.
+ */
+struct track {
+	void *addr;		/* Called from address */
+	int cpu;		/* Was running on cpu */
+	int pid;		/* Pid context */
+	unsigned long when;	/* When did the operation occur */
+};
+
+enum track_item { TRACK_ALLOC, TRACK_FREE };
+
 #ifdef CONFIG_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
@@ -223,6 +235,23 @@ static inline struct kmem_cache_node *ge
 #endif
 }
 
+static inline int check_valid_pointer(struct kmem_cache *s,
+				struct page *page, const void *object)
+{
+	void *base;
+
+	if (!object)
+		return 1;
+
+	base = page_address(page);
+	if (object < base || object >= base + s->objects * s->size ||
+		(object - base) % s->size) {
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * Slow version of get and set free pointer.
  *
@@ -290,18 +319,6 @@ static void print_section(char *text, u8
 	}
 }
 
-/*
- * Tracking user of a slab.
- */
-struct track {
-	void *addr;		/* Called from address */
-	int cpu;		/* Was running on cpu */
-	int pid;		/* Pid context */
-	unsigned long when;	/* When did the operation occur */
-};
-
-enum track_item { TRACK_ALLOC, TRACK_FREE };
-
 static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
@@ -436,23 +453,6 @@ static int check_bytes(u8 *start, unsign
 	return 1;
 }
 
-static inline int check_valid_pointer(struct kmem_cache *s,
-				struct page *page, const void *object)
-{
-	void *base;
-
-	if (!object)
-		return 1;
-
-	base = page_address(page);
-	if (object < base || object >= base + s->objects * s->size ||
-		(object - base) % s->size) {
-		return 0;
-	}
-
-	return 1;
-}
-
 /*
  * Object layout:
  *
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
