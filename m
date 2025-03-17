Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD6D10E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742185865; cv=none; b=hpCAZftD/9aR8SgRnnUWZw6koVejQ2vTND+4w4ZRyBNf1hmk3eMyDYUHTgnGEjPkOUpmOT2Cg8TspFYm7mb3UQdgHhYlAe3eq3ZpISEl+/OBCkn/2XHbHb7UkMwiMfAJ81934ribCw6gUMDWsB6vtMJKO6ieAGjy6KKt0zTs89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742185865; c=relaxed/simple;
	bh=BUERa4in7RbO6P48CGyxXsMbJXn1DJHnWO46ZLbewao=;
	h=Date:To:From:Subject:Message-Id; b=rJoUL3dsl8yb7XkG3jfAQVsobIfaDUHpg9o7ZszLsj2QCMl0dpifD8pvQ/N5hC4qTLxyDCaCH8Ub3UR2keUQ4ssIgq/d89+Z9eLkJ3AlBj1JZhUkZ/2vTY9Fqf8HUWJG3DcZsAeLYqTi+Wn9SHaZGW1ucyYnP0w6+IgPE4Uw2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1sQhHnEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sQhHnEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2F2C4CEEC;
	Mon, 17 Mar 2025 04:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742185864;
	bh=BUERa4in7RbO6P48CGyxXsMbJXn1DJHnWO46ZLbewao=;
	h=Date:To:From:Subject:From;
	b=1sQhHnEqxcecLluPE80zU58cQOYMI/zsF7aGiRtu2Ea/8i2Yg+1mJJAe9tdjVt7uv
	 ie3YSAe/wpPVXMIOav6wA/Wvk04XNzlXZ7A9fS1XPYtT92vGTFwWScinyvi6ah26Yu
	 gZRnOkLcSaV8Z+oOvjt7Ah+TgCFf706m+LCbzbEg=
Date: Sun, 16 Mar 2025 21:31:03 -0700
To: mm-commits@vger.kernel.org,yi1.lai@linux.intel.com,sj@kernel.org,shakeel.butt@linux.dev,naresh.kamboju@linaro.org,howlett@gmail.com,dave@stgolabs.net,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch removed from -mm tree
Message-Id: <20250317043104.6E2F2C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: fix madvise_[un]lock() issue
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch

This patch was dropped because it was folded into mm-madvise-split-out-mmap-locking-operations-for-madvise.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: fix madvise_[un]lock() issue
Date: Tue, 11 Feb 2025 10:44:26 +0000

We are asymmetric in our locking/unlocking in the case of memory failure
madvise() behaviour options, correct this and abstract the memory failure
check.

Link: https://lkml.kernel.org/r/2f448f7b-1da7-4099-aa9e-0179d47fde40@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/Z6rgiVp7221r4JZ5@ly-workstation
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise-fix
+++ a/mm/madvise.c
@@ -1575,14 +1575,29 @@ int madvise_set_anon_name(struct mm_stru
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
-static int madvise_lock(struct mm_struct *mm, int behavior)
-{
-
 #ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return 0;
+static bool is_memory_failure(int behavior)
+{
+	switch (behavior) {
+	case MADV_HWPOISON:
+	case MADV_SOFT_OFFLINE:
+		return true;
+	default:
+		return false;
+	}
+}
+#else
+static bool is_memory_failure(int behavior)
+{
+	return false;
+}
 #endif
 
+static int madvise_lock(struct mm_struct *mm, int behavior)
+{
+	if (is_memory_failure(behavior))
+	    return 0;
+
 	if (madvise_need_mmap_write(behavior)) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
@@ -1590,11 +1605,13 @@ static int madvise_lock(struct mm_struct
 		mmap_read_lock(mm);
 	}
 	return 0;
-
 }
 
 static void madvise_unlock(struct mm_struct *mm, int behavior)
 {
+	if (is_memory_failure(behavior))
+	    return;
+
 	if (madvise_need_mmap_write(behavior))
 		mmap_write_unlock(mm);
 	else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

