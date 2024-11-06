Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA08156962
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854723; cv=none; b=J5UB8si4ee35Z3+D4DRisvVHhPLLvyUJdHgav/sw0wV8lm7QnflXfIxfzV9u4tMji1JGeLICTF0+OCA0r+qwKLJnLiE39CnLUaebiJNLrY2LNV98zgndmVSlcm2nOOtXCMO4NnbjO22aleuSAg+fxUX1imSI07pWURgumwALPY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854723; c=relaxed/simple;
	bh=wT4RbjrkQ7l/YaqlwIqipdpH08uCCqDcZdDT4tOegLQ=;
	h=Date:To:From:Subject:Message-Id; b=Ki29UsZcX2VSDV4AaGqszeo6O+wn83n6eshh3FWNKHTDhShcGDj+TQtez6G2x+LOAIvj+XB98Am4Jbk69GvssuN55sDP0SQEqRgrj3CMw1ZZgckpM/BeUPUXFyFR5oulcwEtrl260K+5zQoLVVV0L5LMNHqjCeioVCG5dLXNa/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XsdcQUL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XsdcQUL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0423C4CECF;
	Wed,  6 Nov 2024 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854722;
	bh=wT4RbjrkQ7l/YaqlwIqipdpH08uCCqDcZdDT4tOegLQ=;
	h=Date:To:From:Subject:From;
	b=XsdcQUL+yPQtJq5f8/gGl29SCUc1h9tzKZoih+AeLun2WdajUX5nN1OYn8p1MNcyb
	 NRsv1CExPmlDeXd3bGLd9NGXZHRJWnMzLj03HPcGAWxqSt8SeFwvh2OtuCNkTHlue5
	 WLuihEx+c9E1AGK8aP/uVv7qukhW9bUVogWGChGc=
Date: Tue, 05 Nov 2024 16:58:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,pedro.falcato@gmail.com,minchan@kernel.org,Liam.Howlett@oracle.com,brauner@kernel.org,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-unrestrict-process_madvise-for-current-process.patch removed from -mm tree
Message-Id: <20241106005842.A0423C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: unrestrict process_madvise() for current process
has been removed from the -mm tree.  Its filename was
     mm-madvise-unrestrict-process_madvise-for-current-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: unrestrict process_madvise() for current process
Date: Thu, 26 Sep 2024 16:10:19 +0100

The process_madvise() call was introduced in commit ecb8ac8b1f14
("mm/madvise: introduce process_madvise() syscall: an external memory
hinting API") as a means of performing madvise() operations on another
process.

However, as it provides the means by which to perform multiple madvise()
operations in a batch via an iovec, it is useful to utilise the same
interface for performing operations on the current process rather than a
remote one.

Commit 22af8caff7d1 ("mm/madvise: process_madvise() drop capability check
if same mm") removed the need for a caller invoking process_madvise() on
its own pidfd to possess the CAP_SYS_NICE capability, however this leaves
the restrictions on operation in place.

Resolve this by only applying the restriction on operations when accessing
a remote process.

Moving forward we plan to implement a simpler means of specifying this
condition other than needing to establish a self pidfd, perhaps in the
form of a sentinel pidfd.

Also take the opportunity to refactor the system call implementation
abstracting the vectorised operation.

Link: https://lkml.kernel.org/r/20240926151019.82902-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   55 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 19 deletions(-)

--- a/mm/madvise.c~mm-madvise-unrestrict-process_madvise-for-current-process
+++ a/mm/madvise.c
@@ -1208,7 +1208,8 @@ madvise_behavior_valid(int behavior)
 	}
 }
 
-static bool process_madvise_behavior_valid(int behavior)
+/* Can we invoke process_madvise() on a remote mm for the specified behavior? */
+static bool process_madvise_remote_valid(int behavior)
 {
 	switch (behavior) {
 	case MADV_COLD:
@@ -1477,6 +1478,28 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	return do_madvise(current->mm, start, len_in, behavior);
 }
 
+/* Perform an madvise operation over a vector of addresses and lengths. */
+static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
+			      int behavior)
+{
+	ssize_t ret = 0;
+	size_t total_len;
+
+	total_len = iov_iter_count(iter);
+
+	while (iov_iter_count(iter)) {
+		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
+				 iter_iov_len(iter), behavior);
+		if (ret < 0)
+			break;
+		iov_iter_advance(iter, iter_iov_len(iter));
+	}
+
+	ret = (total_len - iov_iter_count(iter)) ? : ret;
+
+	return ret;
+}
+
 SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 		size_t, vlen, int, behavior, unsigned int, flags)
 {
@@ -1486,7 +1509,6 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	struct iov_iter iter;
 	struct task_struct *task;
 	struct mm_struct *mm;
-	size_t total_len;
 	unsigned int f_flags;
 
 	if (flags != 0) {
@@ -1504,11 +1526,6 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto free_iov;
 	}
 
-	if (!process_madvise_behavior_valid(behavior)) {
-		ret = -EINVAL;
-		goto release_task;
-	}
-
 	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
 	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (IS_ERR(mm)) {
@@ -1517,25 +1534,25 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	}
 
 	/*
+	 * We need only perform this check if we are attempting to manipulate a
+	 * remote process's address space.
+	 */
+	if (mm != current->mm && !process_madvise_remote_valid(behavior)) {
+		ret = -EINVAL;
+		goto release_mm;
+	}
+
+	/*
 	 * Require CAP_SYS_NICE for influencing process performance. Note that
-	 * only non-destructive hints are currently supported.
+	 * only non-destructive hints are currently supported for remote
+	 * processes.
 	 */
 	if (mm != current->mm && !capable(CAP_SYS_NICE)) {
 		ret = -EPERM;
 		goto release_mm;
 	}
 
-	total_len = iov_iter_count(&iter);
-
-	while (iov_iter_count(&iter)) {
-		ret = do_madvise(mm, (unsigned long)iter_iov_addr(&iter),
-					iter_iov_len(&iter), behavior);
-		if (ret < 0)
-			break;
-		iov_iter_advance(&iter, iter_iov_len(&iter));
-	}
-
-	ret = (total_len - iov_iter_count(&iter)) ? : ret;
+	ret = vector_madvise(mm, &iter, behavior);
 
 release_mm:
 	mmput(mm);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

