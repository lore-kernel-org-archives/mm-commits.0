Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592937E31D
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899851; cv=none; b=fM2OcJoqmXfrbXGhPlxUldiuXzxZXmvxTGGdsVH0JNfjlpRSIrNjwVaGeDIhh0Z6aoE7L/crItVf1VA6qx9FRsxsO94sutA3AB+6ynREZ5n8LQ5alTfOk/G8evYYUfnAZcc4o9ZsWAs+RNUFYHYUCBiRqypOQFGsH9OVbZvHKpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899851; c=relaxed/simple;
	bh=tIaPucMdUvJ1Z7x/GUcLoI0yvq6Ac5lyV5f25uXcgBA=;
	h=Date:To:From:Subject:Message-Id; b=O7rvaL/JsAtZr261ImVtgCC5m/Hz3HPeu0OdmGc8T10DNXVZJpm9b9+8wHwhUjLB9PP6ch2FMJ8akMMlbQZAVGYp5sExPWqgE3YP/P3BfQURQ1lAgVbVXSG03o82QYSVtndQp+28gH3kdeixlCBFk4q5oVNn4+/iK4Ey0Qna9OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijB4BAd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijB4BAd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F46C4CEF7;
	Mon, 30 Mar 2026 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899851;
	bh=tIaPucMdUvJ1Z7x/GUcLoI0yvq6Ac5lyV5f25uXcgBA=;
	h=Date:To:From:Subject:From;
	b=ijB4BAd4ZVUvzqYI8INLQB+wKvR7dDVveM9dVfCI4KabkD+o+SHNtpO2phYnF7xAl
	 2vRt1iPy0WH9rGAHlc7RFXZlywnYK3P/l6/n54dcoTFSGPlqDEGeW9b06qPbMmROfd
	 8cI5U09Vh43XP2+/d7M5DHPPmYSlvKwIo58uA2/c=
Date: Mon, 30 Mar 2026 12:44:10 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generalize-handling-of-userfaults-in-__do_fault.patch added to mm-unstable branch
Message-Id: <20260330194411.74F46C4CEF7@smtp.kernel.org>
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

mm-generalize-handling-of-userfaults-in-__do_fault.patch

