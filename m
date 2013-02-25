From: akpm@linux-foundation.org
Subject: [merged] mm-dont-inline-page_mapping.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:52 -0800
Message-ID: <20130225205252.DE1235A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39042 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab3BYUwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:54 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so363054qah.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, akpm@linux-foundation.org, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't inline page_mapping()
has been removed from the -mm tree.  Its filename was
     mm-dont-inline-page_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: don't inline page_mapping()

According to akpm, this saves 1/2k text and makes things simple for the
next patch.

Numbers from Minchan:

add/remove: 1/0 grow/shrink: 6/22 up/down: 92/-516 (-424)
function                                     old     new   delta
page_mapping                                   -      48     +48
do_task_stat                                2292    2308     +16
page_remove_rmap                             240     248      +8
load_elf_binary                             4500    4508      +8
update_queue                                 532     536      +4
scsi_probe_and_add_lun                      2892    2896      +4
lookup_fast                                  644     648      +4
vcs_read                                    1040    1036      -4
__ip_route_output_key                       1904    1900      -4
ip_route_input_noref                        2508    2500      -8
shmem_file_aio_read                          784     772     -12
__isolate_lru_page                           272     256     -16
shmem_replace_page                           708     688     -20
mark_buffer_dirty                            228     208     -20
__set_page_dirty_buffers                     240     220     -20
__remove_mapping                             276     256     -20
update_mmu_cache                             500     476     -24
set_page_dirty_balance                        92      68     -24
set_page_dirty                               172     148     -24
page_evictable                                88      64     -24
page_cache_pipe_buf_steal                    248     224     -24
clear_page_dirty_for_io                      340     316     -24
test_set_page_writeback                      400     372     -28
test_clear_page_writeback                    516     488     -28
invalidate_inode_page                        156     128     -28
page_mkclean                                 432     400     -32
flush_dcache_page                            360     328     -32
__set_page_dirty_nobuffers                   324     280     -44
shrink_page_list                            2412    2356     -56

Signed-off-by: Shaohua Li <shli@fusionio.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +------------
 mm/util.c          |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~mm-dont-inline-page_mapping include/linux/mm.h
--- a/include/linux/mm.h~mm-dont-inline-page_mapping
+++ a/include/linux/mm.h
@@ -809,18 +809,7 @@ void page_address_init(void);
 #define PAGE_MAPPING_KSM	2
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
-extern struct address_space swapper_space;
-static inline struct address_space *page_mapping(struct page *page)
-{
-	struct address_space *mapping = page->mapping;
-
-	VM_BUG_ON(PageSlab(page));
-	if (unlikely(PageSwapCache(page)))
-		mapping = &swapper_space;
-	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
-		mapping = NULL;
-	return mapping;
-}
+extern struct address_space *page_mapping(struct page *page);
 
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 static inline void *page_rmapping(struct page *page)
diff -puN mm/util.c~mm-dont-inline-page_mapping mm/util.c
--- a/mm/util.c~mm-dont-inline-page_mapping
+++ a/mm/util.c
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/swap.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -382,6 +383,21 @@ unsigned long vm_mmap(struct file *file,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+struct address_space *page_mapping(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	VM_BUG_ON(PageSlab(page));
+#ifdef CONFIG_SWAP
+	if (unlikely(PageSwapCache(page)))
+		mapping = &swapper_space;
+	else
+#endif
+	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
+		mapping = NULL;
+	return mapping;
+}
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
kernel-smpc-cleanups.patch

