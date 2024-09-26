Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A5175568
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381588; cv=none; b=QMvImbieHzXBuqMqAAhKJAjwwvZ/w+birZsC+uza/58vxVDnRJz9N33L/ngEwy89AQBrKjm9SpQkiWNC8HX+pRW8+nFEiRyrbsw0H4LBnM4VT8mV3UgQjuBlASxYMJHahYdH7s7+G5jCaMbuqT3RG+CVCIh4mEJ20ML1fJu+gKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381588; c=relaxed/simple;
	bh=V//2hSbbqpT/JVEtLDYqtSwM0iC5A8Rsu6ep0hKsCwQ=;
	h=Date:To:From:Subject:Message-Id; b=iqR36Y9oJw2Ts0tsG6ruaKizNTVo7O8XbDnepZyNG84XERo3sbtFt49XRPk38Jis3jM42iyp9nIf8xsPyha03Yi9ZtibjAKXzP79gvlXgj+Z4CZ+RcqpRFjB5tLTA0hok75PWuHRWY59Vex0zNHAoxVrAQFXfJsWkFi6VyJRC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njo836hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njo836hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D875C4CEC7;
	Thu, 26 Sep 2024 20:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727381588;
	bh=V//2hSbbqpT/JVEtLDYqtSwM0iC5A8Rsu6ep0hKsCwQ=;
	h=Date:To:From:Subject:From;
	b=njo836hlpC4iZ8mqlYPusFl+SwkhEiVgFIgOQ+z2cTTNleBS6hgrzAIp/SjN2pxPW
	 0LPo3UUsUWPq6UGcoR5nHBUzzw2582D4B8shfSAFhlbVF9IEFsGy/e+wz4fwjnSbHV
	 DVrZS+jWs+s4EamRYPchOYqNu5Uv3BEDzbHhmgFU=
Date: Thu, 26 Sep 2024 13:13:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,pedro.falcato@gmail.com,minchan@kernel.org,Liam.Howlett@oracle.com,brauner@kernel.org,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-unrestrict-process_madvise-for-current-process.patch added to mm-unstable branch
Message-Id: <20240926201308.2D875C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: unrestrict process_madvise() for current process
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-unrestrict-process_madvise-for-current-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-unrestrict-process_madvise-for-current-process.patch

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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

tools-fix-shared-radix-tree-build.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch

