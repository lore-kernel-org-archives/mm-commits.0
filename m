Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD52153DA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188232; cv=none; b=i7Waj7YYOdCJEAe+EfwGWaNc5X16GwOqzAyP0C2CxEmCM3l+rSlQWrOR1+KMcjTtNALAf2b7CLRfODklyZCzoV1wPIwjv3kk8CPmGYjbrLG4T0nlEDHYXZVsXvz5B/MzZgxwgCeOsDVeQh6uYGJYanNZpoNrNQKk+jnXolgM+18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188232; c=relaxed/simple;
	bh=kN416+C4U2tsfubUk6QK0mmmIuzpQ/QEu+Mp7IU4I84=;
	h=Date:To:From:Subject:Message-Id; b=sHeKHAnUeedQMgXmXXssbyHGQ4h7wW/IibVHn32yzleQoZCAZLM4QD7q00MlCRMc7St72zqdEy11bVj9Jg/FJ3ZuBNVlDQ8qdl5nZAjYXmR/sSMQ+rhTcMxAVbaz1Akqw+e+OsoGaYo7w4DQz7GXlXSMIinmGcN5CewKVhoTCfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kYPo9Sv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYPo9Sv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71E7C4CEEC;
	Mon, 17 Mar 2025 05:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188231;
	bh=kN416+C4U2tsfubUk6QK0mmmIuzpQ/QEu+Mp7IU4I84=;
	h=Date:To:From:Subject:From;
	b=kYPo9Sv/1iyBmUz2srCk1zehyKNa91cl9FhxnZn/k2DknfhE7DMbny6dKdk7n+AOr
	 daw0uLtxTACPeyf/gQMQA0OHwsovUs9OvZT2hyVY6zh6egpu2t3AvXoE8ClNcfCTjc
	 Yotx9OqQLDPm1484haHA8kTk/oHoJu431xA9YqTQ=
Date: Sun, 16 Mar 2025 22:10:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch removed from -mm tree
Message-Id: <20250317051031.B71E7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: remove redundant mmap_lock operations from process_madvise()
has been removed from the -mm tree.  Its filename was
     mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: remove redundant mmap_lock operations from process_madvise()
Date: Wed, 5 Feb 2025 22:15:17 -0800

Optimize redundant mmap lock operations from process_madvise() by directly
doing the mmap locking first, and then the remaining works for all ranges
in the loop.

[akpm@linux-foundation.org: update comment, per Lorenzo]
Link: https://lkml.kernel.org/r/20250206061517.2958-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise
+++ a/mm/madvise.c
@@ -1778,16 +1778,33 @@ static ssize_t vector_madvise(struct mm_
 
 	total_len = iov_iter_count(iter);
 
+	ret = madvise_lock(mm, behavior);
+	if (ret)
+		return ret;
+
 	while (iov_iter_count(iter)) {
-		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
-				 iter_iov_len(iter), behavior);
+		unsigned long start = (unsigned long)iter_iov_addr(iter);
+		size_t len_in = iter_iov_len(iter);
+		size_t len;
+
+		if (!is_valid_madvise(start, len_in, behavior)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		len = PAGE_ALIGN(len_in);
+		if (start + len == start)
+			ret = 0;
+		else
+			ret = madvise_do_behavior(mm, start, len_in, len,
+					behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
 		 * the operation in aggregate, and would be surprising to the
 		 * user.
 		 *
-		 * As we have already dropped locks, it is safe to just loop and
+		 * We drop and reacquire locks so it is safe to just loop and
 		 * try again. We check for fatal signals in case we need exit
 		 * early anyway.
 		 */
@@ -1796,12 +1813,17 @@ static ssize_t vector_madvise(struct mm_
 				ret = -EINTR;
 				break;
 			}
+
+			/* Drop and reacquire lock to unwind race. */
+			madvise_unlock(mm, behavior);
+			madvise_lock(mm, behavior);
 			continue;
 		}
 		if (ret < 0)
 			break;
 		iov_iter_advance(iter, iter_iov_len(iter));
 	}
+	madvise_unlock(mm, behavior);
 
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
 
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

