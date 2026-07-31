Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E62CCB9
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521183; cv=none; b=ZBt+eqANT/DoNY5VKOJwTLFZRcMjXCi0BR5YfMx6hDdT/2C025tg6PMEnU6W9TPwBNtxbki/BmeOUHXln42Axa1JOHfAsNk2irYBb9MQPhzF7hWTliW3Ytp8O26AReca/0WpRsrTxzXVdiUo59sRCpSHXMiyFwGKZOy+6eV+eZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521183; c=relaxed/simple;
	bh=5kkvdCkBB4z8VxUPFMbLflMhYj/yNLoQO9mOqQCBxuU=;
	h=Date:To:From:Subject:Message-Id; b=omTVJ9vU04d4FhEYBsjlOXbs9lYenW7Hr92zOIzDn6Jwl5IyzHD/HbKMy0QzEzq+I67UpsIry2VL36+8NTeT/P7AW3PvruVNR6CMsKuGYcR+pJ21uUXb0Pb98P/6nh3eOp9gRrackS2pXto0rk9/m1thaqpYrVbUrFXmVqCSWnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Xpz3IYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Xpz3IYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6E61F00AC4;
	Fri, 31 Jul 2026 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521179;
	bh=EwyE9w5mrOJtvdeAxc6D7k55YWN5MwvSbBwejXc/Wt0=;
	h=Date:To:From:Subject;
	b=2Xpz3IYdkqRILx3l7+rV27shzHhQ2VhWuguQggz2baMgkpDhXHXa4/PQFgSwWJVij
	 yrdsPrOMspvQ7FIM4nQxXRcCLtFDfojWHWCA1SY/Ew1iaXowwBL2iDoZnjGKOBVDrz
	 gzfr4xQ+yKwlof4zVGJGGBejVLVME9UcB6ENCWe4=
Date: Fri, 31 Jul 2026 11:06:18 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-remove-numac.patch added to mm-new branch
Message-Id: <20260731180618.EF6E61F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: mm: remove numa.c
has been added to the -mm mm-new branch.  Its filename is
     sh-mm-remove-numac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-remove-numac.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: sh: mm: remove numa.c
Date: Sun, 10 May 2026 16:55:38 +0300

Since CONFIG_NUMA is removed, numa.c won't be ever compiled.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/Makefile |    1 
 arch/sh/mm/numa.c   |   53 ------------------------------------------
 2 files changed, 54 deletions(-)

--- a/arch/sh/mm/Makefile~sh-mm-remove-numac
+++ a/arch/sh/mm/Makefile
@@ -37,7 +37,6 @@ endif
 obj-$(CONFIG_DEBUG_FS)		+= $(debugfs-y)
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PMB)		+= pmb.o
-obj-$(CONFIG_NUMA)		+= numa.o
 obj-$(CONFIG_IOREMAP_FIXED)	+= ioremap_fixed.o
 obj-$(CONFIG_UNCACHED_MAPPING)	+= uncached.o
 obj-$(CONFIG_HAVE_SRAM_POOL)	+= sram.o
diff --git a/arch/sh/mm/numa.c a/arch/sh/mm/numa.c
deleted file mode 100644
--- a/arch/sh/mm/numa.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * arch/sh/mm/numa.c - Multiple node support for SH machines
- *
- *  Copyright (C) 2007  Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#include <linux/module.h>
-#include <linux/memblock.h>
-#include <linux/mm.h>
-#include <linux/numa.h>
-#include <linux/pfn.h>
-#include <asm/sections.h>
-
-/*
- * On SH machines the conventional approach is to stash system RAM
- * in node 0, and other memory blocks in to node 1 and up, ordered by
- * latency. Each node's pgdat is node-local at the beginning of the node,
- * immediately followed by the node mem map.
- */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-	unsigned long start_pfn, end_pfn;
-
-	/* Don't allow bogus node assignment */
-	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = PFN_DOWN(end);
-
-	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
-			 PAGE_KERNEL);
-
-	memblock_add(start, end - start);
-
-	__add_active_range(nid, start_pfn, end_pfn);
-
-	/* Node-local pgdat */
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid))
-		panic("%s: Failed to allocate %zu bytes align=0x%x nid=%d\n",
-		      __func__, sizeof(struct pglist_data), SMP_CACHE_BYTES,
-		      nid);
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-
-	/* It's up */
-	node_set_online(nid);
-}
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

