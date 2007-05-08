From: akpm@linux-foundation.org
Subject: + slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch added to -mm tree
Date: Tue, 08 May 2007 14:49:01 -0700
Message-ID: <200705082149.l48Ln1SX002641@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968372AbXEHVtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: move tracking definitions and check_valid_pointer() away from debug code
has been added to the -mm tree.  Its filename is
     slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: move tracking definitions and check_valid_pointer() away from debug code
From: Christoph Lameter <clameter@sgi.com>

Move the tracking definitions and the check_valid_pointer() function away from
the debugging related functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   58 ++++++++++++++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff -puN mm/slub.c~slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code mm/slub.c
--- a/mm/slub.c~slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code
+++ a/mm/slub.c
@@ -190,6 +190,18 @@ static enum {
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
@@ -218,6 +230,23 @@ static inline struct kmem_cache_node *ge
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
@@ -285,18 +314,6 @@ static void print_section(char *text, u8
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
@@ -431,23 +448,6 @@ static int check_bytes(u8 *start, unsign
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
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
