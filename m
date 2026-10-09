Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B2D407563
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525434; cv=none; b=sWSXbYZXs1GZKiZ0erZl/VvHGVV6ALAHkBDOjuKfZshYbK93FxSVvVj4Kf7rhgffF9+itZ5e4tOAbs3leTS1ktYToxUkmAQmCWk2mkXVJCQbDzvPg+3vjAMOuaX96U2k4YkTteB/IRQkg3/80/59tvrPWhUYHXoKzbxwCUzbHvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525434; c=relaxed/simple;
	bh=hUj25dtW2XdBwpd7Ml0tzlNbRS7nJNd7pDKs53ca1Uw=;
	h=Date:To:From:Subject:Message-Id; b=eTk/RNWzZSB/rXHxZ2U94lYxOIDkxK87xeJ5WZFUO6fBSzXnJ5pUjohvlCjxDRB3syAN039H/iOBXmNFipe1honpJ4HFx6hZS6G5T9DJWXVcxpqcKgW77Sx7Evy062x7YQ6tkpfdOjDC8k9ZSafukjs/jAz/oXjC2bB2NfZ5Zjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/MPdWkg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/MPdWkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E39D1F000FF;
	Fri,  9 Oct 2026 05:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525433;
	bh=RyuZg0rUJuiutqnCyNag+1kNQCcwfI53gJ1Lz06xPag=;
	h=Date:To:From:Subject;
	b=p/MPdWkglGAtZzxXF8/XNNSmbMV5w7KsQAyL4a2XkprqvgmjpmF8xU8aOBAF4zo+1
	 IkBmTxOhnJIFDDNXKTxxjqsgzy47L/mub+ChcVPDIEUwqcgf0W8k2i8fiWK8zLZ3Py
	 BkwUGie06S8ZMpkXRImUIIkRMJkajHTCWI2hP7g8=
Date: Thu, 08 Oct 2026 22:57:12 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch removed from -mm tree
Message-Id: <20261009055713.1E39D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: use cleanup infrastructure in ROX cache functions
has been removed from the -mm tree.  Its filename was
     mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
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

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
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

