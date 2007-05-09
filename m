From: akpm@linux-foundation.org
Subject: - slub-move-resiliency-check-into-sysfs-section.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:03 -0700
Message-ID: <200705092148.l49Lm3dr002539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756734AbXEIVsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: move resiliency check into SYSFS section
has been removed from the -mm tree.  Its filename was
     slub-move-resiliency-check-into-sysfs-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: move resiliency check into SYSFS section
From: Christoph Lameter <clameter@sgi.com>

Move the resiliency check into the SYSFS section after validate_slab that is
used by the resiliency check.  This will avoid a forward declaration.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  112 +++++++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 57 deletions(-)

diff -puN mm/slub.c~slub-move-resiliency-check-into-sysfs-section mm/slub.c
--- a/mm/slub.c~slub-move-resiliency-check-into-sysfs-section
+++ a/mm/slub.c
@@ -2512,63 +2512,6 @@ static int __init cpucache_init(void)
 __initcall(cpucache_init);
 #endif
 
-#ifdef SLUB_RESILIENCY_TEST
-static unsigned long validate_slab_cache(struct kmem_cache *s);
-
-static void resiliency_test(void)
-{
-	u8 *p;
-
-	printk(KERN_ERR "SLUB resiliency testing\n");
-	printk(KERN_ERR "-----------------------\n");
-	printk(KERN_ERR "A. Corruption after allocation\n");
-
-	p = kzalloc(16, GFP_KERNEL);
-	p[16] = 0x12;
-	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
-			" 0x12->0x%p\n\n", p + 16);
-
-	validate_slab_cache(kmalloc_caches + 4);
-
-	/* Hmmm... The next two are dangerous */
-	p = kzalloc(32, GFP_KERNEL);
-	p[32 + sizeof(void *)] = 0x34;
-	printk(KERN_ERR "\n2. kmalloc-32: Clobber next pointer/next slab"
-		 	" 0x34 -> -0x%p\n", p);
-	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
-
-	validate_slab_cache(kmalloc_caches + 5);
-	p = kzalloc(64, GFP_KERNEL);
-	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
-	*p = 0x56;
-	printk(KERN_ERR "\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
-									p);
-	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
-	validate_slab_cache(kmalloc_caches + 6);
-
-	printk(KERN_ERR "\nB. Corruption after free\n");
-	p = kzalloc(128, GFP_KERNEL);
-	kfree(p);
-	*p = 0x78;
-	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches + 7);
-
-	p = kzalloc(256, GFP_KERNEL);
-	kfree(p);
-	p[50] = 0x9a;
-	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches + 8);
-
-	p = kzalloc(512, GFP_KERNEL);
-	kfree(p);
-	p[512] = 0xab;
-	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches + 9);
-}
-#else
-static void resiliency_test(void) {};
-#endif
-
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
@@ -2685,6 +2628,61 @@ static unsigned long validate_slab_cache
 	return count;
 }
 
+#ifdef SLUB_RESILIENCY_TEST
+static void resiliency_test(void)
+{
+	u8 *p;
+
+	printk(KERN_ERR "SLUB resiliency testing\n");
+	printk(KERN_ERR "-----------------------\n");
+	printk(KERN_ERR "A. Corruption after allocation\n");
+
+	p = kzalloc(16, GFP_KERNEL);
+	p[16] = 0x12;
+	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
+			" 0x12->0x%p\n\n", p + 16);
+
+	validate_slab_cache(kmalloc_caches + 4);
+
+	/* Hmmm... The next two are dangerous */
+	p = kzalloc(32, GFP_KERNEL);
+	p[32 + sizeof(void *)] = 0x34;
+	printk(KERN_ERR "\n2. kmalloc-32: Clobber next pointer/next slab"
+		 	" 0x34 -> -0x%p\n", p);
+	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
+
+	validate_slab_cache(kmalloc_caches + 5);
+	p = kzalloc(64, GFP_KERNEL);
+	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
+	*p = 0x56;
+	printk(KERN_ERR "\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
+									p);
+	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
+	validate_slab_cache(kmalloc_caches + 6);
+
+	printk(KERN_ERR "\nB. Corruption after free\n");
+	p = kzalloc(128, GFP_KERNEL);
+	kfree(p);
+	*p = 0x78;
+	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
+	validate_slab_cache(kmalloc_caches + 7);
+
+	p = kzalloc(256, GFP_KERNEL);
+	kfree(p);
+	p[50] = 0x9a;
+	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
+	validate_slab_cache(kmalloc_caches + 8);
+
+	p = kzalloc(512, GFP_KERNEL);
+	kfree(p);
+	p[512] = 0xab;
+	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
+	validate_slab_cache(kmalloc_caches + 9);
+}
+#else
+static void resiliency_test(void) {};
+#endif
+
 /*
  * Generate lists of code addresses where slabcache objects are allocated
  * and freed.
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
