Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8562737F7
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059403; cv=none; b=MoMNMdk8ZoruYuHLSDzInzn9bHAcWqa3WsU9lzFYDvPd6x0T0dXlokfVDorjK+ljKpvqaU4SQS17s95xrL6pgV1gLLuxuw1o/jvTQC4UeI41wf27Xy5crv/wcrDZ+13T4QdstX3RWiZ6yazEkXn5w4bJikCs/cZxEkkiK/uGD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059403; c=relaxed/simple;
	bh=194T2gOB7KzhqliVNEuEpLyBHOZchoTNVv9quwLJFuE=;
	h=Date:To:From:Subject:Message-Id; b=krIfQ6P2uG5ZyyLnnBMwaqID68kjURevGJZjAfYGhuJl+K+CrP9mm6T0vtNX72zgrnZUqBHMt6OFLyw2hUwY5+Cg00WRPvIfSKfEf6IOWZ529HhqImfzcYFi4/IDMM1IcS8jw2P0fq/KXopZM8wtkYx/koj2UKXz+gizG/Fok/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGlZKXZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGlZKXZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE31C4CEE3;
	Fri, 27 Jun 2025 21:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059402;
	bh=194T2gOB7KzhqliVNEuEpLyBHOZchoTNVv9quwLJFuE=;
	h=Date:To:From:Subject:From;
	b=KGlZKXZmBIjsf2fDUkR58aRoGPpREqJOAik4f5XW3f+Fo5eA+uu04vpIePrKzAvK4
	 XGAaOhu93umxcPe/IcnNv7dwmqEpIssmMcNF8NhiWpNZeEnvXcigwy/u3yalTnBNZv
	 jNCEx/ckZrGrRQQB5vOC1Ia9dL/08SWUXzcpN2NE=
Date: Fri, 27 Jun 2025 14:23:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jthoughton@google.com,hughd@google.com,david@redhat.com,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vm_uffd_ops-api.patch added to mm-new branch
Message-Id: <20250627212322.BDE31C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vm_uffd_ops API
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-vm_uffd_ops-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vm_uffd_ops-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce vm_uffd_ops API
Date: Fri, 27 Jun 2025 11:46:52 -0400

Patch series "mm/userfaultfd: modulize memory types", v2.

This series is an alternative proposal of what Nikita proposed here on the
initial three patches:

  https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com

This is not yet relevant to any guest-memfd support, but paving way for
it.  Here, the major goal is to make kernel modules be able to opt-in with
any form of userfaultfd support, like guest-memfd.  This alternative
option should hopefully be cleaner, and avoid leaking userfault details
into vm_ops.fault().

It also means this series does not depend on anything.  It's a pure
refactoring of userfaultfd internals to provide a generic API, so that
other types of files, especially RAM based, can support userfaultfd
without touching mm/ at all.

To achieve it, this series introduced a file operation called vm_uffd_ops.
The ops needs to be provided when a file type supports any of
userfaultfd.

With that, I moved both hugetlbfs and shmem over.

Hugetlbfs is still very special that it will only use partial of the
vm_uffd_ops API, due to similar reason why hugetlb_vm_op_fault() has a
BUG() and so far hard-coded into core mm.  But this should still be
better, because at least hugetlbfs is still always involved in feature
probing (e.g.  where it used to not support ZEROPAGE and we have a
hard-coded line to fail that, and some more).  Meanwhile after this
series, shmem will be completely converted to the new vm_uffd_ops API; the
final vm_uffd_ops for shmem looks like this:

static const vm_uffd_ops shmem_uffd_ops = {
	.uffd_features	= 	__VM_UFFD_FLAGS,
	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
				BIT(_UFFDIO_ZEROPAGE) |
				BIT(_UFFDIO_WRITEPROTECT) |
				BIT(_UFFDIO_CONTINUE) |
				BIT(_UFFDIO_POISON),
	.uffd_get_folio	=	shmem_uffd_get_folio,
	.uffd_copy	=	shmem_mfill_atomic_pte,
};

As I mentioned in one of my replies to Nikita, I don't like the current
interface of uffd_copy(), but this will be the minimum change version of
such API to support complete extrenal-module-ready userfaultfd.  Here,
very minimal change will be needed from shmem side to support that.

Meanwhile, the vm_uffd_ops is also not the only place one will need to
provide to support userfaultfd.  Normally vm_ops.fault() will also need to
be updated, but that's a generic function and it'll play together with the
new vm_uffd_ops to make everything fly.

No functional change expected at all after the whole series applied. 
There might be some slightly stricter check on uffd ops here and there in
the last patch, but that really shouldn't stand out anywhere to anyone.

For testing: besides the cross-compilation tests, I did also try with
uffd-stress in a VM to measure any perf difference before/after the
change; The static call becomes a pointer now.  I really cannot measure
anything different, which is more or less expected.


This patch (of 4):

Introduce a generic userfaultfd API for vm_operations_struct, so that one
vma, especially when as a module, can support userfaults without modifying
the core files.  More importantly, when the module can be compiled out of
the kernel.

So, instead of having core mm referencing modules that may not ever exist,
we need to have modules opt-in on core mm hooks instead.

After this API applied, if a module wants to support userfaultfd, the
module should only need to touch its own file and properly define
vm_uffd_ops, instead of changing anything in core mm.

Note that such API will not work for anonymous.  Core mm will process
anonymous memory separately for userfault operations like before.

This patch only introduces the API alone so that we can start to move
existing users over but without breaking them.

Currently the uffd_copy() API is almost designed to be the simplistic with
minimum mm changes to move over to the API.

Link: https://lkml.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20250627154655.2085903-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h            |    9 +++++
 include/linux/userfaultfd_k.h |   52 ++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

--- a/include/linux/mm.h~mm-introduce-vm_uffd_ops-api
+++ a/include/linux/mm.h
@@ -576,6 +576,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -653,6 +655,13 @@ struct vm_operations_struct {
 	 */
 	struct page *(*find_special_page)(struct vm_area_struct *vma,
 					  unsigned long addr);
+#ifdef CONFIG_USERFAULTFD
+	/*
+	 * Userfaultfd related ops.  Modules need to define this to support
+	 * userfaultfd.
+	 */
+	const struct vm_uffd_ops *userfaultfd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/include/linux/userfaultfd_k.h~mm-introduce-vm_uffd_ops-api
+++ a/include/linux/userfaultfd_k.h
@@ -92,6 +92,58 @@ enum mfill_atomic_mode {
 	NR_MFILL_ATOMIC_MODES,
 };
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/**
+	 * @uffd_features: features supported in bitmask.
+	 *
+	 * When the ops is defined, the driver must set non-zero features
+	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
+	 */
+	unsigned long uffd_features;
+	/**
+	 * @uffd_ioctls: ioctls supported in bitmask.
+	 *
+	 * Userfaultfd ioctls supported by the module.  Below will always
+	 * be supported by default whenever a module provides vm_uffd_ops:
+	 *
+	 *   _UFFDIO_API, _UFFDIO_REGISTER, _UFFDIO_UNREGISTER, _UFFDIO_WAKE
+	 *
+	 * The module needs to provide all the rest optionally supported
+	 * ioctls.  For example, when VM_UFFD_MISSING was supported,
+	 * _UFFDIO_COPY must be supported as ioctl, while _UFFDIO_ZEROPAGE
+	 * is optional.
+	 */
+	unsigned long uffd_ioctls;
+	/**
+	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.
+	 *
+	 * @inode: the inode for folio lookup
+	 * @pgoff: the pgoff of the folio
+	 * @folio: returned folio pointer
+	 *
+	 * Return: zero if succeeded, negative for errors.
+	 */
+	int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
+			      struct folio **folio);
+	/**
+	 * uffd_copy: Handler to resolve UFFDIO_COPY|ZEROPAGE request.
+	 *
+	 * @dst_pmd: target pmd to resolve page fault
+	 * @dst_vma: target vma
+	 * @dst_addr: target virtual address
+	 * @src_addr: source address to copy from
+	 * @flags: userfaultfd request flags
+	 * @foliop: previously allocated folio
+	 *
+	 * Return: zero if succeeded, negative for errors.
+	 */
+	int (*uffd_copy)(pmd_t *dst_pmd, struct vm_area_struct *dst_vma,
+			 unsigned long dst_addr, unsigned long src_addr,
+			 uffd_flags_t flags, struct folio **foliop);
+};
+typedef struct vm_uffd_ops vm_uffd_ops;
+
 #define MFILL_ATOMIC_MODE_BITS (const_ilog2(NR_MFILL_ATOMIC_MODES - 1) + 1)
 #define MFILL_ATOMIC_BIT(nr) BIT(MFILL_ATOMIC_MODE_BITS + (nr))
 #define MFILL_ATOMIC_FLAG(nr) ((__force uffd_flags_t) MFILL_ATOMIC_BIT(nr))
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch
mm-introduce-vm_uffd_ops-api.patch
mm-shmem-support-vm_uffd_ops-api.patch
mm-hugetlb-support-vm_uffd_ops-api.patch
mm-apply-vm_uffd_ops-api-to-core-mm.patch

