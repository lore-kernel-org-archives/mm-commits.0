From: akpm@linux-foundation.org
Subject: + sh-use-pfn_down-macro.patch added to -mm tree
Date: Tue, 11 Aug 2015 15:24:33 -0700
Message-ID: <55ca7621.hrx7507B7Dur9x17%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbHKWYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 18:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: use PFN_DOWN macro
has been added to the -mm tree.  Its filename is
     sh-use-pfn_down-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-use-pfn_down-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-use-pfn_down-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-use-pfn_down-macro.patch
memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch
linux-next.patch

