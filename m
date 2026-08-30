Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE525B0A4
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788055035; cv=none; b=oMrPtcdAQ0J7zQZhfzLy0pIwW0xQsgasPErspg6URhiKYDTKry31lwgZZ1zZI9Wy6ZWhjJ1BRpEEpfJ6zXo8872VAwKbrNhJDfYohZn6rCnTeUyP5GLcejB83OCy5MhAjVJpoAkPtBX0Z3jAKRVOT+ERgt5ZcvbYFXAWVIuBKnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788055035; c=relaxed/simple;
	bh=ErQtWX/BCB2R7obl2kdH9HHRlim3roQSFA7aRfmB+Ko=;
	h=Date:To:From:Subject:Message-Id; b=KlNGJBfoDAb26KOPfugolOY5o+L3igO0p+1NMrCSqheyLjhP24BH7K9arfnQX9ZLwK7VQYyHyq186t5ZKGBveNvy+7sT2m6B0dryFR5D6mWVMPz/FH3LzyAVClvgTY5vjiv6FLKzoHyKS7lJdPhBE3YPEa+HJF3yTWNYM9Pv7GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snyzRrdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snyzRrdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ABC1F000E9;
	Sun, 30 Aug 2026 01:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788055033;
	bh=2aA9F4RCLTaGe69H719nVW1no2buYcq2XGrwXFuZYmI=;
	h=Date:To:From:Subject;
	b=snyzRrdFrMvDukuzPWBVnWr0dcpyg5Uln/h321clgftMV3ZCxWb4YAyclWel3oTPf
	 rsc4qZmcoixMGYbPwAD+wH797n2SJhQhVgjfT2FQlZCeRySW5Rt/dwv2cHJFQny1Qr
	 fCRZjkbwbdPVjd32nopKZfbfRjCP1A7mcsqDsj7g=
Date: Sat, 29 Aug 2026 18:57:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,dsahern@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binder-make-shrinker-rely-solely-on-per-vma-lock.patch added to mm-new branch
Message-Id: <20260830015713.78ABC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: binder: make shrinker rely solely on per-VMA lock
has been added to the -mm mm-new branch.  Its filename is
     binder-make-shrinker-rely-solely-on-per-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binder-make-shrinker-rely-solely-on-per-vma-lock.patch

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: binder: make shrinker rely solely on per-VMA lock
Date: Thu, 13 Aug 2026 12:34:30 -0700

tl;dr: lock_vma_under_rcu() is already a trylock.  No need to do both it
and mmap_read_trylock().

Long Version:

== Background ==

Historically, binder used an mmap_read_trylock() in its shrinker code. 
This ensures that reclaim is not blocked on an mmap_lock.  Commit
95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added support
for the per-VMA lock, but left mmap_read_trylock() as a fallback.

This was presumably because the per-VMA locking can fail for several
reasons and most (all?) lock_vma_under_rcu() callers have a fallback to
mmap_read_trylock().

== Problem ==

The fallback is not worth the complexity here.  lock_vma_under_rcu() is
essentially already a non-blocking trylock.  The main reason it fails is
also the reason mmap_read_trylock() fails: something is holding
mmap_write_lock().

The only remedy for a collision with mmap_write_lock() is to wait, which
this code can not do.  So the "fallback" after lock_vma_under_rcu()
failure is not really a fallback: it is really likely to just be retrying
in vain.  That retry in an of itself isn't horrible.  But it adds
complexity.

== Solution ==

Now that per-VMA locks are universally available, lock_vma_under_rcu()
will not persistently fail.  Rely on it alone and simplify the code.  The
removal of the fallback does not affect NOMMU case because binder driver
depends on CONFIG_MMU.

While at it we also make the handling of the cases where the original
binder VMA is gone consistent.  There are two cases to consider when
Binder VMA is gone:

1. there is no VMA at that location anymore.
2. there is now another unrelated VMA at that location.

Before this change we handle case 1 by having the shrinker proceed to free
the page, and just skip the zap_vma_range() call.  And we handle case 2 by
having the shrinker return LRU_SKIP.  While either behavior is acceptable,
we need to handle them in a consistent way.  Handle both cases by freeing
the page without touching the VMA (skipping the zap_vma_range()).

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics.  Claude caught this in a review and suggested the
approach in this path.  It seemed sane to me.  So, Suggesed-by: Claude, I
guess.

Link: https://lore.kernel.org/20260813193433.3318288-3-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |   46 ++++++++++++++-----------------
 1 file changed, 21 insertions(+), 25 deletions(-)

--- a/drivers/android/binder_alloc.c~binder-make-shrinker-rely-solely-on-per-vma-lock
+++ a/drivers/android/binder_alloc.c
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked = 0;
 	size_t index;
 
 	if (!mmget_not_zero(mm))
@@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(s
 	index = mdata->page_index;
 	page_addr = alloc->vm_start + index * PAGE_SIZE;
 
-	/* attempt per-vma lock first */
+	/*
+	 * Attempt per-vma lock. This is essentially a
+	 * "trylock". It can fail even if the VMA exists
+	 * for 'page_addr'.
+	 */
 	vma = lock_vma_under_rcu(mm, page_addr);
 	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked = 1;
-		vma = vma_lookup(mm, page_addr);
+		/*
+		 * If the vma exists, we can't continue because we cannot
+		 * remove the page from the vma. However, if the vma was
+		 * unmapped, it's okay to continue.
+		 */
+		if (binder_alloc_is_mapped(alloc))
+			goto err_vma_lock_failed;
 	}
 
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
 
-	/*
-	 * Since a binder_alloc can only be mapped once, we ensure
-	 * the vma corresponds to this mapping by checking whether
-	 * the binder_alloc is still mapped.
-	 */
-	if (vma && !binder_alloc_is_mapped(alloc))
-		goto err_invalid_vma;
-
 	trace_binder_unmap_kernel_start(alloc, index);
 
 	page_to_free = alloc->pages[index];
@@ -1182,7 +1179,12 @@ enum lru_status binder_alloc_free_page(s
 	list_lru_isolate(lru, item);
 	spin_unlock(&lru->lock);
 
-	if (vma) {
+	/*
+	 * Since a binder_alloc can only be mapped once, we ensure
+	 * the vma corresponds to this mapping by checking whether
+	 * the binder_alloc is still mapped.
+	 */
+	if (vma && binder_alloc_is_mapped(alloc)) {
 		trace_binder_unmap_user_start(alloc, index);
 
 		zap_vma_range(vma, page_addr, PAGE_SIZE);
@@ -1191,23 +1193,17 @@ enum lru_status binder_alloc_free_page(s
 	}
 
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
 
 	return LRU_REMOVED_RETRY;
 
-err_invalid_vma:
-	mutex_unlock(&alloc->mutex);
 err_get_alloc_mutex_failed:
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
-err_mmap_read_lock_failed:
+err_vma_lock_failed:
 	mmput_async(mm);
 err_mmget:
 	return LRU_SKIP;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-make-per-vma-locks-available-universally.patch
binder-make-shrinker-rely-solely-on-per-vma-lock.patch
mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch
binder-remove-mmap_lock-fallback.patch
tcp-remove-mmap_lock-fallback-path.patch

