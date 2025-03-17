Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B6C2153EA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188227; cv=none; b=GNBPMenoNIwmpqshSlYhUbXp49De+rmmTSKvAzB2BNtOrk08Lv3q7pi7AerV7W8xMESSRXClLeX2amTnKXLV1drXpJ0a5va9sytyi55DHoMKr5fdEcG2Ujv0DdOhJW+Vo2n2Le4MikzOyE7chN7U8le+BFlFOpb1mmcnHkwMfkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188227; c=relaxed/simple;
	bh=uV+fCoMTDK+UcY9lyz4BDbbsccRAVoK8hM8YafNS+vs=;
	h=Date:To:From:Subject:Message-Id; b=Jf5calzTuWT4JQ1MD7Qapwp7XafTRRwdF8ClNZ+aLHktjNROTYyxvqxsr4VEq2yzq+s9iV0dGUx2VLBLBwAjlHaeNCe16JULm+CDeZCwX0PcpAunUoxG3+T4ECIUWCehxs+RD9TrB3rlLxU6rXpyh4jMAOgQcglnNTM88KdqHsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zAmOSnFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zAmOSnFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D390CC4CEEC;
	Mon, 17 Mar 2025 05:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188226;
	bh=uV+fCoMTDK+UcY9lyz4BDbbsccRAVoK8hM8YafNS+vs=;
	h=Date:To:From:Subject:From;
	b=zAmOSnFJyIDMBA1KmbDfqEDXD3PN0tUj7R3DFtI86nJjYlVlKMA2me+h/WdzKCd71
	 q0S3W8y3NvEvAzsqY3ec9f7+SYNGB41aGRa3elaKehdQ3r8GlmtMRXSH+c0zYkE6xE
	 pZJ+aBRzUW+NdWCghRlXoGeuQAzwDCNGmy9BWMZ8=
Date: Sun, 16 Mar 2025 22:10:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-split-out-mmap-locking-operations-for-madvise.patch removed from -mm tree
Message-Id: <20250317051026.D390CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: split out mmap locking operations for madvise()
has been removed from the -mm tree.  Its filename was
     mm-madvise-split-out-mmap-locking-operations-for-madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: split out mmap locking operations for madvise()
Date: Wed, 5 Feb 2025 22:15:14 -0800

Patch series "mm/madvise: remove redundant mmap_lock operations from
process_madvise()".

process_madvise() calls do_madvise() for each address range.  Then, each
do_madvise() invocation holds and releases same mmap_lock.  Optimize the
redundant lock operations by splitting do_madvise() internal logic
including the mmap_lock operations, and calling the small logic directly
from process_madvise() in a sequence that removes the redundant locking. 
As a result of this change, process_madvise() becomes more efficient and
less racy in terms of its results and latency.

Note that the potential downside of this series is that other mmap_lock
holders may take more time due to the increased length of mmap_lock
critical section for process_madvise() calls.  But there is maximum limit
in the kernel space (IOV_MAX), and userspace can control the critical
section length by setting the request size.  Hence, the downside would be
limited and controllable.

Evaluation
==========

I measured the time to apply MADV_DONTNEED advice to 256 MiB memory using
multiple madvise() calls, 4 KiB per each call.  I also do the same with
process_madvise(), but with varying batch size (vlen) from 1 to 1024.  The
source code for the measurement is available at GitHub[1].  Because the
microbenchmark result is not that stable, I ran each configuration five
times and use the average.

The measurement results are as below.  'sz_batches' column shows the batch
size of process_madvise() calls.  '0' batch size is for madvise() calls
case.  'before' and 'after' columns are the measured time to apply
MADV_DONTNEED to the 256 MiB memory buffer in nanoseconds, on kernels that
built without and with the last patch of this series, respectively.  So
lower value means better efficiency.  'after/before' column is the ratio
of 'after' to 'before'.

    sz_batches  before       after        after/before
    0           146294215.2  121280536.2  0.829017989769427
    1           165851018.8  136305598.2  0.821855658085351
    2           129469321.2  103740383.6  0.801273866569094
    4           110369232.4  87835896.2   0.795836795182785
    8           102906232.4  77420920.2   0.752344327397609
    16          97551017.4   74959714.4   0.768415506038587
    32          94809848.2   71200848.4   0.750985786305689
    64          96087575.6   72593180     0.755489765942227
    128         96154163.8   68517055.4   0.712575022154163
    256         92901257.6   69054216.6   0.743307662177439
    512         93646170.8   67053296.2   0.716028168874151
    1024        92663219.2   70168196.8   0.75723892830177

Despite the unstable nature of the test program, the trend is as we
expect.  The measurement shows this patchset reduces the process_madvise()
latency, proportional to the batching size.  The latency gain was about
20% with the batch size 2, and it has increased to about 28% with the
batch size 512, since more number of mmap locking is reduced with larger
batch size.

Note that the standard devitation of the measurements for each sz_batches
configuration ranged from 1.9% to 7.2%.  That is, this result is not very
stable.  The average of the standard deviations for different batch sizes
were 4.62% and 4.70% for the 'before' and 'after' kernel measurements.

Also note that this patch has somehow decreased latencies of madvise() and
single batch size process_madvise().  Seems this code path is small enough
to significantly be affected by compiler optimizations including inlining
of split-out functions.  Please focus on only the improvement amount that
changed by the batch size.

[1] https://github.com/sjp38/eval_proc_madvise


This patch (of 4):

Split out the madvise behavior-dependent mmap_lock operations from
do_madvise(), for easier reuse of the logic in an upcoming change.

[lorenzo.stoakes@oracle.com: fix madvise_[un]lock() issue]
  Link: https://lkml.kernel.org/r/2f448f7b-1da7-4099-aa9e-0179d47fde40@lucifer.local
[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20250206061517.2958-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250206061517.2958-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   62 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 13 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise
+++ a/mm/madvise.c
@@ -1574,6 +1574,50 @@ int madvise_set_anon_name(struct mm_stru
 				 madvise_vma_anon_name);
 }
 #endif /* CONFIG_ANON_VMA_NAME */
+
+#ifdef CONFIG_MEMORY_FAILURE
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
+#endif
+
+static int madvise_lock(struct mm_struct *mm, int behavior)
+{
+	if (is_memory_failure(behavior))
+		return 0;
+
+	if (madvise_need_mmap_write(behavior)) {
+		if (mmap_write_lock_killable(mm))
+			return -EINTR;
+	} else {
+		mmap_read_lock(mm);
+	}
+	return 0;
+}
+
+static void madvise_unlock(struct mm_struct *mm, int behavior)
+{
+	if (is_memory_failure(behavior))
+		return;
+
+	if (madvise_need_mmap_write(behavior))
+		mmap_write_unlock(mm);
+	else
+		mmap_read_unlock(mm);
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1650,7 +1694,6 @@ int do_madvise(struct mm_struct *mm, uns
 {
 	unsigned long end;
 	int error;
-	int write;
 	size_t len;
 	struct blk_plug plug;
 
@@ -1672,19 +1715,15 @@ int do_madvise(struct mm_struct *mm, uns
 	if (end == start)
 		return 0;
 
+	error = madvise_lock(mm, behavior);
+	if (error)
+		return error;
+
 #ifdef CONFIG_MEMORY_FAILURE
 	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
 		return madvise_inject_error(behavior, start, start + len_in);
 #endif
 
-	write = madvise_need_mmap_write(behavior);
-	if (write) {
-		if (mmap_write_lock_killable(mm))
-			return -EINTR;
-	} else {
-		mmap_read_lock(mm);
-	}
-
 	start = untagged_addr_remote(mm, start);
 	end = start + len;
 
@@ -1701,10 +1740,7 @@ int do_madvise(struct mm_struct *mm, uns
 	}
 	blk_finish_plug(&plug);
 
-	if (write)
-		mmap_write_unlock(mm);
-	else
-		mmap_read_unlock(mm);
+	madvise_unlock(mm, behavior);
 
 	return error;
 }
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

