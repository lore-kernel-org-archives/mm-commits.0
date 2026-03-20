Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F42FB965
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774034198; cv=none; b=cUp9IyNLXECvHinjjqmPRQLWyOdnuK0B1wh+036rWwAAeWQTk/OsUy/h0oldkSYw8VOjW3lDvpHwt++67vQMYh1AQS5AyZ+w7BmNH9U5Voptkt/NnRXGuZgX5fptR9ABSGUG9LLtBWSfoLuMC9UVnkupQVloBlVu5nzs+jlANKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774034198; c=relaxed/simple;
	bh=TIAr4fp0Q9Ax3cogS5mgxJdYicrdvfLXarn0AhYUSus=;
	h=Date:To:From:Subject:Message-Id; b=bFMaDEJyTUpSOm9Jv7PhkE+YHRGzeMdVN1W0Wg2JkVqOir/vMHyGdSWvesHuPo2NWzffrsxw2br0kgVydYyhtlPdRjqyCWIN6wpdWrpjMnvHOnELfLHaWvYjxScB/8FGdqoD6Ue/G/hzT2DKbRpLzYozRXpGlXm6N7vFBdhHLMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKXHIQL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKXHIQL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728A3C4CEF7;
	Fri, 20 Mar 2026 19:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774034197;
	bh=TIAr4fp0Q9Ax3cogS5mgxJdYicrdvfLXarn0AhYUSus=;
	h=Date:To:From:Subject:From;
	b=nKXHIQL2KCmQ/dP5vbmTkimi1lIVcFhV3uqBmAlvdnXVebtyG5gqbH2uVWlrxV1sU
	 fVVztmvOzmkWxUvnSF3ut8ooaK+Kjk0aPyZ8auACCwgic0MJIs3BXFfDwpc4fuDCJ6
	 iJbNV3N8lT16zKGIPwIjnuB8p+Py2inRUMaCO8eQ=
Date: Fri, 20 Mar 2026 12:16:36 -0700
To: mm-commits@vger.kernel.org,srosek@google.com,skardach@google.com,rppt@kernel.org,mikrawczyk@google.com,gregkh@linuxfoundation.org,hmazur@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-make-the-populate-and-alloc-atomic.patch added to mm-new branch
Message-Id: <20260320191637.728A3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: make the populate and alloc atomic
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-make-the-populate-and-alloc-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-make-the-populate-and-alloc-atomic.patch

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
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

mm-execmem-make-the-populate-and-alloc-atomic.patch

