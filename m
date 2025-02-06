Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD01226533
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827636; cv=none; b=RISGVDcVhRnPHaGtznCUxGKFt9G8OvISw0VGfHC8qv7imGX7IqxGL+oP6FAk24XkENDkIs6oW893KLm+XFHb8IH9jMVEa24u2HlRGuOBkqF7QyuXN9LY88hRxXP2eAkpVlhcIkc+Jr22KsvIJOa8ThS3XYga5WeB+9mETlm5+x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827636; c=relaxed/simple;
	bh=jlGazAAjwv3vnW7ub1fNd56wopH+cL5WA+AnUCKDuRg=;
	h=Date:To:From:Subject:Message-Id; b=Z0k8ykszfmm5YzpdzVb5UvsN2qHAzjaw0aldTi6f6zrW84BlDlNLaiDbiqSNMcAYvix8/CpYdWOPGqdI0EkQfCMm3aRdK0QYj0ngHE4SLuTv8bDDvi7D3xGVIkhlv4Pq+GZybvFE72EAveOma5BbpJvDgKTPkO4D2niSOKXiN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jwk04543; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jwk04543"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956CDC4CEDD;
	Thu,  6 Feb 2025 07:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827635;
	bh=jlGazAAjwv3vnW7ub1fNd56wopH+cL5WA+AnUCKDuRg=;
	h=Date:To:From:Subject:From;
	b=Jwk04543lIrfYs/WzkRlrXQW52ePuW0scEy8eA18avwxBYQe49gpGS46+dwv7OwEQ
	 8MK6CvalfdqdWCAGiXrRWoJXyuReAIhB71O1ptntRNL1InY+FCiuaWiMW1MlQSNWrA
	 T8kjbXU3W2Zvh/MdxFdZw5tYLlgHFe0TYCCXbMEM=
Date: Wed, 05 Feb 2025 23:40:34 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-mmap-locking-operations-for-madvise.patch added to mm-unstable branch
Message-Id: <20250206074035.956CDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: split out mmap locking operations for madvise()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-mmap-locking-operations-for-madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-mmap-locking-operations-for-madvise.patch

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

Link: https://lkml.kernel.org/r/20250206061517.2958-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250206061517.2958-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise
+++ a/mm/madvise.c
@@ -1574,6 +1574,33 @@ int madvise_set_anon_name(struct mm_stru
 				 madvise_vma_anon_name);
 }
 #endif /* CONFIG_ANON_VMA_NAME */
+
+static int madvise_lock(struct mm_struct *mm, int behavior)
+{
+
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+		return 0;
+#endif
+
+	if (madvise_need_mmap_write(behavior)) {
+		if (mmap_write_lock_killable(mm))
+			return -EINTR;
+	} else {
+		mmap_read_lock(mm);
+	}
+	return 0;
+
+}
+
+static void madvise_unlock(struct mm_struct *mm, int behavior)
+{
+	if (madvise_need_mmap_write(behavior))
+		mmap_write_unlock(mm);
+	else
+		mmap_read_unlock(mm);
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1650,7 +1677,6 @@ int do_madvise(struct mm_struct *mm, uns
 {
 	unsigned long end;
 	int error;
-	int write;
 	size_t len;
 	struct blk_plug plug;
 
@@ -1672,19 +1698,15 @@ int do_madvise(struct mm_struct *mm, uns
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
 
@@ -1701,10 +1723,7 @@ int do_madvise(struct mm_struct *mm, uns
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

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

