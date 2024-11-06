Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D055161320
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854712; cv=none; b=UX2cJDgBLMuN2lYgHPsn2FB5wiccevfYsW37I0EkzrcO7ey9BVhNjBSVwWU7MEZ1oBVgxghSKbQcwlgMg15B3PKWrPjUbMWGL/pzrXBCiDvDxb0v0vbsv5xhe/RZnEEadrdvThzB7/VjdONrsoGWjrRWghvX6Hoy5omdmEJz/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854712; c=relaxed/simple;
	bh=lE8wnhZ/mrIdqRBNDX4fouda6sm8Z16FRO2AUtBjga0=;
	h=Date:To:From:Subject:Message-Id; b=V3oZ7Xea/IVc5f+wZLPHm5O6qMFvByYL10VmKXOuKKPpsq2Bdw1hsNe3s0ygAogXikY//BmBFwBZVRfptuvwySysVYhZIMYdtLgmthH8ISmhSRaT9GwUbE5B8NUF3+6LsRlpcCBV7IVxwfRbMIsgFyaHANzIT5RhZYz4P0FdBDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t74tz+I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t74tz+I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB158C4CECF;
	Wed,  6 Nov 2024 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854711;
	bh=lE8wnhZ/mrIdqRBNDX4fouda6sm8Z16FRO2AUtBjga0=;
	h=Date:To:From:Subject:From;
	b=t74tz+I6YpAd4r57y59c3e/9U/oxru/+lQj7PvbwbtHNOflHk7iGFMqGzeYuIVVNN
	 C8CpKapa+dhDHyb7UUS6CNsEXHtiBw4jY8RKh6x1B920VYbnBpToLSD6jmsd8JZDri
	 Y5oItP6EK0NJJqC0d05TzZMT3MGcKdJqRObYfcP0=
Date: Tue, 05 Nov 2024 16:58:31 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-mm_access-to-not-return-null.patch removed from -mm tree
Message-Id: <20241106005831.AB158C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor mm_access() to not return NULL
has been removed from the -mm tree.  Its filename was
     mm-refactor-mm_access-to-not-return-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: prefer neater pointer error comparison]
  Link: https://lkml.kernel.org/r/2fae1834-749a-45e1-8594-5e5979cf7103@lucifer.local
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
+		return mm == ERR_PTR(-ESRCH) ? NULL : mm;
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
@@ -1546,8 +1546,9 @@ struct mm_struct *mm_access(struct task_
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
@@ -1511,8 +1511,8 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
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

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

