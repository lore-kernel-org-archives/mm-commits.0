Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC5362138
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775104630; cv=none; b=WwhotjZLY0iFBDZ2veZEzEiWfdtnWshMsF74Rojy92d9PVcjrIMeEY3n9wYLf+IJyp8Xo6kOYlW88WYxniqMh58lH6TQ9nbgUIAsndtunFTsMctMEF2oT3gMY0c6fuuU4/XwR+lTh4o30cOTSds/rxTw1VY4J3+xt/JqKXqWcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775104630; c=relaxed/simple;
	bh=SuQDYggiz+akn5wIECaqO1PGq19ZD5vLNc7C4QCFqDo=;
	h=Date:To:From:Subject:Message-Id; b=tCliFcrxz+5jpZvUMd2nxDjxC8SutAahbidxdoFC/2KZHdt0N99hv19k9QbPJBGvRR0dB5K165wzAzo3PHSJeqkR3hNwx8RS84y74dw2UvpJ/hpWVc00AZdEYptyEK0hUQNBv/njKGZmzyDjt1swJoUFCLmxDu7+buaUCrlN80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z++oVa5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z++oVa5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFBFC19423;
	Thu,  2 Apr 2026 04:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775104630;
	bh=SuQDYggiz+akn5wIECaqO1PGq19ZD5vLNc7C4QCFqDo=;
	h=Date:To:From:Subject:From;
	b=z++oVa5KTJLikMUONx6G/RkwLsA0QHYgsanCT/YekTyuEyjtYt5t4l1k6qtSVsA3F
	 OVskAFScs9GGVgN/927StQ/OkKazpXv3vaTJGylbvGggXKVCSTa4+zQReJ6YshIv6e
	 ypdb9eg8cO39283k/pvClQ2FJV59G3o9fZSIBRvM=
Date: Wed, 01 Apr 2026 21:37:10 -0700
To: mm-commits@vger.kernel.org,kalyazin@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-guest_memfd-implement-userfaultfd-operations.patch added to mm-unstable branch
Message-Id: <20260402043710.8BFBFC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: guest_memfd: implement userfaultfd operations
has been added to the -mm mm-unstable branch.  Its filename is
     kvm-guest_memfd-implement-userfaultfd-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-guest_memfd-implement-userfaultfd-operations.patch

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
From: Nikita Kalyazin <kalyazin@amazon.com>
Subject: KVM: guest_memfd: implement userfaultfd operations
Date: Thu, 2 Apr 2026 07:11:54 +0300

userfaultfd notifications about page faults used for live migration and
snapshotting of VMs.

MISSING mode allows post-copy live migration and MINOR mode allows
optimization for post-copy live migration for VMs backed with shared
hugetlbfs or tmpfs mappings as described in detail in commit 7677f7fd8be7
("userfaultfd: add minor fault registration mode").

To use the same mechanisms for VMs that use guest_memfd to map their
memory, guest_memfd should support userfaultfd operations.

Add implementation of vm_uffd_ops to guest_memfd.

Link: https://lkml.kernel.org/r/20260402041156.1377214-14-rppt@kernel.org
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c           |    1 
 virt/kvm/guest_memfd.c |   84 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~kvm-guest_memfd-implement-userfaultfd-operations
+++ a/mm/filemap.c
@@ -262,6 +262,7 @@ void filemap_remove_folio(struct folio *
 
 	filemap_free_folio(mapping, folio);
 }
+EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
 
 /*
  * page_cache_delete_batch - delete several folios from page cache
--- a/virt/kvm/guest_memfd.c~kvm-guest_memfd-implement-userfaultfd-operations
+++ a/virt/kvm/guest_memfd.c
@@ -7,6 +7,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -107,6 +108,12 @@ static int kvm_gmem_prepare_folio(struct
 	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
+static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
+	return __filemap_get_folio(inode->i_mapping, pgoff,
+				   FGP_LOCK | FGP_ACCESSED, 0);
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -126,8 +133,7 @@ static struct folio *kvm_gmem_get_folio(
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = kvm_gmem_get_folio_noalloc(inode, index);
 	if (!IS_ERR(folio))
 		return folio;
 
@@ -457,12 +463,86 @@ static struct mempolicy *kvm_gmem_get_po
 }
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_USERFAULTFD
+static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+
+	/*
+	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
+	 * This ensures the memory can be mapped to userspace.
+	 */
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return false;
+
+	return true;
+}
+
+static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
+					  unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	struct mempolicy *mpol;
+	struct folio *folio;
+	gfp_t gfp;
+
+	if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
+		return NULL;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+	mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
+	mpol = mpol ?: get_task_policy(current);
+	folio = filemap_alloc_folio(gfp, 0, mpol);
+	mpol_cond_put(mpol);
+
+	return folio;
+}
+
+static int kvm_gmem_filemap_add(struct folio *folio,
+				struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	int err;
+
+	__folio_set_locked(folio);
+	err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
+	if (err) {
+		folio_unlock(folio);
+		return err;
+	}
+
+	return 0;
+}
+
+static void kvm_gmem_filemap_remove(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	filemap_remove_folio(folio);
+	folio_unlock(folio);
+}
+
+static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
+	.can_userfault     = kvm_gmem_can_userfault,
+	.get_folio_noalloc = kvm_gmem_get_folio_noalloc,
+	.alloc_folio       = kvm_gmem_folio_alloc,
+	.filemap_add       = kvm_gmem_filemap_add,
+	.filemap_remove    = kvm_gmem_filemap_remove,
+};
+#endif /* CONFIG_USERFAULTFD */
+
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
 	.fault		= kvm_gmem_fault_user_mapping,
 #ifdef CONFIG_NUMA
 	.get_policy	= kvm_gmem_get_policy,
 	.set_policy	= kvm_gmem_set_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &kvm_gmem_uffd_ops,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from kalyazin@amazon.com are

kvm-guest_memfd-implement-userfaultfd-operations.patch
kvm-selftests-test-userfaultfd-minor-for-guest_memfd.patch
kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

