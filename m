Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CF299A84
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899243; cv=none; b=jFyFA3whUrbftNtsCK/XzisKXqdz16Ccn449zEFevIObQEEcYrI3iomiImBtD10cXmLhCEopq4jjYEVSVPdQdVZj09pfoJeucwNFx7rx4JYGO9WFY7G2PcQ0SYnuB0q0Jz0ENwVlQk4kPkUS5XhjoIqPkX/BIs+ocoyfiuOveFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899243; c=relaxed/simple;
	bh=HfTjPpQz4E0IE2x7ZTpVuqanJsgicEAgCLzxNP/+yl8=;
	h=Date:To:From:Subject:Message-Id; b=Iy89g6tlNTyC9xhe3oQxQrwCCJ5xDGIAXBTgNv+ioUVNnVbP/I6R8Er2z5nf0czXWPWzynZmCGTsLi5auouGgWmBntdjrPbJZ6dEf2Ou58EaX8G06E83DLMFczDf8HDJbgX6oZ1U8kyX3uFhna3Q6mPtZuQUE464+Yx++hFcXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtxgZgYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtxgZgYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59EC2BCB2;
	Mon, 30 Mar 2026 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899242;
	bh=HfTjPpQz4E0IE2x7ZTpVuqanJsgicEAgCLzxNP/+yl8=;
	h=Date:To:From:Subject:From;
	b=RtxgZgYvUpglCQGbMd1luQZNb5/rs+oCnOWZTZNBwEhoCQd7BFAUQi03+oAwyM0+i
	 IEBFbk0tTYj73w7dUJu/0xMwYJuLERMBcIcoKv3L4jp+Ydwdrjkk2n3ujwHm0p6nRT
	 4FVZzLjaqKP/7Z3cc9XVvlWW5pNfobi8HcJ0yxNE=
Date: Mon, 30 Mar 2026 12:34:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-move-vma_can_userfault-out-of-line.patch removed from -mm tree
Message-Id: <20260330193402.BF59EC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: move vma_can_userfault out of line
has been removed from the -mm tree.  Its filename was
     userfaultfd-move-vma_can_userfault-out-of-line.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: move vma_can_userfault out of line
Date: Fri, 6 Mar 2026 19:18:06 +0200

vma_can_userfault() has grown pretty big and it's not called on
performance critical path.

Move it out of line.

No functional changes.

Link: https://lkml.kernel.org/r/20260306171815.3160826-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |   35 +-------------------------------
 mm/userfaultfd.c              |   33 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 33 deletions(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-move-vma_can_userfault-out-of-line
+++ a/include/linux/userfaultfd_k.h
@@ -211,39 +211,8 @@ static inline bool userfaultfd_armed(str
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
-{
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
-}
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async);
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
--- a/mm/userfaultfd.c~userfaultfd-move-vma_can_userfault-out-of-line
+++ a/mm/userfaultfd.c
@@ -2018,6 +2018,39 @@ out:
 	return moved ? moved : err;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
+
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
+		return false;
+
+	/* By default, allow any of anon|shmem|hugetlb */
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	    vma_is_shmem(vma);
+}
+
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 				     vm_flags_t vm_flags)
 {
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

