Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F7B2153E2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188230; cv=none; b=JH7L/L7ZwkVm0X5eUEz+6gSaXK7Y9le5TZxODOGc7AH+MdU/DZOEvKp89lPAwae+6hmv9T83WyxmCB34QNLsyORv+HgwJJZ34WDBr+4NGFrHTYCwNgJ9Y4todOtpHOEQvSRUcE7C1lSAcfboszhul4mlsGA9kblNxbFIjauudwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188230; c=relaxed/simple;
	bh=P5tMulyVWG7aCKnGviH5fl0Aoar+VY+R4isSfFX2r4Q=;
	h=Date:To:From:Subject:Message-Id; b=tCzu4YcQxZVAwzY6nhzuvGGyGKcRY31xkOSmmL7mC1qMCTgvsv+yeKpBhLMoo0qvbwUNMYNxwVZC91vJIZFqf9aArg9GTTFSFs3AHsQ1ZcRYRvt11gUDkzdFF3g47vPEpWeHGTveG3/LObr0kpq89gBdONO2gG3h58/Q4hq9grk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkxyRqp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkxyRqp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768CAC4CEEC;
	Mon, 17 Mar 2025 05:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188229;
	bh=P5tMulyVWG7aCKnGviH5fl0Aoar+VY+R4isSfFX2r4Q=;
	h=Date:To:From:Subject:From;
	b=hkxyRqp+8HYbZ+TJHfqyWp3ew0CMp+09bnX6EVtOslZXN5IH7vymwzEPdQp4pmD9+
	 LdVVyjRa+qCH2ucwQbtqAC+atcVT4cIPPIgP6FikbI47bAcDewBmuiD0UNXmeg7wYr
	 pluISBh04OaNFnPTlv2L6lm42JvecloaexNN7FJ8=
Date: Sun, 16 Mar 2025 22:10:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-split-out-madvise-input-validity-check.patch removed from -mm tree
Message-Id: <20250317051029.768CAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: split out madvise input validity check
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-madvise-input-validity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: split out madvise input validity check
Date: Wed, 5 Feb 2025 22:15:15 -0800

Split out the madvise parameters validation logic from do_madvise(), for
easy reuse of the logic from a future change.

Link: https://lkml.kernel.org/r/20250206061517.2958-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-madvise-input-validity-check
+++ a/mm/madvise.c
@@ -1618,6 +1618,27 @@ static void madvise_unlock(struct mm_str
 		mmap_read_unlock(mm);
 }
 
+static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
+{
+	size_t len;
+
+	if (!madvise_behavior_valid(behavior))
+		return false;
+
+	if (!PAGE_ALIGNED(start))
+		return false;
+	len = PAGE_ALIGN(len_in);
+
+	/* Check to see whether len was rounded up from small -ve to zero */
+	if (len_in && !len)
+		return false;
+
+	if (start + len < start)
+		return false;
+
+	return true;
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1697,20 +1718,11 @@ int do_madvise(struct mm_struct *mm, uns
 	size_t len;
 	struct blk_plug plug;
 
-	if (!madvise_behavior_valid(behavior))
+	if (!is_valid_madvise(start, len_in, behavior))
 		return -EINVAL;
 
-	if (!PAGE_ALIGNED(start))
-		return -EINVAL;
 	len = PAGE_ALIGN(len_in);
-
-	/* Check to see whether len was rounded up from small -ve to zero */
-	if (len_in && !len)
-		return -EINVAL;
-
 	end = start + len;
-	if (end < start)
-		return -EINVAL;
 
 	if (end == start)
 		return 0;
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

