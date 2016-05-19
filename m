From: akpm@linux-foundation.org
Subject: [folded-merged] mm-slab-freelist-randomization-v5.patch removed
 from -mm tree
Date: Thu, 19 May 2016 16:37:34 -0700
Message-ID: <573e4e3e.KSdO0HmhRc9C7AEa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thgarnie@google.com, cl@linux.com, gthelen@google.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: SLAB freelist randomization
has been removed from the -mm tree.  Its filename was
     mm-slab-freelist-randomization-v5.patch

This patch was dropped because it was folded into mm-slab-freelist-randomization-v4.patch

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

