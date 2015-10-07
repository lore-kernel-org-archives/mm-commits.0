From: akpm@linux-foundation.org
Subject: + mm-dont-offset-memmap-for-flatmem.patch added to -mm tree
Date: Wed, 07 Oct 2015 15:38:59 -0700
Message-ID: <56159f03.URKh9la6ZUcwHSmp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbJGWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 18:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laura@labbott.name, agross@codeaurora.org, arnd@arndb.de, bjorn.andersson@sonymobile.com, dave.hansen@linux.intel.com, khilman@linaro.org, lauraa@codeaurora.org, mgorman@suse.de, rmk@arm.linux.org.uk, rostedt@goodmis.org, sboyd@codeaurora.org, srinivas.kandagatla@linaro.org, ssantosh@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Don't offset memmap for flatmem
has been added to the -mm tree.  Its filename is
     mm-dont-offset-memmap-for-flatmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-offset-memmap-for-flatmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-offset-memmap-for-flatmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <laura@labbott.name>
Subject: mm: Don't offset memmap for flatmem

Srinivas Kandagatla reported bad page messages when trying to remove the
bottom 2MB on an ARM based IFC6410 board

BUG: Bad page state in process swapper  pfn:fffa8
page:ef7fb500 count:0 mapcount:0 mapping:  (null) index:0x0
flags: 0x96640253(locked|error|dirty|active|arch_1|reclaim|mlocked)
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
bad because of flags:
flags: 0x200041(locked|active|mlocked)
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.19.0-rc3-00007-g412f9ba-dirty #816
Hardware name: Qualcomm (Flattened Device Tree)
[<c0218280>] (unwind_backtrace) from [<c0212be8>] (show_stack+0x20/0x24)
[<c0212be8>] (show_stack) from [<c0af7124>] (dump_stack+0x80/0x9c)
[<c0af7124>] (dump_stack) from [<c0301570>] (bad_page+0xc8/0x128)
[<c0301570>] (bad_page) from [<c03018a8>] (free_pages_prepare+0x168/0x1e0)
[<c03018a8>] (free_pages_prepare) from [<c030369c>] (free_hot_cold_page+0x3c/0x174)
[<c030369c>] (free_hot_cold_page) from [<c0303828>] (__free_pages+0x54/0x58)
[<c0303828>] (__free_pages) from [<c030395c>] (free_highmem_page+0x38/0x88)
[<c030395c>] (free_highmem_page) from [<c0f62d5c>] (mem_init+0x240/0x430)
[<c0f62d5c>] (mem_init) from [<c0f5db3c>] (start_kernel+0x1e4/0x3c8)
[<c0f5db3c>] (start_kernel) from [<80208074>] (0x80208074)
Disabling lock debugging due to kernel taint

Removing the lower 2MB made the start of the lowmem zone to no longer be
page block aligned.  IFC6410 uses CONFIG_FLATMEM where alloc_node_mem_map
allocates memory for the mem_map.  alloc_node_mem_map will offset for
unaligned nodes with the assumption the pfn/page translation functions
will account for the offset.  The functions for CONFIG_FLATMEM do not
offset however, resulting in overrunning the memmap array.  Just use the
allocated memmap without any offset when running with CONFIG_FLATMEM to
avoid the overrun.

Signed-off-by: Laura Abbott <laura@labbott.name>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Reported-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Arnd Bergman <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andy Gross <agross@codeaurora.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-dont-offset-memmap-for-flatmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dont-offset-memmap-for-flatmem
+++ a/mm/page_alloc.c
@@ -5241,6 +5241,8 @@ static void __paginginit free_area_init_
 
 static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 {
+	unsigned long __maybe_unused offset = 0;
+
 	/* Skip empty nodes */
 	if (!pgdat->node_spanned_pages)
 		return;
@@ -5257,6 +5259,7 @@ static void __init_refok alloc_node_mem_
 		 * for the buddy allocator to function correctly.
 		 */
 		start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
+		offset = pgdat->node_start_pfn - start;
 		end = pgdat_end_pfn(pgdat);
 		end = ALIGN(end, MAX_ORDER_NR_PAGES);
 		size =  (end - start) * sizeof(struct page);
@@ -5264,7 +5267,7 @@ static void __init_refok alloc_node_mem_
 		if (!map)
 			map = memblock_virt_alloc_node_nopanic(size,
 							       pgdat->node_id);
-		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
+		pgdat->node_mem_map = map + offset;
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	/*
@@ -5272,9 +5275,9 @@ static void __init_refok alloc_node_mem_
 	 */
 	if (pgdat == NODE_DATA(0)) {
 		mem_map = NODE_DATA(0)->node_mem_map;
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+#if defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) || defined(CONFIG_FLATMEM)
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
-			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
+			mem_map -= offset;
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
_

Patches currently in -mm which might be from laura@labbott.name are

mm-dont-offset-memmap-for-flatmem.patch

