From: akpm@linux-foundation.org
Subject: + slub-move-resiliency-check-into-sysfs-section.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:55 -0700
Message-ID: <200705082148.l48Lmtfa002627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968375AbXEHVs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: move resiliency check into SYSFS section
has been added to the -mm tree.  Its filename is
     slub-move-resiliency-check-into-sysfs-section.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: move resiliency check into SYSFS section
From: Christoph Lameter <clameter@sgi.com>

Move the resiliency check into the SYSFS section after validate_slab that is
used by the resiliency check.  This will avoid a forward declaration.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  112 +++++++++++++++++++++++++---------------------------
 1 files changed, 55 insertions(+), 57 deletions(-)

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
