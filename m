From: akpm@linux-foundation.org
Subject: - slub-fix-sysfs-refcounting.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:46:00 -0800
Message-ID: <200802050245.m152jg4C031198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYBECpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: fix sysfs refcounting
has been removed from the -mm tree.  Its filename was
     slub-fix-sysfs-refcounting.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: fix sysfs refcounting
From: Christoph Lameter <clameter@sgi.com>

If CONFIG_SYSFS is set then free the kmem_cache structure when sysfs tells
us its okay.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-fix-sysfs-refcounting mm/slub.c
--- a/mm/slub.c~slub-fix-sysfs-refcounting
+++ a/mm/slub.c
@@ -218,7 +218,10 @@ static void sysfs_slab_remove(struct kme
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
-static inline void sysfs_slab_remove(struct kmem_cache *s) {}
+static inline void sysfs_slab_remove(struct kmem_cache *s)
+{
+	kfree(s);
+}
 #endif
 
 /********************************************************************
@@ -2488,7 +2491,6 @@ void kmem_cache_destroy(struct kmem_cach
 		if (kmem_cache_close(s))
 			WARN_ON(1);
 		sysfs_slab_remove(s);
-		kfree(s);
 	} else
 		up_write(&slub_lock);
 }
@@ -4114,6 +4116,13 @@ static ssize_t slab_attr_store(struct ko
 	return err;
 }
 
+static void kmem_cache_release(struct kobject *kobj)
+{
+	struct kmem_cache *s = to_slab(kobj);
+
+	kfree(s);
+}
+
 static struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
@@ -4121,6 +4130,7 @@ static struct sysfs_ops slab_sysfs_ops =
 
 static struct kobj_type slab_ktype = {
 	.sysfs_ops = &slab_sysfs_ops,
+	.release = kmem_cache_release
 };
 
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
@@ -4222,6 +4232,7 @@ static void sysfs_slab_remove(struct kme
 {
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
+	kobject_put(&s->kobj);
 }
 
 /*
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
