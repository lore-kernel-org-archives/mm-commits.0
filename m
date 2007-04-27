From: akpm@linux-foundation.org
Subject: - slub-core-fix-sysfs-directory-handling.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:22:37 -0700
Message-ID: <200704270822.l3R8MbYv023341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbXD0IWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Fix sysfs directory handling
has been removed from the -mm tree.  Its filename was
     slub-core-fix-sysfs-directory-handling.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: Fix sysfs directory handling
From: Christoph Lameter <clameter@sgi.com>

This fixes the problem that SLUB does not track the names of aliased
slabs by changing the way that SLUB manages the files in /sys/slab.

If the slab that is being operated on is not mergeable (usually the
case if we are debugging) then do not create any aliases. If an alias
exists that we conflict with then remove it before creating the
directory for the unmergeable slab. If there is a true slab cache there
and not an alias then we fail since there is a true duplication of
slab cache names. So debugging allows the detection of slab name
duplication as usual.

If the slab is mergeable then we create a directory with a unique name
created from the slab size, slab options and the pointer to the kmem_cache
structure (disambiguation). All names referring to the slabs will
then be created as symlinks to that unique name. These symlinks are
not going to be removed on kmem_cache_destroy() since we only carry
a counter for the number of aliases. If a new symlink is created
then it may just replace an existing one. This means that one can create
a gazillion slabs with the same name (if they all refer to mergeable
caches). It will only increase the alias count. So we have the potential
of not detecting duplicate slab names (there is actually no harm
done by doing that....). We will detect the duplications as
as soon as debugging is enabled because we will then no longer
generate symlinks and special unique names.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-core-fix-sysfs-directory-handling mm/slub.c
--- a/mm/slub.c~slub-core-fix-sysfs-directory-handling
+++ a/mm/slub.c
@@ -3021,16 +3021,68 @@ static struct kset_uevent_ops slab_ueven
 
 decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
 
+#define ID_STR_LENGTH 64
+
+/* Create a unique string id for a slab cache:
+ * format
+ * :[flags-]size:[memory address of kmemcache]
+ */
+static char *create_unique_id(struct kmem_cache *s)
+{
+	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
+	char *p = name;
+
+	BUG_ON(!name);
+
+	*p++ = ':';
+	/*
+	 * First flags affecting slabcache operations */
+	if (s->flags & SLAB_CACHE_DMA)
+		*p++ = 'd';
+	if (s->flags & SLAB_RECLAIM_ACCOUNT)
+		*p++ = 'a';
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		*p++ = 'r';\
+	/* Debug flags */
+	if (s->flags & SLAB_RED_ZONE)
+		*p++ = 'Z';
+	if (s->flags & SLAB_POISON)
+		*p++ = 'P';
+	if (s->flags & SLAB_STORE_USER)
+		*p++ = 'U';
+	if (p != name + 1)
+		*p++ = '-';
+	p += sprintf(p,"%07d:0x%p" ,s->size, s);
+	BUG_ON(p > name + ID_STR_LENGTH - 1);
+	return name;
+}
+
 static int sysfs_slab_add(struct kmem_cache *s)
 {
 	int err;
+	const char *name;
 
 	if (slab_state < SYSFS)
 		/* Defer until later */
 		return 0;
 
+	if (s->flags & SLUB_NEVER_MERGE) {
+		/*
+		 * Slabcache can never be merged so we can use the name proper.
+		 * This is typically the case for debug situations. In that
+		 * case we can catch duplicate names easily.
+		 */
+		sysfs_remove_link(&slab_subsys.kset.kobj, s->name);
+		name = s->name;
+	} else
+		/*
+		 * Create a unique name for the slab as a target
+		 * for the symlinks.
+		 */
+		name = create_unique_id(s);
+
 	kobj_set_kset_s(s, slab_subsys);
-	kobject_set_name(&s->kobj, s->name);
+	kobject_set_name(&s->kobj, name);
 	kobject_init(&s->kobj);
 	err = kobject_add(&s->kobj);
 	if (err)
@@ -3040,6 +3092,10 @@ static int sysfs_slab_add(struct kmem_ca
 	if (err)
 		return err;
 	kobject_uevent(&s->kobj, KOBJ_ADD);
+	if (!(s->flags & SLUB_NEVER_MERGE)) {
+		sysfs_slab_alias(s, s->name);
+		kfree(name);
+	}
 	return 0;
 }
 
@@ -3065,9 +3121,14 @@ static int sysfs_slab_alias(struct kmem_
 {
 	struct saved_alias *al;
 
-	if (slab_state == SYSFS)
+	if (slab_state == SYSFS) {
+		/*
+		 * If we have a leftover link then remove it.
+		 */
+		sysfs_remove_link(&slab_subsys.kset.kobj, name);
 		return sysfs_create_link(&slab_subsys.kset.kobj,
 						&s->kobj, name);
+	}
 
 	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
 	if (!al)
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
