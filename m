From: akpm@linux-foundation.org
Subject: + mm-reorganize-slab-freelist-randomization-fix.patch added to
 -mm tree
Date: Tue, 07 Jun 2016 13:12:49 -0700
Message-ID: <57572ac1.l0KYHuO34qXGuXh/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162054AbcFGUMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 16:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, penberg@kernel.org, rientjes@google.com, thgarnie@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-freelist-randomization-fix
has been added to the -mm tree.  Its filename is
     mm-reorganize-slab-freelist-randomization-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reorganize-slab-freelist-randomization-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reorganize-slab-freelist-randomization-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-freelist-randomization-fix

freelist_randomize(), cache_random_seq_create() and
cache_random_seq_destroy() should not be inside CONFIG_SLABINFO.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   94 ++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff -puN mm/slab_common.c~mm-reorganize-slab-freelist-randomization-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-reorganize-slab-freelist-randomization-fix
+++ a/mm/slab_common.c
@@ -1030,6 +1030,53 @@ void *kmalloc_order_trace(size_t size, g
 EXPORT_SYMBOL(kmalloc_order_trace);
 #endif
 
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+/* Randomize a generic freelist */
+static void freelist_randomize(struct rnd_state *state, unsigned int *list,
+			size_t count)
+{
+	size_t i;
+	unsigned int rand;
+
+	for (i = 0; i < count; i++)
+		list[i] = i;
+
+	/* Fisher-Yates shuffle */
+	for (i = count - 1; i > 0; i--) {
+		rand = prandom_u32_state(state);
+		rand %= (i + 1);
+		swap(list[i], list[rand]);
+	}
+}
+
+/* Create a random sequence per cache */
+int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
+				    gfp_t gfp)
+{
+	struct rnd_state state;
+
+	if (count < 2 || cachep->random_seq)
+		return 0;
+
+	cachep->random_seq = kcalloc(count, sizeof(unsigned int), gfp);
+	if (!cachep->random_seq)
+		return -ENOMEM;
+
+	/* Get best entropy at this stage of boot */
+	prandom_seed_state(&state, get_random_long());
+
+	freelist_randomize(&state, cachep->random_seq, count);
+	return 0;
+}
+
+/* Destroy the per-cache random freelist sequence */
+void cache_random_seq_destroy(struct kmem_cache *cachep)
+{
+	kfree(cachep->random_seq);
+	cachep->random_seq = NULL;
+}
+#endif /* CONFIG_SLAB_FREELIST_RANDOM */
+
 #ifdef CONFIG_SLABINFO
 
 #ifdef CONFIG_SLAB
@@ -1142,53 +1189,6 @@ int memcg_slab_show(struct seq_file *m,
 }
 #endif
 
-#ifdef CONFIG_SLAB_FREELIST_RANDOM
-/* Randomize a generic freelist */
-static void freelist_randomize(struct rnd_state *state, unsigned int *list,
-			size_t count)
-{
-	size_t i;
-	unsigned int rand;
-
-	for (i = 0; i < count; i++)
-		list[i] = i;
-
-	/* Fisher-Yates shuffle */
-	for (i = count - 1; i > 0; i--) {
-		rand = prandom_u32_state(state);
-		rand %= (i + 1);
-		swap(list[i], list[rand]);
-	}
-}
-
-/* Create a random sequence per cache */
-int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
-				    gfp_t gfp)
-{
-	struct rnd_state state;
-
-	if (count < 2 || cachep->random_seq)
-		return 0;
-
-	cachep->random_seq = kcalloc(count, sizeof(unsigned int), gfp);
-	if (!cachep->random_seq)
-		return -ENOMEM;
-
-	/* Get best entropy at this stage of boot */
-	prandom_seed_state(&state, get_random_long());
-
-	freelist_randomize(&state, cachep->random_seq, count);
-	return 0;
-}
-
-/* Destroy the per-cache random freelist sequence */
-void cache_random_seq_destroy(struct kmem_cache *cachep)
-{
-	kfree(cachep->random_seq);
-	cachep->random_seq = NULL;
-}
-#endif /* CONFIG_SLAB_FREELIST_RANDOM */
