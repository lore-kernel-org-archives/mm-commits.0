Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDD41F4606
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485456; cv=none; b=uizWjMiJYGvWs4GCW9Fb8GpAA5PpiNErNXeZVrQKAreg4lTTqvJjLE4XSiLhbSMg37ndF0ojZAyIVhIVr7E1pEQzUxAZTNnf9UJhgvJ4/pRgdO1akZqova+H53EBBmL7ygNxLFegp/IznKx83XRWUD75v7ndd7tUoWst0SymQag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485456; c=relaxed/simple;
	bh=cuXiOy5U0z9OhxTuxkxa8asrEWa7gyA0DsNpLTeYarg=;
	h=Date:To:From:Subject:Message-Id; b=KTJpCIMrc8vG7mqkwr0hJewWM4kKhPGKUywc/8hQFhuRXBoVp/KlD+nF9e8EyX6pDLQUb2TeNifvLL/+GzRDT9Ip2W7bxu2xIWJiz7+uLvvQLQWj7Hbj1AXd/0UFuxB4gFfUNB/lRQ6Mqf/6HqJ0olWE7lNa7CIQ9r/MEaZOSIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOp6/2CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOp6/2CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8E0C4CEE7;
	Fri, 25 Jul 2025 23:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753485455;
	bh=cuXiOy5U0z9OhxTuxkxa8asrEWa7gyA0DsNpLTeYarg=;
	h=Date:To:From:Subject:From;
	b=QOp6/2CREX5jMbV4Y83KkxjrUPzaRUW7s7qBehJ/ZzvoBymcTTelS5zUnNqe4lFgm
	 S4JEcIkTqHxp7rB6C1rYmziy66kw9yNRPx732TBWvKII+twiTsywki2anUuLVmdn7A
	 BdUIzd7O/FoeV+WAAgehGCZ09b5a5db83lWyCYjs=
Date: Fri, 25 Jul 2025 16:17:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mm-io-mappingc.patch added to mm-new branch
Message-Id: <20250725231735.0E8E0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove mm/io-mapping.c
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-mm-io-mappingc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mm-io-mappingc.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove mm/io-mapping.c
Date: Fri, 25 Jul 2025 15:29:01 +0100

This is dead code, which was used from commit b739f125e4eb ("i915: use
io_mapping_map_user") but reverted a month later by commit 0e4fe0c9f2f9
("Revert "i915: use io_mapping_map_user"") back in 2021.

Since then nobody has used it, so remove it.

Link: https://lkml.kernel.org/r/20250725142901.81502-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    3 ---
 mm/Kconfig                 |    4 ----
 mm/Makefile                |    1 -
 mm/io-mapping.c            |   30 ------------------------------
 4 files changed, 38 deletions(-)

--- a/include/linux/io-mapping.h~mm-remove-mm-io-mappingc
+++ a/include/linux/io-mapping.h
@@ -225,7 +225,4 @@ io_mapping_free(struct io_mapping *iomap
 	kfree(iomap);
 }
 
-int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, unsigned long size);
-
 #endif /* _LINUX_IO_MAPPING_H */
diff --git a/mm/io-mapping.c a/mm/io-mapping.c
deleted file mode 100644
--- a/mm/io-mapping.c
+++ /dev/null
@@ -1,30 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-
-#include <linux/mm.h>
-#include <linux/io-mapping.h>
-
-/**
- * io_mapping_map_user - remap an I/O mapping to userspace
- * @iomap: the source io_mapping
- * @vma: user vma to map to
- * @addr: target user address to start at
- * @pfn: physical address of kernel memory
- * @size: size of map area
- *
- *  Note: this is only safe if the mm semaphore is held when called.
- */
-int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, unsigned long size)
-{
-	vm_flags_t expected_flags = VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
-
-	if (WARN_ON_ONCE((vma->vm_flags & expected_flags) != expected_flags))
-		return -EINVAL;
-
-	pgprot_t remap_prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
-				       (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
-
-	/* We rely on prevalidation of the io-mapping to skip pfnmap tracking. */
-	return remap_pfn_range_notrack(vma, addr, pfn, size, remap_prot);
-}
-EXPORT_SYMBOL_GPL(io_mapping_map_user);
--- a/mm/Kconfig~mm-remove-mm-io-mappingc
+++ a/mm/Kconfig
@@ -1242,10 +1242,6 @@ config KMAP_LOCAL
 config KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 	bool
 
-# struct io_mapping based helper.  Selected by drivers that need them
-config IO_MAPPING
-	bool
-
 config MEMFD_CREATE
 	bool "Enable memfd_create() system call" if EXPERT
 
--- a/mm/Makefile~mm-remove-mm-io-mappingc
+++ a/mm/Makefile
@@ -141,7 +141,6 @@ obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
-obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-remove-mm-io-mappingc.patch

