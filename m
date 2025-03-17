Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9E2153DA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188231; cv=none; b=Xqqun4943ASHlxGjOp8sKKGbffxfaS7LdzEQtE8MyGcLZB4cLOVoPy2d87PNE5Fm8eGzFGkLUe192Y0oiVkOf7AKMtMZvLpwk8ngrIr1+n9FpJ9wEIJ7UnwzYk8We4EJEpxFMS678QVLEcV8ZnQGwmmza9J+iv2nUR2nVx1MiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188231; c=relaxed/simple;
	bh=NOfBVoS9jOi+/DaNa4XMmk1ifPr2ACjUSxbab9cgyKM=;
	h=Date:To:From:Subject:Message-Id; b=A1l9QZlBeSDg0efNvqKL2BKphJM+SAO/nYnt/EDWcCgAL6SStXP/68X9aorcO1Kq1N9abVfblyKMxRBAMv2PU8Q5DDPM5RmUdBzri5hV04sZFICN/tygeD8nLQbWDiLnleXv8tcOKrAxoQVuefsIk+KlpAqDsQlnK3CzRzi5s3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=izUmkLou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="izUmkLou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99170C4CEEC;
	Mon, 17 Mar 2025 05:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188230;
	bh=NOfBVoS9jOi+/DaNa4XMmk1ifPr2ACjUSxbab9cgyKM=;
	h=Date:To:From:Subject:From;
	b=izUmkLougNyg7ah0p6fjqkgAaMA4tzgqomrzLC0seG7pA4AO/ks/LguwuBc69Xy6r
	 too7YwfANxXc6NOgyU+6ClINPSwoqYnPVYi30G3PaSSRubwq9GQc1b2jkDWEJcSn5x
	 AuLmBmi7GdEaBRfnQCR53/hhd/tD9YaCDHbM0gLE=
Date: Sun, 16 Mar 2025 22:10:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-split-out-madvise-behavior-execution.patch removed from -mm tree
Message-Id: <20250317051030.99170C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: split out madvise() behavior execution
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-madvise-behavior-execution.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: split out madvise() behavior execution
Date: Wed, 5 Feb 2025 22:15:16 -0800

Split out the madvise behavior applying logic from do_madvise() to make
it easier to reuse from the following change.

Link: https://lkml.kernel.org/r/20250206061517.2958-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   53 +++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-madvise-behavior-execution
+++ a/mm/madvise.c
@@ -1639,6 +1639,35 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+static int madvise_do_behavior(struct mm_struct *mm,
+		unsigned long start, size_t len_in, size_t len, int behavior)
+{
+	struct blk_plug plug;
+	unsigned long end;
+	int error;
+
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+		return madvise_inject_error(behavior, start, start + len_in);
+#endif
+	start = untagged_addr_remote(mm, start);
+	end = start + len;
+
+	blk_start_plug(&plug);
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		error = madvise_populate(mm, start, end, behavior);
+		break;
+	default:
+		error = madvise_walk_vmas(mm, start, end, behavior,
+					  madvise_vma_behavior);
+		break;
+	}
+	blk_finish_plug(&plug);
+	return error;
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1716,7 +1745,6 @@ int do_madvise(struct mm_struct *mm, uns
 	unsigned long end;
 	int error;
 	size_t len;
-	struct blk_plug plug;
 
 	if (!is_valid_madvise(start, len_in, behavior))
 		return -EINVAL;
@@ -1730,28 +1758,7 @@ int do_madvise(struct mm_struct *mm, uns
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
-
-#ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return madvise_inject_error(behavior, start, start + len_in);
-#endif
-
-	start = untagged_addr_remote(mm, start);
-	end = start + len;
-
-	blk_start_plug(&plug);
-	switch (behavior) {
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
-		error = madvise_populate(mm, start, end, behavior);
-		break;
-	default:
-		error = madvise_walk_vmas(mm, start, end, behavior,
-					  madvise_vma_behavior);
-		break;
-	}
-	blk_finish_plug(&plug);
-
+	error = madvise_do_behavior(mm, start, len_in, len, behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

