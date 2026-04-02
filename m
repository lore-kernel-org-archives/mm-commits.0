Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8535D362149
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775104627; cv=none; b=VWDk69xag2zUxzmH10mhL88fBW+JZJyKY3PhvQlaPDqQb0kshiyy9B28dZhZmBoUTvrOmCqrYMqnEVZQUa8OXozWkxFhB+Ntt7pouzqDVs8vTsUptcDog1CSVr5slGKuGTYJzkN4hKsm+eJ2Y87coffIqsUFiEYNUk+P0XRpO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775104627; c=relaxed/simple;
	bh=why+5lsXMSKM6hd7u6pr8A5ydxzva5nZ+zWF/Z497+I=;
	h=Date:To:From:Subject:Message-Id; b=csJ3bp+rKj5ZMCCTGKzlj01RQ6bOvdGkM4VsrVXlozRsAFCLh9MRWbfhtu/SblzaW4HHPjvIQDLt0D8d6WM9cfxYI5bShwfbCeC0z3KCuOaCgNON82TMAzeh89nKmWUV4RxrkLHvmH9lqM5WI81B36s31KjnU++XzoWs4SkV9p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PoghraD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PoghraD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55887C19423;
	Thu,  2 Apr 2026 04:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775104627;
	bh=why+5lsXMSKM6hd7u6pr8A5ydxzva5nZ+zWF/Z497+I=;
	h=Date:To:From:Subject:From;
	b=PoghraD+Ji3KeTJ7d/t7gq5I7yyCYN3Wyckp9yZfe4PlpvkynBJEAqj2nKWQvxVN9
	 m9osliNnEzG/P1JUbrSyFOEcnHczfzuGEUZDxYNJUztqb+ouRVoasJ5SXi19XcjKTy
	 Atto/AaJ8TtCsgnsRbhOKNMWx/EkwWNxWlAth4oo=
Date: Wed, 01 Apr 2026 21:37:06 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generalize-handling-of-userfaults-in-__do_fault.patch added to mm-unstable branch
Message-Id: <20260402043707.55887C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: generalize handling of userfaults in __do_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-generalize-handling-of-userfaults-in-__do_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-generalize-handling-of-userfaults-in-__do_fault.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Peter Xu <peterx@redhat.com>
Subject: mm: generalize handling of userfaults in __do_fault()
Date: Thu, 2 Apr 2026 07:11:53 +0300

When a VMA is registered with userfaulfd, its ->fault() method should
check if a folio exists in the page cache and call handle_userfault() with
appropriate mode:

- VM_UFFD_MINOR if VMA is registered in minor mode and the folio exists
- VM_UFFD_MISSING if VMA is registered in missing mode and the folio
  does not exist

Instead of calling handle_userfault() directly from a specific ->fault()
handler, call __do_userfault() helper from the generic __do_fault().

For VMAs registered with userfaultfd the new __do_userfault() helper will
check if the folio is found in the page cache using
vm_uffd_ops->get_folio_noalloc() and call handle_userfault() with the
appropriate mode.

Make vm_uffd_ops->get_folio_noalloc() required method for non-anonymous
VMAs mapped at PTE level.

Link: https://lkml.kernel.org/r/20260402041156.1377214-13-rppt@kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c      |   43 +++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c       |   12 ------------
 mm/userfaultfd.c |    9 +++++++++
 3 files changed, 52 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-generalize-handling-of-userfaults-in-__do_fault
+++ a/mm/memory.c
@@ -5423,6 +5423,41 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode;
+	struct folio *folio;
+
+	if (!(userfaultfd_missing(vma) || userfaultfd_minor(vma)))
+		return 0;
+
+	inode = file_inode(vma->vm_file);
+	folio = vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
+	if (!IS_ERR_OR_NULL(folio)) {
+		/*
+		 * TODO: provide a flag for get_folio_noalloc() to avoid
+		 * locking (or even the extra reference?)
+		 */
+		folio_unlock(folio);
+		folio_put(folio);
+		if (userfaultfd_minor(vma))
+			return handle_userfault(vmf, VM_UFFD_MINOR);
+	} else {
+		if (userfaultfd_missing(vma))
+			return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
+
+	return 0;
+}
+#else
+static inline vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	return 0;
+}
+#endif
+
 /*
  * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
@@ -5455,6 +5490,14 @@ static vm_fault_t __do_fault(struct vm_f
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * If this is a userfault trap, process it in advance before
+	 * triggering the genuine fault handler.
+	 */
+	ret = __do_userfault(vmf);
+	if (ret)
+		return ret;
+
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
--- a/mm/shmem.c~mm-generalize-handling-of-userfaults-in-__do_fault
+++ a/mm/shmem.c
@@ -2483,13 +2483,6 @@ repeat:
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio))
-			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
-		return 0;
-	}
-
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
 					   sgp, gfp, vma, fault_type);
@@ -2534,11 +2527,6 @@ repeat:
 	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
-	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
-		return 0;
-	}
-
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
 	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
 	if (orders > 0) {
--- a/mm/userfaultfd.c~mm-generalize-handling-of-userfaults-in-__do_fault
+++ a/mm/userfaultfd.c
@@ -2046,6 +2046,15 @@ bool vma_can_userfault(struct vm_area_st
 	    !vma_is_anonymous(vma))
 		return false;
 
+	/*
+	 * File backed VMAs (except HugeTLB) must implement
+	 * ops->get_folio_noalloc() because it's required by __do_userfault()
+	 * in page fault handling.
+	 */
+	if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
+	    !ops->get_folio_noalloc)
+		return false;
+
 	return ops->can_userfault(vma, vm_flags);
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-generalize-handling-of-userfaults-in-__do_fault.patch

