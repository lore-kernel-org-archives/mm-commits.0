From: akpm@linux-foundation.org
Subject: - mm-fix-section-mismatch-warning-in-sparsec.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:36 -0800
Message-ID: <200802052232.m15MWHhU012296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762678AbYBEWoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: fix section mismatch warning in sparse.c
has been removed from the -mm tree.  Its filename was
     mm-fix-section-mismatch-warning-in-sparsec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix section mismatch warning in sparse.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: mm/built-in.o(.text+0x22069): Section mismatch in reference from the function sparse_early_usemap_alloc() to the function .init.text:__alloc_bootmem_node()

static sparse_early_usemap_alloc() were used only by sparse_init()
and with sparse_init() annotated _init it is safe to
annotate sparse_early_usemap_alloc with __init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-fix-section-mismatch-warning-in-sparsec mm/sparse.c
--- a/mm/sparse.c~mm-fix-section-mismatch-warning-in-sparsec
+++ a/mm/sparse.c
@@ -237,7 +237,7 @@ static unsigned long *__kmalloc_section_
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
 	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
linux-kernel-markers-create-modpost-file.patch
avoid-overflows-in-kernel-timec.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
