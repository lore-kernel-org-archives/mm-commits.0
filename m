Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B1A171A1
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745443916; cv=none; b=pyLawQDNiIsF+7PMBBbXT63pF3y4ZvyMbFHJ0Vrk1WsGIATlnjB6kdqNrPIqJg0U0jU+D0OnjYHuWF/nawB7s4KVgGZTpfRTJziF/W2fScI74ac2HOcI4aKPO6d2TeK0UEdmztzrKhi1NGPh3tHi3g+BBQdU5xk/uJq4BkGE5GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745443916; c=relaxed/simple;
	bh=J0n1ukLrFi9JUwysM8MZZEfPStR42N6V9B4rXe88zfk=;
	h=Date:To:From:Subject:Message-Id; b=Q4hn379UbFfqGhV9Wd1LrQJKo1wyVa6KTBumDMEL9o93ZzhT2KnT9UViisUUiIoGPMQWs5iWn05bcVJFlZrTy9CiZXhmuQjMKkojf6uxerF/fQ9URc6TgOjCZ/O1lLcyPvJtLfUAi3Eze/ZvEYXjeM3RHQjsS4K7Pn0oflUw8cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmHvysE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmHvysE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B845C4CEE2;
	Wed, 23 Apr 2025 21:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745443915;
	bh=J0n1ukLrFi9JUwysM8MZZEfPStR42N6V9B4rXe88zfk=;
	h=Date:To:From:Subject:From;
	b=UmHvysE+6ZQ70UwtLyq+SYSndBOn4M/b0Off7E2W956klxgc4doNfwqYz6JZXu4bK
	 fRkLbRqdPBOmbV9pyvGOuw5qsTtbtcVfXFUKI+Xe0FD9YZT4/1xNyyRXMOq1P7jSql
	 WfAuxM/59ZCIP5y0rDE5mrvjMG8Q2JujPwAxrxmc=
Date: Wed, 23 Apr 2025 14:31:54 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-introduce-memmap_init_kho_scratch-fix.patch added to mm-unstable branch
Message-Id: <20250423213155.7B845C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: mark init_deferred_page as __init_memblock
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-introduce-memmap_init_kho_scratch-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-introduce-memmap_init_kho_scratch-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: memblock: mark init_deferred_page as __init_memblock
Date: Wed, 23 Apr 2025 18:08:08 +0200

On architectures that set CONFIG_ARCH_KEEP_MEMBLOCK,
memmap_init_kho_scratch_pages is not discarded but calls a function that
is:

WARNING: modpost: vmlinux: section mismatch in reference: memmap_init_kho_scratch_pages+0x120 (section: .text) -> init_deferred_page (section: .init.text)
ERROR: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.

Mark init_deferred_page the same way as memmap_init_kho_scratch_pages to
avoid that warning.  Unfortunately this requires marking additional
functions the same way to have them stay around as well.

Ideally memmap_init_kho_scratch_pages would become __meminit instead of
__init_memblock, but I could not convince myself that this is safe.

Link: https://lkml.kernel.org/r/20250423160824.1498493-1-arnd@kernel.org
Fixes: 1b7936623970 ("memblock: introduce memmap_init_kho_scratch()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 ++++---
 mm/mm_init.c  |    8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/mm/internal.h~memblock-introduce-memmap_init_kho_scratch-fix
+++ a/mm/internal.h
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/pagemap.h>
@@ -543,7 +544,7 @@ extern int defrag_mode;
 
 void setup_per_zone_wmarks(void);
 void calculate_min_free_kbytes(void);
-int __meminit init_per_zone_wmark_min(void);
+int __init_memblock init_per_zone_wmark_min(void);
 void page_alloc_sysctl_init(void);
 
 /*
@@ -1532,9 +1533,9 @@ static inline bool pte_needs_soft_dirty_
 	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+void __init_memblock __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
+void __init_memblock __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~memblock-introduce-memmap_init_kho_scratch-fix
+++ a/mm/mm_init.c
@@ -577,7 +577,7 @@ out:
 	node_states[N_MEMORY] = saved_node_state;
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+void __init_memblock __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
 	mm_zero_struct_page(page);
@@ -668,7 +668,7 @@ static inline void fixup_hashdist(void)
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
+void __init_memblock __init_page_from_nid(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
 	int zid;
@@ -743,7 +743,7 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit __init_deferred_page(unsigned long pfn, int nid)
+static void __init_memblock __init_deferred_page(unsigned long pfn, int nid)
 {
 	if (early_page_initialised(pfn, nid))
 		return;
@@ -768,7 +768,7 @@ static inline void __init_deferred_page(
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
-void __meminit init_deferred_page(unsigned long pfn, int nid)
+void __init_memblock init_deferred_page(unsigned long pfn, int nid)
 {
 	__init_deferred_page(pfn, nid);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

memblock-introduce-memmap_init_kho_scratch-fix.patch
x86-add-kho-support-fix.patch

