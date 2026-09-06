Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FB03128B8
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660362; cv=none; b=V32z7vxuv46cko4kwnAE6+R7xpLIyaz5/Fm5GmRkZKScllxudZF2AQ+BtLE9gRLxiE7F3vcAVczZOdWXk4o4cIfPiBpMFuryOVqbVFyZ+MskfIxdHc6LzcjsjhS5cGrAI4TkQXvlHo65ejL4RrwXJUoh6+FXv3vB6usjcKyudzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660362; c=relaxed/simple;
	bh=hgKEqNKkmgbf6udbg21a3mOsGufRclNemArjRJ/GJoE=;
	h=Date:To:From:Subject:Message-Id; b=bwr250gRxDWjfrtWlhXnds6smdxCvKWVCF6hA9Bal0xdj24WLYlckmmL55SaJYDSud+dtj0VncYQjdzzIuK9EzCsVd3cvlScaM6+/WqOucrstWr2gE/Urue7STiuQRRXYL19WuXdBTxKJQ7L7Zy/upy80ZstC63/EX/29mcT0gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XOXnE9Va; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XOXnE9Va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB891F00A3A;
	Sun,  6 Sep 2026 02:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660360;
	bh=QWRDRCuat5JkNJZP7iUyRtJ7P7g/qO8/C3vDqdp0DeE=;
	h=Date:To:From:Subject;
	b=XOXnE9VaIcqE1XpzEWfMzrKtI9ZeQQ14aWQjBCOpKGpZS2dj+0bRgUTYr8Lo8k9zM
	 mlDrjaeg/NALXVhoyLJi4UpVvIROpFkaUh/JiOtje3Fj2pNo/NlwyPZy90vRZmhvqc
	 XS6vu3bgBGYJypTgC09uuYgzJ4Wigu2dIVVXf7eA=
Date: Sat, 05 Sep 2026 19:05:59 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch added to mm-new branch
Message-Id: <20260906020600.5DB891F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: use cleanup infrastructure in ROX cache functions
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: use cleanup infrastructure in ROX cache functions
Date: Thu, 03 Sep 2026 18:50:02 +0300

After splitting out execmem_alloc_rox() from
execmem_cache_populate_alloc(), the error paths of both functions became
less complex and can be easily switched to use the cleanup infrastructure.

Use __free(vfree) to free allocated memory on the error paths and
guard(mutex) for synchronization in ROX cache functions.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-5-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

--- a/mm/execmem.c~mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions
+++ a/mm/execmem.c
@@ -138,11 +138,10 @@ int execmem_restore_rox(void *ptr, size_
 static void execmem_cache_clean(struct work_struct *work)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
-	struct mutex *mutex = &execmem_cache.mutex;
 	MA_STATE(mas, free_areas, 0, ULONG_MAX);
 	void *area;
 
-	mutex_lock(mutex);
+	guard(mutex)(&execmem_cache.mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
 		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
@@ -163,7 +162,6 @@ static void execmem_cache_clean(struct w
 			vfree(area);
 		}
 	}
-	mutex_unlock(mutex);
 }
 
 static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
@@ -269,7 +267,7 @@ static void *__execmem_cache_alloc(struc
 static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
 				 unsigned long vm_flags)
 {
-	void *p = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
+	void *p __free(vfree) = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
 	int err;
 
 	if (!p)
@@ -280,22 +278,17 @@ static void *execmem_vmalloc_rox(struct
 	set_vm_flush_reset_perms(p);
 	err = set_memory_rox((unsigned long)p, size >> PAGE_SHIFT);
 	if (err)
-		goto err_free_mem;
-
-	return p;
+		return NULL;
 
-err_free_mem:
-	vfree(p);
-	return NULL;
+	return no_free_ptr(p);
 }
 
 static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_REQUIRE_HUGE_VMAP;
 	size_t alloc_size = round_up(size, PMD_SIZE);
-	struct mutex *mutex = &execmem_cache.mutex;
+	void *p __free(vfree) = NULL;
 	int err;
-	void *p;
 
 	p = execmem_vmalloc_rox(range, alloc_size, vm_flags);
 	if (!p)
@@ -306,20 +299,15 @@ static void *execmem_cache_populate_allo
 	 * as an atomic operation, otherwise they may be consumed
 	 * by a parallel call to the execmem_cache_alloc function.
 	 */
-	mutex_lock(mutex);
+	guard(mutex)(&execmem_cache.mutex);
 	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
-	if (!err)
-		p = execmem_cache_alloc_locked(range, size);
-	mutex_unlock(mutex);
-
 	if (err)
-		goto err_free_mem;
+		return NULL;
 
-	return p;
+	/* the chunk belongs to the cache now */
+	retain_and_null_ptr(p);
 
-err_free_mem:
-	vfree(p);
-	return NULL;
+	return execmem_cache_alloc_locked(range, size);
 }
 
 static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

