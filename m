Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5778B60
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423575; cv=none; b=cwajmY+iDsYlwTJAe9hP0pwQNxryQ+nr1NhZLVL38Sa4dliGx0Rc/SfnyJoKy55EfkNhyv2KuivbR3I9kq1Zb9ECuDdyMoqMyAy37vOjYoEr09RJpIk3CmvgAwRmmOSgwiZuSmhLZa4Ljhzdl6OKJwrM6TxwsqQx8AYykCBe9FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423575; c=relaxed/simple;
	bh=DIWfffc46gYsHdKfIWHvtSqMHyMTCtAq7pNzeiIMElI=;
	h=Date:To:From:Subject:Message-Id; b=CW2KzM5vwCpewy44Cd1TacGtXHEVokje7OeTw8UelJvY/+WWBMmbaZ6msrerrGksdAKB/bgMnw12icPFyUZw5DJtHe3ueiYyLwIFtHZJKQ7bbJLetY3yZ5px7LHW917HHEeLHzfVuThe2yNPyCYACj3HrXjePbLwMD/zWSQqA+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ylZ2qSoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ylZ2qSoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441A6C4CEC2;
	Wed,  4 Sep 2024 04:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423575;
	bh=DIWfffc46gYsHdKfIWHvtSqMHyMTCtAq7pNzeiIMElI=;
	h=Date:To:From:Subject:From;
	b=ylZ2qSoZrpXBopeHJRdwcw8c5hH8OCETbeRFp+PxIfbXU6yAnepSxb298w4vmXrDi
	 EEqlra44KhDCLxtMqS1mKSLl2s0hUiin7tnA1XPjXbBFM5Tn5gVcuMYqCbqbKMCrex
	 1D0T/7bvP/yK3F4LmkJbOJxu6pO4oQZcgI57piKY=
Date: Tue, 03 Sep 2024 21:19:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-may_expand_vm-check-in-mmap_region.patch removed from -mm tree
Message-Id: <20240904041935.441A6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move may_expand_vm() check in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-move-may_expand_vm-check-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: move may_expand_vm() check in mmap_region()
Date: Fri, 30 Aug 2024 00:00:59 -0400

The may_expand_vm() check requires the count of the pages within the
munmap range.  Since this is needed for accounting and obtained later, the
reodering of ma_expand_vm() to later in the call stack, after the vma
munmap struct (vms) is initialised and the gather stage is potentially
run, will allow for a single loop over the vmas.  The gather sage does not
commit any work and so everything can be undone in the case of a failure.

The MAP_FIXED page count is available after the vms_gather_munmap_vmas()
call, so use it instead of looping over the vmas twice.

Link: https://lkml.kernel.org/r/20240830040101.822209-20-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 ++++-----------
 mm/vma.c  |   21 ---------------------
 mm/vma.h  |    3 ---
 3 files changed, 4 insertions(+), 35 deletions(-)

--- a/mm/mmap.c~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/mmap.c
@@ -1376,17 +1376,6 @@ unsigned long mmap_region(struct file *f
 	pgoff_t vm_pgoff;
 	int error = -ENOMEM;
 	VMA_ITERATOR(vmi, mm, addr);
-	unsigned long nr_pages, nr_accounted;
-
-	nr_pages = count_vma_pages_range(mm, addr, end, &nr_accounted);
-
-	/*
-	 * Check against address space limit.
-	 * MAP_FIXED may remove pages of mappings that intersects with requested
-	 * mapping. Account for the pages it would unmap.
-	 */
-	if (!may_expand_vm(mm, vm_flags, pglen - nr_pages))
-		return -ENOMEM;
 
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
@@ -1410,6 +1399,10 @@ unsigned long mmap_region(struct file *f
 			vma_iter_next_range(&vmi);
 	}
 
+	/* Check against address space limit. */
+	if (!may_expand_vm(mm, vm_flags, pglen - vms.nr_pages))
+		goto abort_munmap;
+
 	/*
 	 * Private writable mapping: check memory availability
 	 */
--- a/mm/vma.c~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/vma.c
@@ -1640,27 +1640,6 @@ bool vma_wants_writenotify(struct vm_are
 	return vma_fs_can_writeback(vma);
 }
 
-unsigned long count_vma_pages_range(struct mm_struct *mm,
-		unsigned long addr, unsigned long end,
-		unsigned long *nr_accounted)
-{
-	VMA_ITERATOR(vmi, mm, addr);
-	struct vm_area_struct *vma;
-	unsigned long nr_pages = 0;
-
-	*nr_accounted = 0;
-	for_each_vma_range(vmi, vma, end) {
-		unsigned long vm_start = max(addr, vma->vm_start);
-		unsigned long vm_end = min(end, vma->vm_end);
-
-		nr_pages += PHYS_PFN(vm_end - vm_start);
-		if (vma->vm_flags & VM_ACCOUNT)
-			*nr_accounted += PHYS_PFN(vm_end - vm_start);
-	}
-
-	return nr_pages;
-}
-
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
--- a/mm/vma.h~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/vma.h
@@ -319,9 +319,6 @@ bool vma_wants_writenotify(struct vm_are
 
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
-unsigned long count_vma_pages_range(struct mm_struct *mm,
-				    unsigned long addr, unsigned long end,
-				    unsigned long *nr_accounted);
 
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


