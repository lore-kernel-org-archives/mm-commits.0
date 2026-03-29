Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B6613AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744952; cv=none; b=RDrjLSmOpXd/a5DviVW6734tkKWv37d/+ZveuAdwCmzdDhMxalpufEGHKLTwGDGVD++HxFAbiV0f8OxU+k7EmbW5aPox4B9h/4CSMrKu03JLqKQ3boa5uZhw6GdEBCG/LwFsG6wzNR7Y/02R0yP7+mIpwczMsFg4TjNQbKuRtFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744952; c=relaxed/simple;
	bh=8iiK1wAGX8fB4TEdd6/JtKpDm//el7ANtyTz4tc1TVk=;
	h=Date:To:From:Subject:Message-Id; b=H0q+h9P6AB3PgtFJkyV/G6MvoJKcDMxnsAtpauQRSmEMKUXvCh/KxE7qPzOByefT+o9f8cwMuHjyQlpluOmwXpWlDDzs5+HPeEIGKAAx2d6/P6pYvVcZDozJ55hUyAYKCX+WIXTAQhPGH1ZHtmzS8/xJNdJgD+KFDeLJ8+48ttQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1PqkYvm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1PqkYvm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9714C4CEF7;
	Sun, 29 Mar 2026 00:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744952;
	bh=8iiK1wAGX8fB4TEdd6/JtKpDm//el7ANtyTz4tc1TVk=;
	h=Date:To:From:Subject:From;
	b=1PqkYvm2ScThgZ9+spMrX38tHKAZxU6WUbj3WQwmJ9ry2HuoFyF9KdqIch0kvtDac
	 poYeenY615Kxenf6PYvqtdY2asNuY3hbrAQXrqo2A3Yrz8Iuq5pWfmT7edCYwiKQ4L
	 /gSIdPQe1qpbNX3CfstpJABuY4J6MRx50OeFYj+w=
Date: Sat, 28 Mar 2026 17:42:32 -0700
To: mm-commits@vger.kernel.org,srosek@google.com,skardach@google.com,rppt@kernel.org,mikrawczyk@google.com,gregkh@linuxfoundation.org,hmazur@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-make-the-populate-and-alloc-atomic.patch removed from -mm tree
Message-Id: <20260329004232.A9714C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: make the populate and alloc atomic
has been removed from the -mm tree.  Its filename was
     mm-execmem-make-the-populate-and-alloc-atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hubert Mazur <hmazur@google.com>
Subject: mm/execmem: make the populate and alloc atomic
Date: Fri, 20 Mar 2026 07:57:23 +0000

When a block of memory is requested from the execmem manager it tries to
find a suitable fragment by traversing the free_areas.  In case there is
no such block, a new memory area is added to the free_areas and then
allocated to the caller by traversing the free_area tree again.

The above operations of allocation and tree traversal are not atomic hence
another request may consume this newly allocated memory block which
results in the allocation failure for the original request.  Such
occurrence can be spotted on devices running the 6.18 kernel during the
parallel modules loading.

To mitigate such resource races execute the cache population and
allocation operations under one mutex lock.

Link: https://lkml.kernel.org/r/20260320075723.779985-1-hmazur@google.com
Signed-off-by: Hubert Mazur <hmazur@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stanislaw Kardach <skardach@google.com>
Cc: Michal Krawczyk <mikrawczyk@google.com>
Cc: Slawomir Rosek <srosek@google.com>
Cc: Hubert Mazur <hmazur@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |   55 +++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/mm/execmem.c~mm-execmem-make-the-populate-and-alloc-atomic
+++ a/mm/execmem.c
@@ -203,13 +203,6 @@ static int execmem_cache_add_locked(void
 	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
 }
 
-static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
-{
-	guard(mutex)(&execmem_cache.mutex);
-
-	return execmem_cache_add_locked(ptr, size, gfp_mask);
-}
-
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
 			 size_t size)
 {
@@ -225,18 +218,16 @@ static bool within_range(struct execmem_
 	return false;
 }
 
-static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
 	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
 	MA_STATE(mas_free, free_areas, 0, ULONG_MAX);
 	MA_STATE(mas_busy, busy_areas, 0, ULONG_MAX);
-	struct mutex *mutex = &execmem_cache.mutex;
 	unsigned long addr, last, area_size = 0;
 	void *area, *ptr = NULL;
 	int err;
 
-	mutex_lock(mutex);
 	mas_for_each(&mas_free, area, ULONG_MAX) {
 		area_size = mas_range_len(&mas_free);
 
@@ -245,7 +236,7 @@ static void *__execmem_cache_alloc(struc
 	}
 
 	if (area_size < size)
-		goto out_unlock;
+		return NULL;
 
 	addr = mas_free.index;
 	last = mas_free.last;
@@ -254,7 +245,7 @@ static void *__execmem_cache_alloc(struc
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		goto out_unlock;
+		return NULL;
 
 	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
 	if (area_size > size) {
@@ -268,19 +259,25 @@ static void *__execmem_cache_alloc(struc
 		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 		if (err) {
 			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			goto out_unlock;
+			return NULL;
 		}
 	}
 	ptr = (void *)addr;
 
-out_unlock:
-	mutex_unlock(mutex);
 	return ptr;
 }
 
-static int execmem_cache_populate(struct execmem_range *range, size_t size)
+static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+{
+	guard(mutex)(&execmem_cache.mutex);
+
+	return execmem_cache_alloc_locked(range, size);
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
+	struct mutex *mutex = &execmem_cache.mutex;
 	struct vm_struct *vm;
 	size_t alloc_size;
 	int err = -ENOMEM;
@@ -294,7 +291,7 @@ static int execmem_cache_populate(struct
 	}
 
 	if (!p)
-		return err;
+		return NULL;
 
 	vm = find_vm_area(p);
 	if (!vm)
@@ -307,33 +304,39 @@ static int execmem_cache_populate(struct
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
+	/*
+	 * New memory blocks must be allocated and added to the cache
+	 * as an atomic operation, otherwise they may be consumed
+	 * by a parallel call to the execmem_cache_alloc function.
+	 */
+	mutex_lock(mutex);
+	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
 	if (err)
 		goto err_reset_direct_map;
 
-	return 0;
+	p = execmem_cache_alloc_locked(range, size);
+
+	mutex_unlock(mutex);
+
+	return p;
 
 err_reset_direct_map:
+	mutex_unlock(mutex);
 	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
-	return err;
+	return NULL;
 }
 
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
-	int err;
 
 	p = __execmem_cache_alloc(range, size);
 	if (p)
 		return p;
 
-	err = execmem_cache_populate(range, size);
-	if (err)
-		return NULL;
-
-	return __execmem_cache_alloc(range, size);
+	return execmem_cache_populate_alloc(range, size);
 }
 
 static inline bool is_pending_free(void *ptr)
_

Patches currently in -mm which might be from hmazur@google.com are


