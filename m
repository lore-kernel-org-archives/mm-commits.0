Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D769534AAE4
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517859; cv=none; b=dpN+/MMIe2YZobCpzCA1Qx95twZfhA8kB3xwM1RuBz7Nyd9RXc3gCGRvN3Tmi8sYD7q7nH3Id58HZKluekOYCeO79RSqicT9f15a0cuG2GQdg2snfaF/ztJnJ/qJ8ZTdXA9OrJbM/ZIGeD6JoIMc9ToRAH3SoO+22PDAejUF9Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517859; c=relaxed/simple;
	bh=RToY4slrvpj7Z3WwB99Rmn6zjDfuEg/TNDXVhXNdxrE=;
	h=Date:To:From:Subject:Message-Id; b=a9VBIWGYH6paOWYL2+2lIWXMWNURBnyly1GEjyNsLe/YlQOxnEt/o2KAdbHlWY+7Rs7OYcZ+3WbcxvPkG9NGtIRrKpNDC+0cZ4ILTt5HpVdoZiZuhcnQSCe37+/sCwUQ4frJQ4Njt7X9bzjWh/T1TPobvSVSWvpUtklPQdtfMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NBth9Rna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NBth9Rna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57860C113D0;
	Tue, 23 Dec 2025 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517859;
	bh=RToY4slrvpj7Z3WwB99Rmn6zjDfuEg/TNDXVhXNdxrE=;
	h=Date:To:From:Subject:From;
	b=NBth9Rna/wg4AS1HBezI43GvpuahPbPVlp+quC6cuMpfRYIqAycESBhOgQNhXZLlz
	 LKfZQXW/fRTs0pCS4u5dm02+c2FKXjAlJ9pIOJRJJ7cs/vqPYvSaDeD+qVFsxSKuIT
	 PH71FFq8MTC1nput02TDu/D7IQvQonUqqzj0UOIw=
Date: Tue, 23 Dec 2025 11:24:18 -0800
To: mm-commits@vger.kernel.org,zhiw@nvidia.com,yishaih@nvidia.com,vsethi@nvidia.com,nao.horiguchi@gmail.com,mochs@nvidia.com,linmiaohe@huawei.com,kevin.tian@intel.com,jgg@nvidia.com,cjia@nvidia.com,ankita@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fixup-pfnmap-memory-failure-handling-to-use-pgoff.patch removed from -mm tree
Message-Id: <20251223192419.57860C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fixup pfnmap memory failure handling to use pgoff
has been removed from the -mm tree.  Its filename was
     mm-fixup-pfnmap-memory-failure-handling-to-use-pgoff.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankit Agrawal <ankita@nvidia.com>
Subject: mm: fixup pfnmap memory failure handling to use pgoff
Date: Thu, 11 Dec 2025 07:06:01 +0000

The memory failure handling implementation for the PFNMAP memory with no
struct pages is faulty.  The VA of the mapping is determined based on the
the PFN.  It should instead be based on the file mapping offset.

At the occurrence of poison, the memory_failure_pfn is triggered on the
poisoned PFN.  Introduce a callback function that allows mm to translate
the PFN to the corresponding file page offset.  The kernel module using
the registration API must implement the callback function and provide the
translation.  The translated value is then used to determine the VA
information and sending the SIGBUS to the usermode process mapped to the
poisoned PFN.

The callback is also useful for the driver to be notified of the poisoned
PFN, which may then track it.

Link: https://lkml.kernel.org/r/20251211070603.338701-2-ankita@nvidia.com
Fixes: 2ec41967189c ("mm: handle poisoning of pfn without struct pages")
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Matthew R. Ochs <mochs@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Neo Jia <cjia@nvidia.com>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-failure.h |    2 ++
 mm/memory-failure.c            |   29 ++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/linux/memory-failure.h~mm-fixup-pfnmap-memory-failure-handling-to-use-pgoff
+++ a/include/linux/memory-failure.h
@@ -9,6 +9,8 @@ struct pfn_address_space;
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
+	int (*pfn_to_vma_pgoff)(struct vm_area_struct *vma,
+				unsigned long pfn, pgoff_t *pgoff);
 };
 
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
--- a/mm/memory-failure.c~mm-fixup-pfnmap-memory-failure-handling-to-use-pgoff
+++ a/mm/memory-failure.c
@@ -2161,6 +2161,9 @@ int register_pfn_address_space(struct pf
 {
 	guard(mutex)(&pfn_space_lock);
 
+	if (!pfn_space->pfn_to_vma_pgoff)
+		return -EINVAL;
+
 	if (interval_tree_iter_first(&pfn_space_itree,
 				     pfn_space->node.start,
 				     pfn_space->node.last))
@@ -2183,10 +2186,10 @@ void unregister_pfn_address_space(struct
 }
 EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
 
-static void add_to_kill_pfn(struct task_struct *tsk,
-			    struct vm_area_struct *vma,
-			    struct list_head *to_kill,
-			    unsigned long pfn)
+static void add_to_kill_pgoff(struct task_struct *tsk,
+			      struct vm_area_struct *vma,
+			      struct list_head *to_kill,
+			      pgoff_t pgoff)
 {
 	struct to_kill *tk;
 
@@ -2197,12 +2200,12 @@ static void add_to_kill_pfn(struct task_
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pfn, 1);
+	tk->addr = vma_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
 		pr_info("Unable to find address %lx in %s\n",
-			pfn, tsk->comm);
+			pgoff, tsk->comm);
 
 	get_task_struct(tsk);
 	tk->tsk = tsk;
@@ -2212,11 +2215,12 @@ static void add_to_kill_pfn(struct task_
 /*
  * Collect processes when the error hit a PFN not backed by struct page.
  */
-static void collect_procs_pfn(struct address_space *mapping,
+static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 			      unsigned long pfn, struct list_head *to_kill)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
+	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
 	rcu_read_lock();
@@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct add
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
-			if (vma->vm_mm == t->mm)
-				add_to_kill_pfn(t, vma, to_kill, pfn);
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+			pgoff_t pgoff;
+
+			if (vma->vm_mm == t->mm &&
+			    !pfn_space->pfn_to_vma_pgoff(vma, pfn, &pgoff))
+				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
 	rcu_read_unlock();
@@ -2264,7 +2271,7 @@ static int memory_failure_pfn(unsigned l
 			struct pfn_address_space *pfn_space =
 				container_of(node, struct pfn_address_space, node);
 
-			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
+			collect_procs_pfn(pfn_space, pfn, &tokill);
 
 			mf_handled = true;
 		}
_

Patches currently in -mm which might be from ankita@nvidia.com are


