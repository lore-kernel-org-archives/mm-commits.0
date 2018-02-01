From: akpm@linux-foundation.org
Subject: [patch 026/119] mm/slab_common.c: make
 calculate_alignment() static
Date: Wed, 31 Jan 2018 16:15:36 -0800
Message-ID: <20180201001536.wvDVhYVL_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAPi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhlee.kernel@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Byongho Lee <bhlee.kernel@gmail.com>
Subject: mm/slab_common.c: make calculate_alignment() static

calculate_alignment() function is only used inside slab_common.c.  So make
it static and let the compiler do more optimizations.

After this patch there's a small improvement in text and data size.

$ gcc --version
  gcc (GCC) 7.2.1 20171128

Before:
  text	   data	    bss	    dec	     hex	filename
  9890457  3828702  1212364 14931523 e3d643	vmlinux

After:
  text	   data	    bss	    dec	     hex	filename
  9890437  3828670  1212364 14931471 e3d60f	vmlinux

Also I fixed a style problem reported by checkpatch.

  WARNING: Missing a blank line after declarations
  #53: FILE: mm/slab_common.c:286:
  +		unsigned long ralign = cache_line_size();
  +		while (size <= ralign / 2)

Link: http://lkml.kernel.org/r/20171210080132.406-1-bhlee.kernel@gmail.com
Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    3 --
 mm/slab_common.c |   56 +++++++++++++++++++++++----------------------
 2 files changed, 29 insertions(+), 30 deletions(-)

diff -puN mm/slab_common.c~mm-slab-make-calculate_alignment-function-static mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-make-calculate_alignment-function-static
+++ a/mm/slab_common.c
@@ -268,6 +268,35 @@ static inline void memcg_unlink_cache(st
 #endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 /*
+ * Figure out what the alignment of the objects will be given a set of
+ * flags, a user specified alignment and the size of the objects.
+ */
+static unsigned long calculate_alignment(unsigned long flags,
+		unsigned long align, unsigned long size)
+{
+	/*
+	 * If the user wants hardware cache aligned objects then follow that
+	 * suggestion if the object is sufficiently large.
+	 *
+	 * The hardware cache alignment cannot override the specified
+	 * alignment though. If that is greater then use it.
+	 */
+	if (flags & SLAB_HWCACHE_ALIGN) {
+		unsigned long ralign;
+
+		ralign = cache_line_size();
+		while (size <= ralign / 2)
+			ralign /= 2;
+		align = max(align, ralign);
+	}
+
+	if (align < ARCH_SLAB_MINALIGN)
+		align = ARCH_SLAB_MINALIGN;
+
+	return ALIGN(align, sizeof(void *));
+}
+
+/*
  * Find a mergeable slab cache
  */
 int slab_unmergeable(struct kmem_cache *s)
@@ -337,33 +366,6 @@ struct kmem_cache *find_mergeable(size_t
 	return NULL;
 }
 
-/*
- * Figure out what the alignment of the objects will be given a set of
- * flags, a user specified alignment and the size of the objects.
- */
-unsigned long calculate_alignment(slab_flags_t flags,
-		unsigned long align, unsigned long size)
-{
-	/*
-	 * If the user wants hardware cache aligned objects then follow that
-	 * suggestion if the object is sufficiently large.
-	 *
-	 * The hardware cache alignment cannot override the specified
-	 * alignment though. If that is greater then use it.
-	 */
-	if (flags & SLAB_HWCACHE_ALIGN) {
-		unsigned long ralign = cache_line_size();
-		while (size <= ralign / 2)
-			ralign /= 2;
-		align = max(align, ralign);
-	}
-
-	if (align < ARCH_SLAB_MINALIGN)
-		align = ARCH_SLAB_MINALIGN;
-
-	return ALIGN(align, sizeof(void *));
-}
-
 static struct kmem_cache *create_cache(const char *name,
 		size_t object_size, size_t size, size_t align,
 		slab_flags_t flags, void (*ctor)(void *),
diff -puN mm/slab.h~mm-slab-make-calculate_alignment-function-static mm/slab.h
--- a/mm/slab.h~mm-slab-make-calculate_alignment-function-static
+++ a/mm/slab.h
@@ -78,9 +78,6 @@ extern const struct kmalloc_info_struct
 	unsigned long size;
 } kmalloc_info[];
 
-unsigned long calculate_alignment(slab_flags_t flags,
-		unsigned long align, unsigned long size);
