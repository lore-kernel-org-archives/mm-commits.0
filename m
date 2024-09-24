Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906EC13D25E
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215173; cv=none; b=GPwST3hbjnQzvTTgR+zA1Bgc9sv2ek6L55RwrY1gu9JjlDbd0q46uWg7CkDSBzlfEvef4dOTrMtYA+hRolFV60cHr0zAjZ3bLp2/LzYdOppjjawz8pFnu2RS0dVwhEQ7AKHLtMtRYiMOozjt2V42xLuP/7T5giKcSYXzFKomrQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215173; c=relaxed/simple;
	bh=HXO9BnQ9dhrvVsC/EU4gB03uy8IvK0G2QNoOxkiL2rM=;
	h=Date:To:From:Subject:Message-Id; b=aFN0/fljEgGoXjWRDuhy2jf3UNCbw7bdB462XsyI2mRL9fOrwvnkMvU1Z7VTaszn73y6G8TxIUfjIOQMPCDB0lWGwLMQUk5pWsDvsguDAaG8vGqEKQ6WjG2MF30Ggw936vS+wAMHQUDwSczHzOProENEvMZTX9xYgM+Z1h423IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Q/0VQVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Q/0VQVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6ADC4CEC4;
	Tue, 24 Sep 2024 21:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727215173;
	bh=HXO9BnQ9dhrvVsC/EU4gB03uy8IvK0G2QNoOxkiL2rM=;
	h=Date:To:From:Subject:From;
	b=1Q/0VQVMaezJ/HXM3yikCYKz0Ed6lmSh3H+vPOjdJGbA+4VA1IeBxzK93e8mb+qJT
	 jKd5e8CK2vzUe+ouEt1iqFX0iEn9I6cs/OtwORGp0XhBdi2ur0sOGCcVBR7vgJF7wl
	 vVWCeBqgHp/O3XMjfi0rpVhKxwKabsBmUvZ+Z/es=
Date: Tue, 24 Sep 2024 14:59:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,shakeel.butt@linux.dev,richard.henderson@linaro.org,minchan@kernel.org,mattst88@gmail.com,Liam.Howlett@oracle.com,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,deller@gmx.de,chris@zankel.net,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch added to mm-unstable branch
Message-Id: <20240924215933.0D6ADC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: introduce PR_MADV_SELF flag to process_madvise()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch

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
Subject: mm/madvise: introduce PR_MADV_SELF flag to process_madvise()
Date: Tue, 24 Sep 2024 12:16:27 +0100

Patch series "unrestrict process_madvise() for current process", v2.

The process_madvise() call was introduced in commit ecb8ac8b1f14
("mm/madvise: introduce process_madvise() syscall: an external memory
hinting API") as a means of performing madvise() operations on another
process.

However, as it provides the means by which to perform multiple madvise()
operations in a batch via an iovec, it is useful to utilise the same
interface for performing operations on the current process rather than a
remote one.

Using this interface targeting the current process is cumbersome - a pidfd
needs to be setup for the current pid, and we are limited to only a subset
of madvise() operations, a limitation sensible for manipulating remote
processes but not meaningful when manipulating the current one.

Commit 22af8caff7d1 ("mm/madvise: process_madvise() drop capability check
if same mm") removed the need for a caller invoking process_madvise() on
its own pidfd to possess the CAP_SYS_NICE capability, however this leaves
the restrictions on operation in place and the cumbersome need for a 'self
pidfd'.

This patch series eliminates both limitations:

1. The restriction on permitted operations is removed when operating
   on the current process.

2. A new flag is introduced - PR_MADV_SELF - which eliminates the need for
   a pidfd - if this flag is set, the pidfd argument is ignored and the
   operation is simply applied to the current process.

Therefore a user can simply invoke:

	process_madvise(0, iovec, n, MADV_..., PR_MADV_SELF);

And perform any madvise() operation they like on the n ranges specified by
the iovec parameter.

This series also introduces a series of self-tests for this feature
asserting that the flag functions as expected.


This patch (of 2):

process_madvise() was conceived as a useful means for performing a vector
of madvise() operations on a remote process's address space.

However it's useful to be able to do so on the current process also.  It
is currently rather clunky to do this (requiring a pidfd to be opened for
the current process) and introduces unnecessary overhead in incrementing
reference counts for the task and mm.

Avoid all of this by providing a PR_MADV_SELF flag, which causes
process_madvise() to simply ignore the pidfd parameter and instead apply
the operation to the current process.

Since we are operating on our own process, no restrictions need be applied
on behaviors we can perform, so do not limit these in that case.

Also extend the case of a user specifying the current process via pidfd to
not be restricted on behaviors which can be performed.

Link: https://lkml.kernel.org/r/cover.1727176176.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/1ecf2692b3bcdd693ad61d510ce0437abb43a1bd.1727176176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    2 
 arch/mips/include/uapi/asm/mman.h      |    2 
 arch/parisc/include/uapi/asm/mman.h    |    2 
 arch/xtensa/include/uapi/asm/mman.h    |    2 
 include/uapi/asm-generic/mman-common.h |    2 
 mm/madvise.c                           |   66 ++++++++++++++++-------
 6 files changed, 56 insertions(+), 20 deletions(-)

--- a/arch/alpha/include/uapi/asm/mman.h~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -86,4 +86,6 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+#define PR_MADV_SELF	(1<<0)		/* process_madvise() flag - apply to self */
+
 #endif /* __ALPHA_MMAN_H__ */
--- a/arch/mips/include/uapi/asm/mman.h~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -113,4 +113,6 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+#define PR_MADV_SELF	(1<<0)		/* process_madvise() flag - apply to self */
+
 #endif /* _ASM_MMAN_H */
--- a/arch/parisc/include/uapi/asm/mman.h~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -83,4 +83,6 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+#define PR_MADV_SELF	(1<<0)		/* process_madvise() flag - apply to self */
+
 #endif /* __PARISC_MMAN_H__ */
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -121,4 +121,6 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+#define PR_MADV_SELF	(1<<0)		/* process_madvise() flag - apply to self */
+
 #endif /* _XTENSA_MMAN_H */
--- a/include/uapi/asm-generic/mman-common.h~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
+++ a/include/uapi/asm-generic/mman-common.h
@@ -87,4 +87,6 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+#define PR_MADV_SELF	(1<<0)		/* process_madvise() flag - apply to self */
+
 #endif /* __ASM_GENERIC_MMAN_COMMON_H */
--- a/mm/madvise.c~mm-madvise-introduce-pr_madv_self-flag-to-process_madvise
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
@@ -1486,10 +1509,9 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	struct iov_iter iter;
 	struct task_struct *task;
 	struct mm_struct *mm;
-	size_t total_len;
 	unsigned int f_flags;
 
-	if (flags != 0) {
+	if (flags & ~PR_MADV_SELF) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1498,17 +1520,21 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	if (ret < 0)
 		goto out;
 
+	/*
+	 * Perform an madvise operation on the current process. No restrictions
+	 * need be applied, nor do we need to pin the task or mm_struct.
+	 */
+	if (flags & PR_MADV_SELF) {
+		ret = vector_madvise(current->mm, &iter, behavior);
+		goto free_iov;
+	}
+
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task)) {
 		ret = PTR_ERR(task);
 		goto free_iov;
 	}
 
-	if (!process_madvise_behavior_valid(behavior)) {
-		ret = -EINVAL;
-		goto release_task;
-	}
-
 	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
 	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
@@ -1517,25 +1543,25 @@ SYSCALL_DEFINE5(process_madvise, int, pi
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
mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch
selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch

