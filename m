Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE036CE02
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103827; cv=none; b=gDETyKx1+8MKzqGrxXlRaotNcuX5N3YRSiLqBzAul0oc8Cs47PXnanRamyDm5s76D1yWzvauno/5y0K+/REPdEZQRLhRE2zYrLlSwCyhj+Piz4oF4X8tSvq0UR1PgSdv/CkQECAWTCXwAo+gQfuPv2rsftWi9T4Bn+/wEhno8Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103827; c=relaxed/simple;
	bh=NJPGh9R+9WubpeZQxpHKsxmliWU/1bekLwRrN2iS5qg=;
	h=Date:To:From:Subject:Message-Id; b=sCNSeQpHxgFcavX6uO3tJdrAATh+1pjb9renIDwTP6ubx9GbFukluN00QQGWI8D4GKTaRPTHow5L54WNLPXMnnsxaCwoz2gGnc/exHG605+WbdN6VjUJgUboGOJlLeWAFlkoO8cFU/vM9A5U8Y1DseBBZgF25DNL3ZmEJ8n/4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ymRjQ6Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ymRjQ6Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61287C19423;
	Thu,  2 Apr 2026 04:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103826;
	bh=NJPGh9R+9WubpeZQxpHKsxmliWU/1bekLwRrN2iS5qg=;
	h=Date:To:From:Subject:From;
	b=ymRjQ6BrZDV9p+yBQWoybYEpFnSRmGEH+YpvPPN24utLL2T951ywKOCz6Ug2SePBj
	 HakvbDo4AK7smJW9jzKTiRoS7ypb9/anfw+vVxCdhGaMdB4rArMbvQp/b/IvQM+Fo+
	 G7tEM9DUpTbwC09lyADzvTGZzaTQWH6ZtZRc8tms=
Date: Wed, 01 Apr 2026 21:23:45 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-generalize-handling-of-userfaults-in-__do_fault.patch removed from -mm tree
Message-Id: <20260402042346.61287C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: generalize handling of userfaults in __do_fault()
has been removed from the -mm tree.  Its filename was
     mm-generalize-handling-of-userfaults-in-__do_fault.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: generalize handling of userfaults in __do_fault()
Date: Mon, 30 Mar 2026 13:11:13 +0300

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

Link: https://lkml.kernel.org/r/20260330101116.1117699-13-rppt@kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
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


