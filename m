Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80F63803CC
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899251; cv=none; b=J5TYU1ykpn+CgMIAus7pFBzR05DT2KnavCw8AE3fEG6sBqCELnMalddgEWYY96rKXez8cysbDPACKgVZEGCn0C/sufe0zE25RZ3zLoDOsaiGdiOkM56nnEB6WaLoYu9eoTXdtzelv9cmlKorUBgfUWF7p3SOUY3QP0dfvsgtR/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899251; c=relaxed/simple;
	bh=0q/MmqobVzu1sQnpgTbZzaQxL5kr4dYxfbT2EIiHBxM=;
	h=Date:To:From:Subject:Message-Id; b=lcXdsu9tigNcz80NMvZwc7hdY/R8wvpF5filxrD8hQiTyUYwSsiSZsgf+upQSb2E8VPEbbGqhBs76m/L/5vgy9W/GF0dC1lAiT7fQsfEEl8t1kcc6V8ro8QxMG0yjZQlTRkEBlehZJYpZVJH0vr5Ei+sd4S2X+eSRnqc7f7upAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JB7Uorhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JB7Uorhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F58EC4CEF7;
	Mon, 30 Mar 2026 19:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899251;
	bh=0q/MmqobVzu1sQnpgTbZzaQxL5kr4dYxfbT2EIiHBxM=;
	h=Date:To:From:Subject:From;
	b=JB7UorhjBf8LGPdxsFpicDT9SdzkRL89sCrYh4hEG7oIrX7ljr1ek1h5kJbt5XZz+
	 LdaXpDPgu44ZX3ZsFyiUhEznfnM62sUMVuBjslgeqm/XNif5Jv6t32SMViSPQ5Qo94
	 ONqfb4CnJb/i969m5IbuKgK5YHh4JbeNn4PZZ73w=
Date: Mon, 30 Mar 2026 12:34:10 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-generalize-handling-of-userfaults-in-__do_fault.patch removed from -mm tree
Message-Id: <20260330193411.5F58EC4CEF7@smtp.kernel.org>
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
Date: Fri, 6 Mar 2026 19:18:12 +0200

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

Link: https://lkml.kernel.org/r/20260306171815.3160826-13-rppt@kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
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
 mm/userfaultfd.c |    8 ++++++++
 3 files changed, 51 insertions(+), 12 deletions(-)

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
+	 * If this is an userfaultfd trap, process it in advance before
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
@@ -2043,6 +2043,14 @@ bool vma_can_userfault(struct vm_area_st
 	    !vma_is_anonymous(vma))
 		return false;
 
+	/*
+	 * File backed memory with PTE level mappigns must implement
+	 * ops->get_folio_noalloc()
+	 */
+	if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
+	    !ops->get_folio_noalloc)
+		return false;
+
 	return ops->can_userfault(vma, vm_flags);
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are


