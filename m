From: akpm@linux-foundation.org
Subject: + mm-slab-freelist-randomization-v5.patch added to -mm tree
Date: Wed, 27 Apr 2016 12:16:28 -0700
Message-ID: <5721100c.ywbxoXrXnRlNcDQ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbcD0TQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thgarnie@google.com, cl@linux.com, gthelen@google.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: SLAB freelist randomization
has been added to the -mm tree.  Its filename is
     mm-slab-freelist-randomization-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-freelist-randomization-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-freelist-randomization-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Garnier <thgarnie@google.com>
Subject: mm: SLAB freelist randomization

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |    2 +-
 init/Kconfig             |    2 +-
 mm/slab.c                |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/slab_def.h~mm-slab-freelist-randomization-v5 include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-slab-freelist-randomization-v5
+++ a/include/linux/slab_def.h
@@ -80,7 +80,7 @@ struct kmem_cache {
 	struct kasan_cache kasan_info;
 #endif
 
-#ifdef CONFIG_FREELIST_RANDOM
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
 	void *random_seq;
 #endif
 
diff -puN init/Kconfig~mm-slab-freelist-randomization-v5 init/Kconfig
--- a/init/Kconfig~mm-slab-freelist-randomization-v5
+++ a/init/Kconfig
@@ -1742,7 +1742,7 @@ config SLOB
 
 endchoice
 
-config FREELIST_RANDOM
+config SLAB_FREELIST_RANDOM
 	default n
 	depends on SLAB
 	bool "SLAB freelist randomization"
diff -puN mm/slab.c~mm-slab-freelist-randomization-v5 mm/slab.c
--- a/mm/slab.c~mm-slab-freelist-randomization-v5
+++ a/mm/slab.c
@@ -1243,7 +1243,7 @@ static void __init set_up_node(struct km
 	}
 }
 
-#ifdef CONFIG_FREELIST_RANDOM
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
 static void freelist_randomize(struct rnd_state *state, freelist_idx_t *list,
 			size_t count)
 {
@@ -1295,7 +1295,7 @@ static inline int cache_random_seq_creat
 	return 0;
 }
 static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
-#endif /* CONFIG_FREELIST_RANDOM */
+#endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
 
 /*
@@ -2537,7 +2537,7 @@ static void cache_init_objs_debug(struct
 #endif
 }
 
-#ifdef CONFIG_FREELIST_RANDOM
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
 /* Hold information during a freelist initialization */
 union freelist_init_state {
 	struct {
@@ -2631,7 +2631,7 @@ static inline bool shuffle_freelist(stru
 {
 	return false;
 }
-#endif /* CONFIG_FREELIST_RANDOM */
+#endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
 static void cache_init_objs(struct kmem_cache *cachep,
 			    struct page *page)
_

Patches currently in -mm which might be from thgarnie@google.com are

mm-slab-freelist-randomization-v4.patch
mm-slab-freelist-randomization-v5.patch

