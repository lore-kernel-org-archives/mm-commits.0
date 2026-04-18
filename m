Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898536F437
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499035; cv=none; b=qXJHN671vjDK8ZlENVtXCIeyD+ecSjgXDu9hGJjmd2U3GNEsuaKdF/cG6FDgZKP887t8cpkzVhfSzS1MALE7lUVhDLI9kx7ihMZUmzU4+hAne8UlCVHMgaiXTaMRPNMBGDJZf3aJWGYtjlpQhbBDLhD/38f8uUkQP7bLf88AaJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499035; c=relaxed/simple;
	bh=hFeuMzP4UZG8Dh8AdTwlNSjr0qVYw5xiQM0fkeCGyr8=;
	h=Date:To:From:Subject:Message-Id; b=RKGhZ5vlifW+/oS2cUvoUYLGJ15lrYUkKZIs1GN97IgAH1CnP/BD72H889bq1GOnkVcVnC/FPQUnPM8bqAsT3tt85jbkcBQ1MBIIRUQnXKJexUg+uYDSh1seY+X6fYW80X6RY9hiKSxLKOjzwwbNlZvOYw7qPrCZxtm8DaUWZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mCyMDPrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mCyMDPrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C6BC19424;
	Sat, 18 Apr 2026 07:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499035;
	bh=hFeuMzP4UZG8Dh8AdTwlNSjr0qVYw5xiQM0fkeCGyr8=;
	h=Date:To:From:Subject:From;
	b=mCyMDPrPN8fPsCv8XLHmz1NEkRI+9qOe75q4S3xalfxZhJv/4uJGHgGv0N1lJixhp
	 V0JDr0wIz44E6vMHWDEudW8vfkBz8eksMMu5FrVCxFwS9rsUwAJROTJxWkAnQLvbAj
	 w3IetL1QTUmh2grMeZ+dP4rFhVkkOtoM4dzKCP9Q=
Date: Sat, 18 Apr 2026 00:57:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tz2294@columbia.edu,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-introduce-vm_uffd_ops.patch removed from -mm tree
Message-Id: <20260418075714.53C6BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: introduce vm_uffd_ops
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-vm_uffd_ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: introduce vm_uffd_ops
Date: Thu, 2 Apr 2026 07:11:48 +0300

Current userfaultfd implementation works only with memory managed by core
MM: anonymous, shmem and hugetlb.

First, there is no fundamental reason to limit userfaultfd support only to
the core memory types and userfaults can be handled similarly to regular
page faults provided a VMA owner implements appropriate callbacks.

Second, historically various code paths were conditioned on
vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
these conditions can be expressed as operations implemented by a
particular memory type.

Introduce vm_uffd_ops extension to vm_operations_struct that will delegate
memory type specific operations to a VMA owner.

Operations for anonymous memory are handled internally in userfaultfd
using anon_uffd_ops that implicitly assigned to anonymous VMAs.

Start with a single operation, ->can_userfault() that will verify that a
VMA meets requirements for userfaultfd support at registration time.

Implement that method for anonymous, shmem and hugetlb and move relevant
parts of vma_can_userfault() into the new callbacks.

[rppt@kernel.org: relocate VM_DROPPABLE test, per Tal]
  Link: https://lore.kernel.org/adffgfM5ANxtPIEF@kernel.org
Link: https://lore.kernel.org/20260402041156.1377214-8-rppt@kernel.org
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
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Carlier <devnexen@gmail.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h            |    5 ++++
 include/linux/userfaultfd_k.h |    6 +++++
 mm/hugetlb.c                  |   15 ++++++++++++
 mm/shmem.c                    |   15 ++++++++++++
 mm/userfaultfd.c              |   38 +++++++++++++++++++++++---------
 5 files changed, 69 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~userfaultfd-introduce-vm_uffd_ops
+++ a/include/linux/mm.h
@@ -758,6 +758,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -865,6 +867,9 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	const struct vm_uffd_ops *uffd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/include/linux/userfaultfd_k.h~userfaultfd-introduce-vm_uffd_ops
+++ a/include/linux/userfaultfd_k.h
@@ -83,6 +83,12 @@ struct userfaultfd_ctx {
 
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/* Checks if a VMA can support userfaultfd */
+	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+};
+
 /* A combined operation mode + behavior flags. */
 typedef unsigned int __bitwise uffd_flags_t;
 
--- a/mm/hugetlb.c~userfaultfd-introduce-vm_uffd_ops
+++ a/mm/hugetlb.c
@@ -4792,6 +4792,18 @@ static vm_fault_t hugetlb_vm_op_fault(st
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static bool hugetlb_can_userfault(struct vm_area_struct *vma,
+				  vm_flags_t vm_flags)
+{
+	return true;
+}
+
+static const struct vm_uffd_ops hugetlb_uffd_ops = {
+	.can_userfault = hugetlb_can_userfault,
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -4805,6 +4817,9 @@ const struct vm_operations_struct hugetl
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
--- a/mm/shmem.c~userfaultfd-introduce-vm_uffd_ops
+++ a/mm/shmem.c
@@ -3288,6 +3288,15 @@ out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	return true;
+}
+
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.can_userfault	= shmem_can_userfault,
+};
 #endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
@@ -5307,6 +5316,9 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5316,6 +5328,9 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
--- a/mm/userfaultfd.c~userfaultfd-introduce-vm_uffd_ops
+++ a/mm/userfaultfd.c
@@ -34,6 +34,25 @@ struct mfill_state {
 	pmd_t *pmd;
 };
 
+static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	/* anonymous memory does not support MINOR mode */
+	if (vm_flags & VM_UFFD_MINOR)
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops anon_uffd_ops = {
+	.can_userfault	= anon_can_userfault,
+};
+
+static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return &anon_uffd_ops;
+	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -2021,34 +2040,33 @@ out:
 bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
 	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
+	vm_flags &= __VM_UFFD_FLAGS;
 
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
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
+	 * uffd-wp, then only anonymous memory is supported
 	 */
 	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
 	    !vma_is_anonymous(vma))
 		return false;
 
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	return ops->can_userfault(vma, vm_flags);
 }
 
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from rppt@kernel.org are


