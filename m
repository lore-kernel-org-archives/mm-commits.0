Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E5D391838;
	Mon, 18 May 2026 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779134011; cv=none; b=YCd9jVLKwdPnG5LbTlF0OBaOb2j0Q/e5ANjjSYh0sZtrVSGVjxv0INZNxo3HZfa25aYVoHLvxfo3EC7/Nj3tjMjo+9ZrNBEx9bJkS5iBt9bAqs6ZsKme48XdG127HbkNEi+de1DNYXJjO/NrcP9p7K+qId6cWZeQWhEeYl0S4iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779134011; c=relaxed/simple;
	bh=V7ejyMtTb9M3iI61y6hmviI3Vy5/6/lTHolzIy5v7Ow=;
	h=Date:To:From:Subject:Message-Id; b=qBQhoKr+KwNP3HKVgeirjRWQXweFsb8wXDxn5435Mh0MwbHdq2Bn8w1mXTfuv73Uc0SvipJnCp7eSdq6SC980D2R7GXnu61PDr7rwBjrXAzUnsmBc+SG7OcFW8dNqrEw6JV9awKWLCODT0i0PY3MqLcE+jN7tBmJc2DzjfY7/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zwss5PHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zwss5PHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D9CC2BCB7;
	Mon, 18 May 2026 19:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779134009;
	bh=V7ejyMtTb9M3iI61y6hmviI3Vy5/6/lTHolzIy5v7Ow=;
	h=Date:To:From:Subject:From;
	b=Zwss5PHdkUYGwneS6Uqh/Zr31OxU5ITof/6bpy7+UlzvCmKKL47fWryz7foczRlI3
	 nGn1fa5IfzqI5Z2fGVCNrPZRN/IuL9hjVNYPn6BIc7/K+t/pgxBdnhdSZM/ymhL8TI
	 /qyxP7bVaZmUMmYW2WhEVfTXTxyXU+229F413DHQ=
Date: Mon, 18 May 2026 12:53:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-avoid-false-positive-lockdep-assertion.patch removed from -mm tree
Message-Id: <20260518195329.D5D9CC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: avoid false positive lockdep assertion
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-false-positive-lockdep-assertion.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/hugetlb: avoid false positive lockdep assertion
Date: Wed, 13 May 2026 09:56:58 +0100

Commit 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split,
not before") changed the locking model around hugetlbfs PMD unsharing on
VMA split, but did not update the function which asserts the locks,
hugetlb_vma_assert_locked().

This function asserts that either the hugetlb VMA lock is held (if a
shared mapping) or that the reservation map lock is held (if private).

If you get an unfortunate race between something which results in one of
these locks being released and a hugetlb VMA split and you have
CONFIG_LOCKDEP enabled, you can therefore see a false positive assertion
arise when there is in fact no issue.

Since this change introduced a new take_locks parameter to
hugetlb_unshare_pmds(), which, when set to false, indicates that locking
is sufficient, simply pass this to the unsharing logic and predicate the
lock assertions on this.

This is safe, as we already asserted the file rmap lock and the VMA write
lock prior to this (implying exclusive mmap write lock), so we cannot be
raced by either rmap or page fault page table walkers which the asserted
locks are intended to protect against (we don't mind GUP-fast).

Separate out huge_pmd_unshare() into __huge_pmd_unshare() to add a
check_locks parameter, and update hugetlb_unshare_pmds() to pass this
parameter to it.

This leaves all other callers of huge_pmd_unshare() still correctly
asserting the locks.

The below reproducer will trigger the assert in a kernel with
CONFIG_LOCKDEP enabled by racing process teardown (which will release the
hugetlb lock) against a hugetlb split.

void execute_one(void)
{
	void *ptr;
	pid_t pid;

	/*
	 * Create a hugetlb mapping spanning a PUD entry.
	 *
	 * We force the hugetlb page allocation with populate and
	 * noreserve.
	 *
	 * |---------------------|
	 * |                     |
	 * |---------------------|
	 * 0                 PUD boundary
	 */
	ptr = mmap(0, PUD_SIZE, PROT_READ | PROT_WRITE,
		   MAP_FIXED | MAP_SHARED | MAP_ANON |
		   MAP_NORESERVE | MAP_HUGETLB | MAP_POPULATE,
		   -1, 0);
	if (ptr == MAP_FAILED) {
		perror("mmap");
		exit(EXIT_FAILURE);
	}

	/*
	 * Fork but with a bogus stack pointer so we try to execute code in
	 * a non-VM_EXEC VMA, causing segfault + teardown via exit_mmap().
	 *
	 * The clone will cause PMD page table sharing between the
	 * processes first via:
	 * copy_process() -> ... -> huge_pte_alloc() -> huge_pmd_share()
	 *
	 * Then tear down and release the hugetlb 'VMA' lock via:
	 * exit_mmap() -> ... -> vma_close() -> hugetlb_vma_lock_free()
	 */
	pid = syscall(__NR_clone, 0, 2 * PMD_SIZE, 0, 0, 0);
	if (pid < 0) {
		perror("clone");
		exit(EXIT_FAILURE);
	} if (pid == 0) {
		/* Pop stack... */
		return;
	}

	/*
	 * We are the parent process.
	 *
	 * Race the child process's teardown with a PMD unshare.
	 *
	 * We do this by triggering:
	 *
	 * __split_vma() -> hugetlb_split() -> hugetlb_unshare_pmds()
	 *
	 * Which, importantly, doesn't hold the hugetlb VMA lock (nor can
	 * it), meaning we assert in hugetlb_vma_assert_locked().
	 *
	 *            .
	 * |----------.----------|
	 * |          .          |
	 * |----------.----------|
	 * 0          .     PUD boundary
	 */
	mmap(0, PUD_SIZE / 2, PROT_READ | PROT_WRITE,
	     MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
}

int main(void)
{
	int i;

	/* Kick off fork children. */
	for (i = 0; i < NUM_FORKS; i++) {
		pid_t pid = fork();

		if (pid < 0) {
			perror("fork");
			exit(EXIT_FAILURE);
		}

		/* Fork children do their work and exit. */
		if (!pid) {
			int j;

			for (j = 0; j < NUM_ITERS; j++)
				execute_one();
			return EXIT_SUCCESS;
		}
	}

	/* If we succeeded, wait on children. */
	for (i = 0; i < NUM_FORKS; i++)
		wait(NULL);

	return EXIT_SUCCESS;
}

Link: https://lore.kernel.org/20260513085658.45264-1-ljs@kernel.org
Fixes: 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not before")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-false-positive-lockdep-assertion
+++ a/mm/hugetlb.c
@@ -6892,6 +6892,31 @@ out:
 	return pte;
 }
 
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks)
+{
+	unsigned long sz = huge_page_size(hstate_vma(vma));
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd = pgd_offset(mm, addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
+
+	if (sz != PMD_SIZE)
+		return 0;
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
+		return 0;
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	if (check_locks)
+		hugetlb_vma_assert_locked(vma);
+	pud_clear(pud);
+
+	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+
+	mm_dec_nr_pmds(mm);
+	return 1;
+}
+
 /**
  * huge_pmd_unshare - Unmap a pmd table if it is shared by multiple users
  * @tlb: the current mmu_gather.
@@ -6911,24 +6936,7 @@ out:
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
-	unsigned long sz = huge_page_size(hstate_vma(vma));
-	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd = pgd_offset(mm, addr);
-	p4d_t *p4d = p4d_offset(pgd, addr);
-	pud_t *pud = pud_offset(p4d, addr);
-
-	if (sz != PMD_SIZE)
-		return 0;
-	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
-		return 0;
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	hugetlb_vma_assert_locked(vma);
-	pud_clear(pud);
-
-	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
-
-	mm_dec_nr_pmds(mm);
-	return 1;
+	return __huge_pmd_unshare(tlb, vma, addr, ptep, /*check_locks=*/true);
 }
 
 /*
@@ -7270,7 +7278,7 @@ static void hugetlb_unshare_pmds(struct
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(&tlb, vma, address, ptep);
+		__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
 		spin_unlock(ptl);
 	}
 	huge_pmd_unshare_flush(&tlb, vma);
_

Patches currently in -mm which might be from ljs@kernel.org are

revert-mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch

