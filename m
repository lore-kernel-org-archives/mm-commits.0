Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A042F6586
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 19:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773257187; cv=none; b=kgzCM1xfI9oy9ylO8KJmJTCkk8vEnlX3BVej+OLLK+EFqKbw3jFzcavjeayNevwsPJDtU0euprYGU3LZIY8O4CDItSEMs0ocj3z7qZ467MdUzggrF/q541upEPJS3Jff/mntMvi+qu7uYU7zoBHBdSE9X6JaxpHFtvJ0FcrmddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773257187; c=relaxed/simple;
	bh=Ol5Sqr0aSwg2/2C91aSrgCTeCHbqNFnwfNvndKAgZZo=;
	h=Date:To:From:Subject:Message-Id; b=KhvZVi8xGHFU15P8eZ+owNPiFWJHqfuWb8bS1NUGyFac7iskWkO28FRMouQONgkD3tbNggVKussiKBKhw6WLurwyZRcN0BNGA6/SiUtzbSEDNaJa+50sgB7JwB+n8QZZMJSD4uW/I2xCsLKoEom9gBrYyK7CZEjhHTr3QWwLnuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PZOmLS61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PZOmLS61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE2EC4CEF7;
	Wed, 11 Mar 2026 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773257186;
	bh=Ol5Sqr0aSwg2/2C91aSrgCTeCHbqNFnwfNvndKAgZZo=;
	h=Date:To:From:Subject:From;
	b=PZOmLS61j9cs1ffFmobuCA7HCAKFvBb72sb6ei/RP6RsY39iqlp0zhNs+zTB2yj15
	 E0kO4wlnbuKxJx9L2CHJYIxwpjpDM47qVTNjzWT95u7ISrZhUwK2GYOh3eInXvQfGw
	 Qe5iFwlDUtiK+qvQ6pd9MxbBNY/R4lqFxXauUrys=
Date: Wed, 11 Mar 2026 12:26:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-introduce-vm_uffd_ops-fix.patch added to mm-unstable branch
Message-Id: <20260311192626.ABE2EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: allow registration of WP_ASYNC for any VMA
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-introduce-vm_uffd_ops-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-introduce-vm_uffd_ops-fix.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: allow registration of WP_ASYNC for any VMA
Date: Wed, 11 Mar 2026 20:21:38 +0200

Registration of a VMA with WP_ASYNC userfaulfd context in write-protect
mode does not require any VMA-specific resolution of user faults and these
faults are completely handled by the generic page fault handler.

This functionality existed since the introduction of WP_ASYNC mode and it
allows tracking writes to SysV shared memory mappings (shmget(2) and
shmat(2)).

Move the check for WP mode before checking for presence of ->uffd_ops in a
VMA to restore the original behaviour.

Link: https://lkml.kernel.org/r/abG5HFV8yoEHOFkh@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 mm/userfaultfd.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-vm_uffd_ops-fix
+++ a/mm/userfaultfd.c
@@ -2044,22 +2044,22 @@ bool vma_can_userfault(struct vm_area_st
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	/* only VMAs that implement vm_uffd_ops are supported */
-	if (!ops)
-		return false;
-
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
 	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * If WP is the only mode enabled and context is wp async, allow any
 	 * memory type.
 	 */
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
+	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
+	if (!ops)
+		return false;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch
mm-rename-my_zero_pfn-to-zero_pfn.patch
arch-mm-consolidate-empty_zero_page.patch
mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch
userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

