From: akpm@linux-foundation.org
Subject: + slub-convert-slab_debug_free-to-slab_consistency_checks.patch
 added to -mm tree
Date: Wed, 17 Feb 2016 12:05:04 -0800
Message-ID: <56c4d270.NZkEQkNgI0mhnRn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965265AbcBQUFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 15:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: convert SLAB_DEBUG_FREE to SLAB_CONSISTENCY_CHECKS
has been added to the -mm tree.  Its filename is
     slub-convert-slab_debug_free-to-slab_consistency_checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-convert-slab_debug_free-to-slab_consistency_checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-convert-slab_debug_free-to-slab_consistency_checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: slub: convert SLAB_DEBUG_FREE to SLAB_CONSISTENCY_CHECKS

SLAB_DEBUG_FREE allows expensive consistency checks at free to be turned
on or off.  Expand its use to be able to turn off all consistency checks. 
This gives a nice speed up if you only want features such as poisoning or
tracing.

Credit to Mathias Krause for the original work which inspired this series

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.txt |    4 -
 include/linux/slab.h      |    2 
 mm/slab.h                 |    5 +
 mm/slub.c                 |   94 ++++++++++++++++++++++--------------
 tools/vm/slabinfo.c       |    2 
 5 files changed, 66 insertions(+), 41 deletions(-)

diff -puN Documentation/vm/slub.txt~slub-convert-slab_debug_free-to-slab_consistency_checks Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~slub-convert-slab_debug_free-to-slab_consistency_checks
+++ a/Documentation/vm/slub.txt
@@ -35,8 +35,8 @@ slub_debug=<Debug-Options>,<slab name>
 				Enable options only for select slabs
 
 Possible debug options are
-	F		Sanity checks on (enables SLAB_DEBUG_FREE. Sorry
-			SLAB legacy issues)
+	F		Sanity checks on (enables SLAB_DEBUG_CONSISTENCY_CHECKS
+			Sorry SLAB legacy issues)
 	Z		Red zoning
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
diff -puN include/linux/slab.h~slub-convert-slab_debug_free-to-slab_consistency_checks include/linux/slab.h
--- a/include/linux/slab.h~slub-convert-slab_debug_free-to-slab_consistency_checks
+++ a/include/linux/slab.h
@@ -20,7 +20,7 @@
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
-#define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#define SLAB_CONSISTENCY_CHECKS	0x00000100UL	/* DEBUG: Perform (expensive) checks on alloc/free */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
diff -puN mm/slab.h~slub-convert-slab_debug_free-to-slab_consistency_checks mm/slab.h
--- a/mm/slab.h~slub-convert-slab_debug_free-to-slab_consistency_checks
+++ a/mm/slab.h
@@ -125,7 +125,7 @@ static inline unsigned long kmem_cache_f
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
 #elif defined(CONFIG_SLUB_DEBUG)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_DEBUG_FREE)
+			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
 #else
 #define SLAB_DEBUG_FLAGS (0)
 #endif
@@ -311,7 +311,8 @@ static inline struct kmem_cache *cache_f
 	 * to not do even the assignment. In that case, slab_equal_or_root
 	 * will also be a constant.
 	 */
-	if (!memcg_kmem_enabled() && !unlikely(s->flags & SLAB_DEBUG_FREE))
+	if (!memcg_kmem_enabled() &&
+	    !unlikely(s->flags & SLAB_CONSISTENCY_CHECKS))
 		return s;
 
 	page = virt_to_head_page(x);
diff -puN mm/slub.c~slub-convert-slab_debug_free-to-slab_consistency_checks mm/slub.c
--- a/mm/slub.c~slub-convert-slab_debug_free-to-slab_consistency_checks
+++ a/mm/slub.c
@@ -160,7 +160,7 @@ static inline bool kmem_cache_has_cpu_pa
  */
 #define MAX_PARTIAL 10
 
-#define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
+#define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 
 /*
@@ -1007,20 +1007,32 @@ static void setup_object_debug(struct km
 	init_tracking(s, object);
 }
 
-static noinline int alloc_debug_processing(struct kmem_cache *s,
+static inline int alloc_consistency_checks(struct kmem_cache *s,
 					struct page *page,
 					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
-		goto bad;
+		return 0;
 
 	if (!check_valid_pointer(s, page, object)) {
 		object_err(s, page, object, "Freelist Pointer check fails");
-		goto bad;
+		return 0;
 	}
 
 	if (!check_object(s, page, object, SLUB_RED_INACTIVE))
-		goto bad;
+		return 0;
+
+	return 1;
+}
+
+static noinline int alloc_debug_processing(struct kmem_cache *s,
+					struct page *page,
+					void *object, unsigned long addr)
+{
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!alloc_consistency_checks(s, page, object, addr))
+			goto bad;
+	}
 
 	/* Success perform special debug activities for allocs */
 	if (s->flags & SLAB_STORE_USER)
@@ -1043,39 +1055,21 @@ bad:
 	return 0;
 }
 
-/* Supports checking bulk free of a constructed freelist */
-static noinline int free_debug_processing(
-	struct kmem_cache *s, struct page *page,
-	void *head, void *tail, int bulk_cnt,
-	unsigned long addr)
+static inline int free_consistency_checks(struct kmem_cache *s,
+		struct page *page, void *object, unsigned long addr)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-	void *object = head;
-	int cnt = 0;
-	unsigned long uninitialized_var(flags);
-	int ret = 0;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	slab_lock(page);
-
-	if (!check_slab(s, page))
-		goto out;
-
-next_object:
-	cnt++;
-
 	if (!check_valid_pointer(s, page, object)) {
 		slab_err(s, page, "Invalid object pointer 0x%p", object);
-		goto out;
+		return 0;
 	}
 
 	if (on_freelist(s, page, object)) {
 		object_err(s, page, object, "Object already free");
-		goto out;
+		return 0;
 	}
 
 	if (!check_object(s, page, object, SLUB_RED_ACTIVE))
-		goto out;
+		return 0;
 
 	if (unlikely(s != page->slab_cache)) {
 		if (!PageSlab(page)) {
@@ -1088,7 +1082,37 @@ next_object:
 		} else
 			object_err(s, page, object,
 					"page slab pointer corrupt.");
-		goto out;
+		return 0;
+	}
+	return 1;
+}
+
+/* Supports checking bulk free of a constructed freelist */
+static noinline int free_debug_processing(
+	struct kmem_cache *s, struct page *page,
+	void *head, void *tail, int bulk_cnt,
+	unsigned long addr)
+{
+	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	void *object = head;
+	int cnt = 0;
+	unsigned long uninitialized_var(flags);
+	int ret = 0;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	slab_lock(page);
+
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!check_slab(s, page))
+			goto out;
+	}
+
+next_object:
+	cnt++;
+
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!free_consistency_checks(s, page, object, addr))
+			goto out;
 	}
 
 	if (s->flags & SLAB_STORE_USER)
@@ -1145,7 +1169,7 @@ static int __init setup_slub_debug(char
 	for (; *str && *str != ','; str++) {
 		switch (tolower(*str)) {
 		case 'f':
-			slub_debug |= SLAB_DEBUG_FREE;
+			slub_debug |= SLAB_CONSISTENCY_CHECKS;
 			break;
 		case 'z':
 			slub_debug |= SLAB_RED_ZONE;
@@ -1449,7 +1473,7 @@ static void __free_slab(struct kmem_cach
 	int order = compound_order(page);
 	int pages = 1 << order;
 
-	if (kmem_cache_debug(s)) {
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
 		void *p;
 
 		slab_pad_check(s, page);
@@ -4769,16 +4793,16 @@ SLAB_ATTR_RO(total_objects);
 
 static ssize_t sanity_checks_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DEBUG_FREE));
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_CONSISTENCY_CHECKS));
 }
 
 static ssize_t sanity_checks_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	s->flags &= ~SLAB_DEBUG_FREE;
+	s->flags &= ~SLAB_CONSISTENCY_CHECKS;
 	if (buf[0] == '1') {
 		s->flags &= ~__CMPXCHG_DOUBLE;
-		s->flags |= SLAB_DEBUG_FREE;
+		s->flags |= SLAB_CONSISTENCY_CHECKS;
 	}
 	return length;
 }
@@ -5313,7 +5337,7 @@ static char *create_unique_id(struct kme
 		*p++ = 'd';
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		*p++ = 'a';
-	if (s->flags & SLAB_DEBUG_FREE)
+	if (s->flags & SLAB_CONSISTENCY_CHECKS)
 		*p++ = 'F';
 	if (!(s->flags & SLAB_NOTRACK))
 		*p++ = 't';
diff -puN tools/vm/slabinfo.c~slub-convert-slab_debug_free-to-slab_consistency_checks tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~slub-convert-slab_debug_free-to-slab_consistency_checks
+++ a/tools/vm/slabinfo.c
@@ -135,7 +135,7 @@ static void usage(void)
 		"\nValid debug options (FZPUT may be combined)\n"
 		"a / A          Switch on all debug options (=FZUP)\n"
 		"-              Switch off all debug options\n"
-		"f / F          Sanity Checks (SLAB_DEBUG_FREE)\n"
+		"f / F          Sanity Checks (SLAB_CONSISTENCY_CHECKS)\n"
 		"z / Z          Redzoning\n"
 		"p / P          Poisoning\n"
 		"u / U          Tracking\n"
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

