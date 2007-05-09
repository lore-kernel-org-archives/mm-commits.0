From: akpm@linux-foundation.org
Subject: - increase-slab-redzone-to-64bits.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:29 -0700
Message-ID: <200705090243.l492hTBB008478@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970027AbXEICnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, clameter@engr.sgi.com, davem@davemloft.net, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Increase slab redzone to 64bits
has been removed from the -mm tree.  Its filename was
     increase-slab-redzone-to-64bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Increase slab redzone to 64bits
From: David Woodhouse <dwmw2@infradead.org>

There are two problems with the existing redzone implementation.

Firstly, it's causing misalignment of structures which contain a 64-bit
integer, such as netfilter's 'struct ipt_entry' -- causing netfilter
modules to fail to load because of the misalignment.  (In particular, the
first check in
net/ipv4/netfilter/ip_tables.c::check_entry_size_and_hooks())

On ppc32 and sparc32, amongst others, __alignof__(uint64_t) == 8.

With slab debugging, we use 32-bit redzones. And allocated slab objects
aren't sufficiently aligned to hold a structure containing a uint64_t.

By _just_ setting ARCH_KMALLOC_MINALIGN to __alignof__(u64) we'd disable
redzone checks on those architectures.  By using 64-bit redzones we avoid that
loss of debugging, and also fix the other problem while we're at it.

When investigating this, I noticed that on 64-bit platforms we're using a
32-bit value of RED_ACTIVE/RED_INACTIVE in the 64-bit memory location set
aside for the redzone.  Which means that the four bytes immediately before
or after the allocated object at 0x00,0x00,0x00,0x00 for LE and BE
machines, respectively.  Which is probably not the most useful choice of
poison value.

One way to fix both of those at once is just to switch to 64-bit
redzones in all cases.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 +--
 mm/slab.c              |   42 +++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 21 deletions(-)

diff -puN include/linux/poison.h~increase-slab-redzone-to-64bits include/linux/poison.h
--- a/include/linux/poison.h~increase-slab-redzone-to-64bits
+++ a/include/linux/poison.h
@@ -15,8 +15,8 @@
  * Magic nums for obj red zoning.
  * Placed in the first word before and the first word after an obj.
  */
-#define	RED_INACTIVE	0x5A2CF071UL	/* when obj is inactive */
-#define	RED_ACTIVE	0x170FC2A5UL	/* when obj is active */
+#define	RED_INACTIVE	0x09F911029D74E35BULL	/* when obj is inactive */
+#define	RED_ACTIVE	0xD84156C5635688C0ULL	/* when obj is active */
 
 #define SLUB_RED_INACTIVE	0xbb
 #define SLUB_RED_ACTIVE		0xcc
diff -puN mm/slab.c~increase-slab-redzone-to-64bits mm/slab.c
--- a/mm/slab.c~increase-slab-redzone-to-64bits
+++ a/mm/slab.c
@@ -148,10 +148,11 @@
  * Usually, the kmalloc caches are cache_line_size() aligned, except when
  * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
  * Some archs want to perform DMA into kmalloc caches and need a guaranteed
- * alignment larger than BYTES_PER_WORD. ARCH_KMALLOC_MINALIGN allows that.
- * Note that this flag disables some debug features.
+ * alignment larger than the alignment of a 64-bit integer.
+ * ARCH_KMALLOC_MINALIGN allows that.
+ * Note that increasing this value may disable some debug features.
  */
-#define ARCH_KMALLOC_MINALIGN 0
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
 #ifndef ARCH_SLAB_MINALIGN
@@ -536,19 +537,22 @@ static int obj_size(struct kmem_cache *c
 	return cachep->obj_size;
 }
 
-static unsigned long *dbg_redzone1(struct kmem_cache *cachep, void *objp)
+static unsigned long long *dbg_redzone1(struct kmem_cache *cachep, void *objp)
 {
 	BUG_ON(!(cachep->flags & SLAB_RED_ZONE));
-	return (unsigned long*) (objp+obj_offset(cachep)-BYTES_PER_WORD);
+	return (unsigned long long*) (objp + obj_offset(cachep) -
+				      sizeof(unsigned long long));
 }
 
-static unsigned long *dbg_redzone2(struct kmem_cache *cachep, void *objp)
+static unsigned long long *dbg_redzone2(struct kmem_cache *cachep, void *objp)
 {
 	BUG_ON(!(cachep->flags & SLAB_RED_ZONE));
 	if (cachep->flags & SLAB_STORE_USER)
-		return (unsigned long *)(objp + cachep->buffer_size -
-					 2 * BYTES_PER_WORD);
-	return (unsigned long *)(objp + cachep->buffer_size - BYTES_PER_WORD);
+		return (unsigned long long *)(objp + cachep->buffer_size -
+					      sizeof(unsigned long long) -
+					      BYTES_PER_WORD);
+	return (unsigned long long *) (objp + cachep->buffer_size -
+				       sizeof(unsigned long long));
 }
 
 static void **dbg_userword(struct kmem_cache *cachep, void *objp)
@@ -561,8 +565,8 @@ static void **dbg_userword(struct kmem_c
 
 #define obj_offset(x)			0
 #define obj_size(cachep)		(cachep->buffer_size)
-#define dbg_redzone1(cachep, objp)	({BUG(); (unsigned long *)NULL;})
-#define dbg_redzone2(cachep, objp)	({BUG(); (unsigned long *)NULL;})
+#define dbg_redzone1(cachep, objp)	({BUG(); (unsigned long long *)NULL;})
+#define dbg_redzone2(cachep, objp)	({BUG(); (unsigned long long *)NULL;})
 #define dbg_userword(cachep, objp)	({BUG(); (void **)NULL;})
 
 #endif
@@ -1776,7 +1780,7 @@ static void print_objinfo(struct kmem_ca
 	char *realobj;
 
 	if (cachep->flags & SLAB_RED_ZONE) {
-		printk(KERN_ERR "Redzone: 0x%lx/0x%lx.\n",
+		printk(KERN_ERR "Redzone: 0x%llx/0x%llx.\n",
 			*dbg_redzone1(cachep, objp),
 			*dbg_redzone2(cachep, objp));
 	}
@@ -2239,7 +2243,7 @@ kmem_cache_create (const char *name, siz
 	 * is greater than BYTES_PER_WORD.
 	 */
 	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
-		ralign = BYTES_PER_WORD;
+		ralign = __alignof__(unsigned long long);
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2250,7 +2254,7 @@ kmem_cache_create (const char *name, siz
 		ralign = align;
 	}
 	/* disable debug if necessary */
-	if (ralign > BYTES_PER_WORD)
+	if (ralign > __alignof__(unsigned long long))
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
@@ -2271,8 +2275,8 @@ kmem_cache_create (const char *name, siz
 	 */
 	if (flags & SLAB_RED_ZONE) {
 		/* add space for red zone words */
-		cachep->obj_offset += BYTES_PER_WORD;
-		size += 2 * BYTES_PER_WORD;
+		cachep->obj_offset += sizeof(unsigned long long);
+		size += 2 * sizeof(unsigned long long);
 	}
 	if (flags & SLAB_STORE_USER) {
 		/* user store requires one word storage behind the end of
@@ -2833,7 +2837,7 @@ static void kfree_debugcheck(const void 
 
 static inline void verify_redzone_free(struct kmem_cache *cache, void *obj)
 {
-	unsigned long redzone1, redzone2;
+	unsigned long long redzone1, redzone2;
 
 	redzone1 = *dbg_redzone1(cache, obj);
 	redzone2 = *dbg_redzone2(cache, obj);
@@ -2849,7 +2853,7 @@ static inline void verify_redzone_free(s
 	else
 		slab_error(cache, "memory outside object was overwritten");
 
-	printk(KERN_ERR "%p: redzone 1:0x%lx, redzone 2:0x%lx.\n",
+	printk(KERN_ERR "%p: redzone 1:0x%llx, redzone 2:0x%llx.\n",
 			obj, redzone1, redzone2);
 }
 
@@ -3065,7 +3069,7 @@ static void *cache_alloc_debugcheck_afte
 			slab_error(cachep, "double free, or memory outside"
 						" object was overwritten");
 			printk(KERN_ERR
-				"%p: redzone 1:0x%lx, redzone 2:0x%lx\n",
+				"%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
 				objp, *dbg_redzone1(cachep, objp),
 				*dbg_redzone2(cachep, objp));
 		}
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-mtd.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-battery.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
introduce-freezer-flags-rev-2.patch
