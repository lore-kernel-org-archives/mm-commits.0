Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F28D27E07A
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 06:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769150207; cv=none; b=BZN9ZIrHiBe9R2D6YAE5VZRz7pFaE1+L8PxaDbE31rgRMWxvzLwB2Mtfwh3/q3hVxDywKf/OsXd2AEITsB8bPo6QzkzYofAqJ2OraWcw749A9VR3Ufr3lKMhZkNQML4PzF7kx/y5u3HMgYqMtsvjyICDrOvisTE6G4ddJjEyc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769150207; c=relaxed/simple;
	bh=ovMjy2OMdxihVCv6qgGG6LBLg2bNhcQsRLO12kIdlQ8=;
	h=Date:To:From:Subject:Message-Id; b=iE3RQsSUxqmAMNRyJiqNkfA4uB0LccK0UmJjQakeH5AHMf65pfTfZSIPAaqoh3lJXGM9U5X2yAJJa1ETNXbIhFcOQ5YFho/7snhEqdUEDZSrFbNNH6sVy6ecDAlvG06qasRs4GbaqBAxBVz84ZA/1pVLjd7gOvDKzrIGvlQBwJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=chM9lXZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="chM9lXZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B6AC4CEF1;
	Fri, 23 Jan 2026 06:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769150206;
	bh=ovMjy2OMdxihVCv6qgGG6LBLg2bNhcQsRLO12kIdlQ8=;
	h=Date:To:From:Subject:From;
	b=chM9lXZibfZg96S6FJsGtfBRN3yIarcEopvoR8M5hhFoZF+VDQC1U/FsKetXVXclx
	 sqOfQsGfpMUXnxlgjH7IWUbjBGJC73/NJnyLMkyMZwrg5rv3ewQVu5hxX3r9KKd20e
	 praBIb4wKTHCY6Dx8BYTdaNvyE+PAwvmnEwO4wNk=
Date: Thu, 22 Jan 2026 22:36:45 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch added to mm-new branch
Message-Id: <20260123063646.A7B6AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
Date: Thu Jan 22 10:34:19 PM PST 2026

comment fixes, per Baolin

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
+++ a/mm/shmem.c
@@ -5869,7 +5869,7 @@ static struct file *__shmem_file_setup(s
  *	checks are provided at the key or shm level rather than the inode.
  * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
- * @vma_flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
+ * @flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
  */
 struct file *shmem_kernel_file_setup(const char *name, loff_t size,
 				     vma_flags_t flags)
@@ -5882,7 +5882,7 @@ EXPORT_SYMBOL_GPL(shmem_kernel_file_setu
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
- * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ * @flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
  */
 struct file *shmem_file_setup(const char *name, loff_t size, vma_flags_t flags)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

