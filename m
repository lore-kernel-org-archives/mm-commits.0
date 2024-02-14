Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A295F869
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707926930; cv=none; b=cb3VZFzKcwuZJx9OKyW6nWDAaABnoszrHNg/bh1XHErDaA/ZqB6XimJ9OwnhMs2SWUAl30Pwy6Fg38OyfsuUyHvyTiBoihj1/MOvX4YFOvb6JYm8pfH7G202qYy4HWb3JtXc/zX5TqB8+d4RAK68vca5hOa4pnDNCb0rVQiFkvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707926930; c=relaxed/simple;
	bh=hh86M8m4p3kTScInASgsW80zWEpFMSmWm+GexFpnYow=;
	h=Date:To:From:Subject:Message-Id; b=lJkwHCJmNzUKttYGIwqrvXBM/HxCaHBv8uwKUWwuJ0T1+u216fjdM+ZkNaK9NMvuD21LCunCv2h3kGLUtR9mVCjJJZZ7spuUod1VQhy7NkdSHEs9PJH2TFhfGEcFSygSBA8B1xddFqHcQdGdPGO8OwajMeOOHOigkr35mJ9gLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDNK8PRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDNK8PRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF1C433B2;
	Wed, 14 Feb 2024 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707926930;
	bh=hh86M8m4p3kTScInASgsW80zWEpFMSmWm+GexFpnYow=;
	h=Date:To:From:Subject:From;
	b=LDNK8PRT4BupqTdP4+yt57T7xvmSmatNS3A1BTENQMcWw38WGyFwjj1To2zWrtkes
	 YSsEmabTJI3q0VAxaWfr/a4/OVY3S4KNDrckVK2nsYqa8dlSreC7eP1Dm+KHvraOwN
	 6kiChD8AsCLp6BWWK5x08ttfgLgYiYa3gsYHE9j4=
Date: Wed, 14 Feb 2024 08:08:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,timmurray@google.com,surenb@google.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch added to mm-unstable branch
Message-Id: <20240214160849.D8DF1C433B2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: use per-vma locks in userfaultfd operations
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: use per-vma locks in userfaultfd operations
Date: Tue, 13 Feb 2024 13:57:41 -0800

All userfaultfd operations, except write-protect, opportunistically use
per-vma locks to lock vmas.  On failure, attempt again inside mmap_lock
critical section.

Write-protect operation requires mmap_lock as it iterates over multiple
vmas.

Link: https://lkml.kernel.org/r/20240213215741.3816570-4-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   13 -
 include/linux/userfaultfd_k.h |    5 
 mm/userfaultfd.c              |  382 ++++++++++++++++++++++++--------
 3 files changed, 297 insertions(+), 103 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-per-vma-locks-in-userfaultfd-operations
+++ a/fs/userfaultfd.c
@@ -2005,17 +2005,8 @@ static int userfaultfd_move(struct userf
 		return -EINVAL;
 
 	if (mmget_not_zero(mm)) {
-		mmap_read_lock(mm);
-
-		/* Re-check after taking map_changing_lock */
-		down_read(&ctx->map_changing_lock);
-		if (likely(!atomic_read(&ctx->mmap_changing)))
-			ret = move_pages(ctx, mm, uffdio_move.dst, uffdio_move.src,
-					 uffdio_move.len, uffdio_move.mode);
-		else
-			ret = -EAGAIN;
-		up_read(&ctx->map_changing_lock);
-		mmap_read_unlock(mm);
+		ret = move_pages(ctx, uffdio_move.dst, uffdio_move.src,
+				 uffdio_move.len, uffdio_move.mode);
 		mmput(mm);
 	} else {
 		return -ESRCH;
--- a/include/linux/userfaultfd_k.h~userfaultfd-use-per-vma-locks-in-userfaultfd-operations
+++ a/include/linux/userfaultfd_k.h
@@ -138,9 +138,8 @@ extern long uffd_wp_range(struct vm_area
 /* move_pages */
 void double_pt_lock(spinlock_t *ptl1, spinlock_t *ptl2);
 void double_pt_unlock(spinlock_t *ptl1, spinlock_t *ptl2);
-ssize_t move_pages(struct userfaultfd_ctx *ctx, struct mm_struct *mm,
-		   unsigned long dst_start, unsigned long src_start,
-		   unsigned long len, __u64 flags);
+ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+		   unsigned long src_start, unsigned long len, __u64 flags);
 int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pmd_t dst_pmdval,
 			struct vm_area_struct *dst_vma,
 			struct vm_area_struct *src_vma,
--- a/mm/userfaultfd.c~userfaultfd-use-per-vma-locks-in-userfaultfd-operations
+++ a/mm/userfaultfd.c
@@ -20,19 +20,11 @@
 #include "internal.h"
 
 static __always_inline
-struct vm_area_struct *find_dst_vma(struct mm_struct *dst_mm,
-				    unsigned long dst_start,
-				    unsigned long len)
+bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
-	/*
-	 * Make sure that the dst range is both valid and fully within a
-	 * single existing vma.
-	 */
-	struct vm_area_struct *dst_vma;
-
-	dst_vma = find_vma(dst_mm, dst_start);
-	if (!range_in_vma(dst_vma, dst_start, dst_start + len))
-		return NULL;
+	/* Make sure that the dst range is fully within dst_vma. */
+	if (dst_end > dst_vma->vm_end)
+		return false;
 
 	/*
 	 * Check the vma is registered in uffd, this is required to
@@ -40,11 +32,122 @@ struct vm_area_struct *find_dst_vma(stru
 	 * time.
 	 */
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		return NULL;
+		return false;
+
+	return true;
+}
+
+static __always_inline
+struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
+						 unsigned long addr)
+{
+	struct vm_area_struct *vma;
+
+	mmap_assert_locked(mm);
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		vma = ERR_PTR(-ENOENT);
+	else if (!(vma->vm_flags & VM_SHARED) &&
+		 unlikely(anon_vma_prepare(vma)))
+		vma = ERR_PTR(-ENOMEM);
+
+	return vma;
+}
+
+#ifdef CONFIG_PER_VMA_LOCK
+/*
+ * lock_vma() - Lookup and lock vma corresponding to @address.
+ * @mm: mm to search vma in.
+ * @address: address that the vma should contain.
+ *
+ * Should be called without holding mmap_lock. vma should be unlocked after use
+ * with unlock_vma().
+ *
+ * Return: A locked vma containing @address, -ENOENT if no vma is found, or
+ * -ENOMEM if anon_vma couldn't be allocated.
+ */
+static struct vm_area_struct *lock_vma(struct mm_struct *mm,
+				       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+	vma = lock_vma_under_rcu(mm, address);
+	if (vma) {
+		/*
+		 * lock_vma_under_rcu() only checks anon_vma for private
+		 * anonymous mappings. But we need to ensure it is assigned in
+		 * private file-backed vmas as well.
+		 */
+		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
+			vma_end_read(vma);
+		else
+			return vma;
+	}
+
+	mmap_read_lock(mm);
+	vma = find_vma_and_prepare_anon(mm, address);
+	if (!IS_ERR(vma)) {
+		/*
+		 * We cannot use vma_start_read() as it may fail due to
+		 * false locked (see comment in vma_start_read()). We
+		 * can avoid that by directly locking vm_lock under
+		 * mmap_lock, which guarantees that nobody can lock the
+		 * vma for write (vma_start_write()) under us.
+		 */
+		down_read(&vma->vm_lock->lock);
+	}
+
+	mmap_read_unlock(mm);
+	return vma;
+}
+
+static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
+					      unsigned long dst_start,
+					      unsigned long len)
+{
+	struct vm_area_struct *dst_vma;
+
+	dst_vma = lock_vma(dst_mm, dst_start);
+	if (IS_ERR(dst_vma) || validate_dst_vma(dst_vma, dst_start + len))
+		return dst_vma;
+
+	vma_end_read(dst_vma);
+	return ERR_PTR(-ENOENT);
+}
+
+static void uffd_mfill_unlock(struct vm_area_struct *vma)
+{
+	vma_end_read(vma);
+}
+
+#else
+
+static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
+					      unsigned long dst_start,
+					      unsigned long len)
+{
+	struct vm_area_struct *dst_vma;
+
+	mmap_read_lock(dst_mm);
+	dst_vma = find_vma_and_prepare_anon(dst_mm, dst_start);
+	if (IS_ERR(dst_vma))
+		goto out_unlock;
+
+	if (validate_dst_vma(dst_vma, dst_start + len))
+		return dst_vma;
 
+	dst_vma = ERR_PTR(-ENOENT);
+out_unlock:
+	mmap_read_unlock(dst_mm);
 	return dst_vma;
 }
 
+static void uffd_mfill_unlock(struct vm_area_struct *vma)
+{
+	mmap_read_unlock(vma->vm_mm);
+}
+#endif
+
 /* Check if dst_addr is outside of file's size. Must be called with ptl held. */
 static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr)
@@ -350,7 +453,8 @@ static pmd_t *mm_alloc_pmd(struct mm_str
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
- * called with mmap_lock held, it will release mmap_lock before returning.
+ * called with either vma-lock or mmap_lock held, it will release the lock
+ * before returning.
  */
 static __always_inline ssize_t mfill_atomic_hugetlb(
 					      struct userfaultfd_ctx *ctx,
@@ -361,7 +465,6 @@ static __always_inline ssize_t mfill_ato
 					      uffd_flags_t flags)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
 	pte_t *dst_pte;
 	unsigned long src_addr, dst_addr;
@@ -380,7 +483,7 @@ static __always_inline ssize_t mfill_ato
 	 */
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
 		up_read(&ctx->map_changing_lock);
-		mmap_read_unlock(dst_mm);
+		uffd_mfill_unlock(dst_vma);
 		return -EINVAL;
 	}
 
@@ -403,24 +506,28 @@ retry:
 	 * retry, dst_vma will be set to NULL and we must lookup again.
 	 */
 	if (!dst_vma) {
+		dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
+		if (IS_ERR(dst_vma)) {
+			err = PTR_ERR(dst_vma);
+			goto out;
+		}
+
 		err = -ENOENT;
-		dst_vma = find_dst_vma(dst_mm, dst_start, len);
-		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
-			goto out_unlock;
+		if (!is_vm_hugetlb_page(dst_vma))
+			goto out_unlock_vma;
 
 		err = -EINVAL;
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
-			goto out_unlock;
+			goto out_unlock_vma;
 
-		vm_shared = dst_vma->vm_flags & VM_SHARED;
-	}
-
-	/*
-	 * If not shared, ensure the dst_vma has a anon_vma.
-	 */
-	err = -ENOMEM;
-	if (!vm_shared) {
-		if (unlikely(anon_vma_prepare(dst_vma)))
+		/*
+		 * If memory mappings are changing because of non-cooperative
+		 * operation (e.g. mremap) running in parallel, bail out and
+		 * request the user to retry later
+		 */
+		down_read(&ctx->map_changing_lock);
+		err = -EAGAIN;
+		if (atomic_read(&ctx->mmap_changing))
 			goto out_unlock;
 	}
 
@@ -465,7 +572,7 @@ retry:
 
 		if (unlikely(err == -ENOENT)) {
 			up_read(&ctx->map_changing_lock);
-			mmap_read_unlock(dst_mm);
+			uffd_mfill_unlock(dst_vma);
 			BUG_ON(!folio);
 
 			err = copy_folio_from_user(folio,
@@ -474,17 +581,6 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
-			mmap_read_lock(dst_mm);
-			down_read(&ctx->map_changing_lock);
-			/*
-			 * If memory mappings are changing because of non-cooperative
-			 * operation (e.g. mremap) running in parallel, bail out and
-			 * request the user to retry later
-			 */
-			if (atomic_read(&ctx->mmap_changing)) {
-				err = -EAGAIN;
-				break;
-			}
 
 			dst_vma = NULL;
 			goto retry;
@@ -505,7 +601,8 @@ retry:
 
 out_unlock:
 	up_read(&ctx->map_changing_lock);
-	mmap_read_unlock(dst_mm);
+out_unlock_vma:
+	uffd_mfill_unlock(dst_vma);
 out:
 	if (folio)
 		folio_put(folio);
@@ -597,7 +694,15 @@ static __always_inline ssize_t mfill_ato
 	copied = 0;
 	folio = NULL;
 retry:
-	mmap_read_lock(dst_mm);
+	/*
+	 * Make sure the vma is not shared, that the dst range is
+	 * both valid and fully within a single existing vma.
+	 */
+	dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
+	if (IS_ERR(dst_vma)) {
+		err = PTR_ERR(dst_vma);
+		goto out;
+	}
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -609,15 +714,6 @@ retry:
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
-	/*
-	 * Make sure the vma is not shared, that the dst range is
-	 * both valid and fully within a single existing vma.
-	 */
-	err = -ENOENT;
-	dst_vma = find_dst_vma(dst_mm, dst_start, len);
-	if (!dst_vma)
-		goto out_unlock;
-
 	err = -EINVAL;
 	/*
 	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
@@ -647,16 +743,6 @@ retry:
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-	/*
-	 * Ensure the dst_vma has a anon_vma or this page
-	 * would get a NULL anon_vma when moved in the
-	 * dst_vma.
-	 */
-	err = -ENOMEM;
-	if (!(dst_vma->vm_flags & VM_SHARED) &&
-	    unlikely(anon_vma_prepare(dst_vma)))
-		goto out_unlock;
-
 	while (src_addr < src_start + len) {
 		pmd_t dst_pmdval;
 
@@ -699,7 +785,7 @@ retry:
 			void *kaddr;
 
 			up_read(&ctx->map_changing_lock);
-			mmap_read_unlock(dst_mm);
+			uffd_mfill_unlock(dst_vma);
 			BUG_ON(!folio);
 
 			kaddr = kmap_local_folio(folio, 0);
@@ -730,7 +816,7 @@ retry:
 
 out_unlock:
 	up_read(&ctx->map_changing_lock);
-	mmap_read_unlock(dst_mm);
+	uffd_mfill_unlock(dst_vma);
 out:
 	if (folio)
 		folio_put(folio);
@@ -1267,27 +1353,136 @@ static int validate_move_areas(struct us
 	if (!vma_is_anonymous(src_vma) || !vma_is_anonymous(dst_vma))
 		return -EINVAL;
 
-	/*
-	 * Ensure the dst_vma has a anon_vma or this page
-	 * would get a NULL anon_vma when moved in the
-	 * dst_vma.
-	 */
-	if (unlikely(anon_vma_prepare(dst_vma)))
-		return -ENOMEM;
+	return 0;
+}
 
+static __always_inline
+int find_vmas_mm_locked(struct mm_struct *mm,
+			unsigned long dst_start,
+			unsigned long src_start,
+			struct vm_area_struct **dst_vmap,
+			struct vm_area_struct **src_vmap)
+{
+	struct vm_area_struct *vma;
+
+	mmap_assert_locked(mm);
+	vma = find_vma_and_prepare_anon(mm, dst_start);
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+
+	*dst_vmap = vma;
+	/* Skip finding src_vma if src_start is in dst_vma */
+	if (src_start >= vma->vm_start && src_start < vma->vm_end)
+		goto out_success;
+
+	vma = vma_lookup(mm, src_start);
+	if (!vma)
+		return -ENOENT;
+out_success:
+	*src_vmap = vma;
 	return 0;
 }
 
+#ifdef CONFIG_PER_VMA_LOCK
+static int uffd_move_lock(struct mm_struct *mm,
+			  unsigned long dst_start,
+			  unsigned long src_start,
+			  struct vm_area_struct **dst_vmap,
+			  struct vm_area_struct **src_vmap)
+{
+	struct vm_area_struct *vma;
+	int err;
+
+	vma = lock_vma(mm, dst_start);
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+
+	*dst_vmap = vma;
+	/*
+	 * Skip finding src_vma if src_start is in dst_vma. This also ensures
+	 * that we don't lock the same vma twice.
+	 */
+	if (src_start >= vma->vm_start && src_start < vma->vm_end) {
+		*src_vmap = vma;
+		return 0;
+	}
+
+	/*
+	 * Using lock_vma() to get src_vma can lead to following deadlock:
+	 *
+	 * Thread1				Thread2
+	 * -------				-------
+	 * vma_start_read(dst_vma)
+	 *					mmap_write_lock(mm)
+	 *					vma_start_write(src_vma)
+	 * vma_start_read(src_vma)
+	 * mmap_read_lock(mm)
+	 *					vma_start_write(dst_vma)
+	 */
+	*src_vmap = lock_vma_under_rcu(mm, src_start);
+	if (likely(*src_vmap))
+		return 0;
+
+	/* Undo any locking and retry in mmap_lock critical section */
+	vma_end_read(*dst_vmap);
+
+	mmap_read_lock(mm);
+	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
+	if (!err) {
+		/*
+		 * See comment in lock_vma() as to why not using
+		 * vma_start_read() here.
+		 */
+		down_read(&(*dst_vmap)->vm_lock->lock);
+		if (*dst_vmap != *src_vmap)
+			down_read(&(*src_vmap)->vm_lock->lock);
+	}
+	mmap_read_unlock(mm);
+	return err;
+}
+
+static void uffd_move_unlock(struct vm_area_struct *dst_vma,
+			     struct vm_area_struct *src_vma)
+{
+	vma_end_read(src_vma);
+	if (src_vma != dst_vma)
+		vma_end_read(dst_vma);
+}
+
+#else
+
+static int uffd_move_lock(struct mm_struct *mm,
+			  unsigned long dst_start,
+			  unsigned long src_start,
+			  struct vm_area_struct **dst_vmap,
+			  struct vm_area_struct **src_vmap)
+{
+	int err;
+
+	mmap_read_lock(mm);
+	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
+	if (err)
+		mmap_read_unlock(mm);
+	return err;
+}
+
+static void uffd_move_unlock(struct vm_area_struct *dst_vma,
+			     struct vm_area_struct *src_vma)
+{
+	mmap_assert_locked(src_vma->vm_mm);
+	mmap_read_unlock(dst_vma->vm_mm);
+}
+#endif
+
 /**
  * move_pages - move arbitrary anonymous pages of an existing vma
  * @ctx: pointer to the userfaultfd context
- * @mm: the address space to move pages
  * @dst_start: start of the destination virtual memory range
  * @src_start: start of the source virtual memory range
  * @len: length of the virtual memory range
  * @mode: flags from uffdio_move.mode
  *
- * Must be called with mmap_lock held for read.
+ * It will either use the mmap_lock in read mode or per-vma locks
  *
  * move_pages() remaps arbitrary anonymous pages atomically in zero
  * copy. It only works on non shared anonymous pages because those can
@@ -1355,10 +1550,10 @@ static int validate_move_areas(struct us
  * could be obtained. This is the only additional complexity added to
  * the rmap code to provide this anonymous page remapping functionality.
  */
-ssize_t move_pages(struct userfaultfd_ctx *ctx, struct mm_struct *mm,
-		   unsigned long dst_start, unsigned long src_start,
-		   unsigned long len, __u64 mode)
+ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+		   unsigned long src_start, unsigned long len, __u64 mode)
 {
+	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
 	unsigned long src_addr, dst_addr;
 	pmd_t *src_pmd, *dst_pmd;
@@ -1376,28 +1571,34 @@ ssize_t move_pages(struct userfaultfd_ct
 	    WARN_ON_ONCE(dst_start + len <= dst_start))
 		goto out;
 
+	err = uffd_move_lock(mm, dst_start, src_start, &dst_vma, &src_vma);
+	if (err)
+		goto out;
+
+	/* Re-check after taking map_changing_lock */
+	err = -EAGAIN;
+	down_read(&ctx->map_changing_lock);
+	if (likely(atomic_read(&ctx->mmap_changing)))
+		goto out_unlock;
 	/*
 	 * Make sure the vma is not shared, that the src and dst remap
 	 * ranges are both valid and fully within a single existing
 	 * vma.
 	 */
-	src_vma = find_vma(mm, src_start);
-	if (!src_vma || (src_vma->vm_flags & VM_SHARED))
-		goto out;
-	if (src_start < src_vma->vm_start ||
-	    src_start + len > src_vma->vm_end)
-		goto out;
+	err = -EINVAL;
+	if (src_vma->vm_flags & VM_SHARED)
+		goto out_unlock;
+	if (src_start + len > src_vma->vm_end)
+		goto out_unlock;
 
-	dst_vma = find_vma(mm, dst_start);
-	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
-		goto out;
-	if (dst_start < dst_vma->vm_start ||
-	    dst_start + len > dst_vma->vm_end)
-		goto out;
+	if (dst_vma->vm_flags & VM_SHARED)
+		goto out_unlock;
+	if (dst_start + len > dst_vma->vm_end)
+		goto out_unlock;
 
 	err = validate_move_areas(ctx, src_vma, dst_vma);
 	if (err)
-		goto out;
+		goto out_unlock;
 
 	for (src_addr = src_start, dst_addr = dst_start;
 	     src_addr < src_start + len;) {
@@ -1514,6 +1715,9 @@ ssize_t move_pages(struct userfaultfd_ct
 		moved += step_size;
 	}
 
+out_unlock:
+	up_read(&ctx->map_changing_lock);
+	uffd_move_unlock(dst_vma, src_vma);
 out:
 	VM_WARN_ON(moved < 0);
 	VM_WARN_ON(err > 0);
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch
userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch
userfaultfd-protect-mmap_changing-with-rw_sem-in-userfaulfd_ctx.patch
userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

