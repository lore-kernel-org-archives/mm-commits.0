From: akpm@linux-foundation.org
Subject: [merged] sh-use-pfn_down-macro.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:56 -0700
Message-ID: <55ef2294.jDHxb0NG5bvrW1J+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbIHSB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: use PFN_DOWN macro
has been removed from the -mm tree.  Its filename was
     sh-use-pfn_down-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: sh: use PFN_DOWN macro

Replace ((x) >> PAGE_SHIFT) with the predefined PFN_DOWN macro.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |    4 ++--
 arch/sh/mm/numa.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sh/mm/init.c~sh-use-pfn_down-macro arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~sh-use-pfn_down-macro
+++ a/arch/sh/mm/init.c
@@ -488,7 +488,7 @@ void free_initrd_mem(unsigned long start
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat;
-	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
@@ -517,7 +517,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 #ifdef CONFIG_MEMORY_HOTREMOVE
 int arch_remove_memory(u64 start, u64 size)
 {
-	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 	int ret;
diff -puN arch/sh/mm/numa.c~sh-use-pfn_down-macro arch/sh/mm/numa.c
--- a/arch/sh/mm/numa.c~sh-use-pfn_down-macro
+++ a/arch/sh/mm/numa.c
@@ -33,8 +33,8 @@ void __init setup_bootmem_node(int nid,
 	/* Don't allow bogus node assignment */
 	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
 
-	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = end >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_DOWN(end);
 
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-memblock-rename-local-variable-of-memblock_type-to-type.patch
mm-memblock-typo-fixed.patch
mm-memblockc-fix-comment-in-the-__next_mem_range.patch

