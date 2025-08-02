Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72E11E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160861; cv=none; b=Df3fnYj662Mc9SDAHVVbVPyy4XmdWfNLeUwgpJun3gdWCfBJOqOI8YlVCBpx7w9yOpx+Ju6tjZOUCKYMoEQAmEA0xWORZ9CqTvBgB9BWDHLxHxq2KIdiNnvG0uinwA8OVPKyvY9+5QvytgmzegGhql/696xIe6qdTcn7IBy5wPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160861; c=relaxed/simple;
	bh=3idsfsu21gDtdOWPXU9cX4z+krrZ23iTMhm4VTqaOMI=;
	h=Date:To:From:Subject:Message-Id; b=oTdKo1BmkDwvtGrudkUnzgI9cv3zMzLtp0f+vJWhKHheVlIELtcCHonkBxKsTXoL3PILpzLFUMLUQ/cPW5NIuIk8Y5GHuu5hff+XDXBm29aWMM+uAZIdlJvuyUB+RP73MEpOaY9cZ+tQAPKxAV/1mAPQZ94I1Lrq7KxnaaXV+n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lpYvfKPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lpYvfKPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618D2C4CEEF;
	Sat,  2 Aug 2025 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160861;
	bh=3idsfsu21gDtdOWPXU9cX4z+krrZ23iTMhm4VTqaOMI=;
	h=Date:To:From:Subject:From;
	b=lpYvfKPbzopNVtAxgKxdElGCjOLsKwFKumgdoeMJJoi01MY2BUsE7CH5oh1W12KgL
	 Mik/emD/nw1wdFWBEO1JCboeK/TzvtGIwYMmVyQmDvXaFGCmq6cgj7XnsEZ4gkeX5r
	 MTDn3HsM55i0pi2wbZWOCw4T+WZPQMDVSXUo6GcY=
Date: Sat, 02 Aug 2025 11:54:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-mm-io-mappingc.patch removed from -mm tree
Message-Id: <20250802185421.618D2C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove mm/io-mapping.c
has been removed from the -mm tree.  Its filename was
     mm-remove-mm-io-mappingc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove mm/io-mapping.c
Date: Fri, 25 Jul 2025 15:29:01 +0100

This is dead code, which was used from commit b739f125e4eb ("i915: use
io_mapping_map_user") but reverted a month later by commit 0e4fe0c9f2f9
("Revert "i915: use io_mapping_map_user"") back in 2021.

Since then nobody has used it, so remove it.

[akpm@linux-foundation.org: update Documentation/core-api/mm-api.rst, per Vlastimil]
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

 Documentation/core-api/mm-api.rst |    1 
 include/linux/io-mapping.h        |    3 --
 mm/Kconfig                        |    4 ---
 mm/Makefile                       |    1 
 mm/io-mapping.c                   |   30 ----------------------------
 5 files changed, 39 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-remove-mm-io-mappingc
+++ a/Documentation/core-api/mm-api.rst
@@ -139,4 +139,3 @@ More Memory Management Functions
 .. kernel-doc:: mm/mmu_notifier.c
 .. kernel-doc:: mm/balloon_compaction.c
 .. kernel-doc:: mm/huge_memory.c
-.. kernel-doc:: mm/io-mapping.c
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


