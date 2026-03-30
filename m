Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B615299A84
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899246; cv=none; b=YD2byVsJkB8lFqM7APz7UGC/dxSSioeGTYFTU2FeZdR3SJwvz5BnX917nNi0eI5zDx/XZnL2mQIb9ziHvj09q1joqmV+A9s23U2buie6HZhodLye32ZB+9bqzzYjs1/GDfA8YgReqT8L0G0BPfHBOm8XkXpr3dz/xV6sksKre1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899246; c=relaxed/simple;
	bh=HiEwZ11CcLIio56fXncN366LDdoJjGHegXkJYsclppQ=;
	h=Date:To:From:Subject:Message-Id; b=qmODHEhmiY6myYBqZZAsQjzJqaG0DTIWzDJuK3+eLduX/CoN4St4+OX4JkOIqmZK/vniRZs2U1yP6pYCP73z4qcqWKSt6jyj2vFFYlrxxy2YSKwCMGUUGrt9NjWcG7kGRapdWKdZUOtmt+SHdTl6kysvXRH9w1EAUBl0hispGIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3FfJVn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3FfJVn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6933C4CEF7;
	Mon, 30 Mar 2026 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899245;
	bh=HiEwZ11CcLIio56fXncN366LDdoJjGHegXkJYsclppQ=;
	h=Date:To:From:Subject:From;
	b=O3FfJVn+0qBXopxF5OTgOUWHXZL0rXabKJDBBaeBAl3JVtPfK5/lGx96qIRWGKIe3
	 eh9/uaVxCBsO3Ne9SODJxfuO+fYEJ6WfsCJggShLB5/pniZOlIWQdLN2b0r7IwbxQ0
	 acJRRBcbJYH6Lwb9Rdc/77xvpj7TTj2ONKsncnRs=
Date: Mon, 30 Mar 2026 12:34:05 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch removed from -mm tree
Message-Id: <20260330193405.A6933C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
has been removed from the -mm tree.  Its filename was
     shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
Date: Fri, 6 Mar 2026 19:18:08 +0200

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing that
VMA.

Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
method to 'struct vm_uffd_ops' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
this new API.

Link: https://lkml.kernel.org/r/20260306171815.3160826-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

 include/linux/userfaultfd_k.h |    7 +++++++
 mm/shmem.c                    |   15 ++++++++++++++-
 mm/userfaultfd.c              |   32 ++++++++++++++++----------------
 3 files changed, 37 insertions(+), 17 deletions(-)

--- a/include/linux/userfaultfd_k.h~shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue
+++ a/include/linux/userfaultfd_k.h
@@ -87,6 +87,13 @@ extern vm_fault_t handle_userfault(struc
 struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+	/*
+	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 };
 
 /* A combined operation mode + behavior flags. */
--- a/mm/shmem.c~shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue
+++ a/mm/shmem.c
@@ -3289,13 +3289,26 @@ out_unacct_blocks:
 	return ret;
 }
 
+static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
+	struct folio *folio;
+	int err;
+
+	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (err)
+		return ERR_PTR(err);
+
+	return folio;
+}
+
 static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 {
 	return true;
 }
 
 static const struct vm_uffd_ops shmem_uffd_ops = {
-	.can_userfault	= shmem_can_userfault,
+	.can_userfault		= shmem_can_userfault,
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
 };
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/userfaultfd.c~shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue
+++ a/mm/userfaultfd.c
@@ -191,6 +191,7 @@ static int mfill_get_vma(struct mfill_st
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -232,10 +233,12 @@ static int mfill_get_vma(struct mfill_st
 	if (is_vm_hugetlb_page(dst_vma))
 		return 0;
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+	ops = vma_uffd_ops(dst_vma);
+	if (!ops)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+	    !ops->get_folio_noalloc)
 		goto out_unlock;
 
 	return 0;
@@ -575,6 +578,7 @@ out:
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -584,16 +588,13 @@ static int mfill_atomic_pte_continue(str
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	folio = ops->get_folio_noalloc(inode, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
-	}
+	if (IS_ERR_OR_NULL(folio))
+		return -EFAULT;
 
 	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
@@ -607,13 +608,12 @@ static int mfill_atomic_pte_continue(str
 		goto out_release;
 
 	folio_unlock(folio);
-	ret = 0;
-out:
-	return ret;
+	return 0;
+
 out_release:
 	folio_unlock(folio);
 	folio_put(folio);
-	goto out;
+	return ret;
 }
 
 /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

