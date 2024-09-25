Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81119156257
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 09:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727257055; cv=none; b=mbXyrzurhz3So2MESitXbOfIK7DSw+wdLDcUTLIx1+e1E8ddVV38Gt25goqnw4gQSXdYQcm8+EIQhuwgRxKWcSR4/zJBuifB3eiVCF4FVU6mO389yt7FNQWFSX0b+lLVJitURADyePP5amUua0awa2hqH8z6NWMzxF9LtUcliOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727257055; c=relaxed/simple;
	bh=g3I5GdSeSiFtGg3RYwlVkBV72oOhgeKIWe3hOBWI7bE=;
	h=Date:To:From:Subject:Message-Id; b=RI7eekZGMIG8r2IkDhaFBDcEwMJFwEJTWVU28ogz9U9w2c80BhKNBzkajh2g1k24KpDXAcyZ2pr4sjA9HPCzSiNmTCwCFxPptYnPQitBpvQWEAfv9S+yfVBjMj6BFtW2nFaMSavsUH3tZ0CmDAfz3rUMjurGUrmw0YIePRxMK68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GTn1catC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GTn1catC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D62C4CEC7;
	Wed, 25 Sep 2024 09:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727257055;
	bh=g3I5GdSeSiFtGg3RYwlVkBV72oOhgeKIWe3hOBWI7bE=;
	h=Date:To:From:Subject:From;
	b=GTn1catCAhkYgbT1xy1Wwoyf333zXSwXsjZvxWK9hMyp1XQxS7/JBDMDSokBr+sju
	 Pxdl/usuxPF1/az2HpWqilonzU/tFVBwMf/nvivEUAiDgPQny+k1mPesaUpwcoTMnm
	 yX6/j0pQjfpGO1AL9bGEmlxWGBBwjHOCqYBXp9C0=
Date: Wed, 25 Sep 2024 02:37:34 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-mm_access-to-not-return-null.patch added to mm-unstable branch
Message-Id: <20240925093735.03D62C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor mm_access() to not return NULL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-mm_access-to-not-return-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-mm_access-to-not-return-null.patch

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
Subject: mm: refactor mm_access() to not return NULL
Date: Tue, 24 Sep 2024 21:10:23 +0100

mm_access() can return NULL if the mm is not found, but this is handled
the same as an error in all callers, with some translating this into an
-ESRCH error.

Only proc_mem_open() returns NULL if no mm is found, however in this case
it is clearer and makes more sense to explicitly handle the error. 
Additionally we take the opportunity to refactor the function to eliminate
unnecessary nesting.

Simplify things by simply returning -ESRCH if no mm is found - this both
eliminates confusing use of the IS_ERR_OR_NULL() macro, and simplifies
callers which would return -ESRCH by returning this error directly.

Link: https://lkml.kernel.org/r/20240924201023.193135-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c         |   26 ++++++++++++++------------
 kernel/fork.c          |    5 +++--
 mm/madvise.c           |    4 ++--
 mm/process_vm_access.c |    4 ++--
 4 files changed, 21 insertions(+), 18 deletions(-)

--- a/fs/proc/base.c~mm-refactor-mm_access-to-not-return-null
+++ a/fs/proc/base.c
@@ -832,19 +832,21 @@ static const struct file_operations proc
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(inode);
-	struct mm_struct *mm = ERR_PTR(-ESRCH);
+	struct mm_struct *mm;
 
-	if (task) {
-		mm = mm_access(task, mode | PTRACE_MODE_FSCREDS);
-		put_task_struct(task);
+	if (!task)
+		return ERR_PTR(-ESRCH);
 
-		if (!IS_ERR_OR_NULL(mm)) {
-			/* ensure this mm_struct can't be freed */
-			mmgrab(mm);
-			/* but do not pin its memory */
-			mmput(mm);
-		}
-	}
+	mm = mm_access(task, mode | PTRACE_MODE_FSCREDS);
+	put_task_struct(task);
+
+	if (IS_ERR(mm))
+		return PTR_ERR(mm) == -ESRCH ? NULL : mm;
+
+	/* ensure this mm_struct can't be freed */
+	mmgrab(mm);
+	/* but do not pin its memory */
+	mmput(mm);
 
 	return mm;
 }
@@ -2208,7 +2210,7 @@ static int map_files_d_revalidate(struct
 		goto out_notask;
 
 	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
-	if (IS_ERR_OR_NULL(mm))
+	if (IS_ERR(mm))
 		goto out;
 
 	if (!dname_to_vma_addr(dentry, &vm_start, &vm_end)) {
--- a/kernel/fork.c~mm-refactor-mm_access-to-not-return-null
+++ a/kernel/fork.c
@@ -1545,8 +1545,9 @@ struct mm_struct *mm_access(struct task_
 		return ERR_PTR(err);
 
 	mm = get_task_mm(task);
-	if (mm && mm != current->mm &&
-			!ptrace_may_access(task, mode)) {
+	if (!mm) {
+		mm = ERR_PTR(-ESRCH);
+	} else if (mm != current->mm && !ptrace_may_access(task, mode)) {
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
--- a/mm/madvise.c~mm-refactor-mm_access-to-not-return-null
+++ a/mm/madvise.c
@@ -1537,8 +1537,8 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
 	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
 	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
-	if (IS_ERR_OR_NULL(mm)) {
-		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
 		goto release_task;
 	}
 
--- a/mm/process_vm_access.c~mm-refactor-mm_access-to-not-return-null
+++ a/mm/process_vm_access.c
@@ -201,8 +201,8 @@ static ssize_t process_vm_rw_core(pid_t
 	}
 
 	mm = mm_access(task, PTRACE_MODE_ATTACH_REALCREDS);
-	if (!mm || IS_ERR(mm)) {
-		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
+	if (IS_ERR(mm)) {
+		rc = PTR_ERR(mm);
 		/*
 		 * Explicitly map EACCES to EPERM as EPERM is a more
 		 * appropriate error code for process_vw_readv/writev
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-fix-shared-radix-tree-build.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch
selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch

