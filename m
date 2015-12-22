From: akpm@linux-foundation.org
Subject: + mm-move-lru_to_page-to-mm_inlineh.patch added to -mm tree
Date: Mon, 21 Dec 2015 16:16:50 -0800
Message-ID: <56789672.BV13v/vU0sPD/8aZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbbLVAQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 19:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move lru_to_page to mm_inline.h
has been added to the -mm tree.  Its filename is
     mm-move-lru_to_page-to-mm_inlineh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-lru_to_page-to-mm_inlineh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-lru_to_page-to-mm_inlineh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm: move lru_to_page to mm_inline.h

Move lru_to_page() from internal.h to mm_inline.h.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 ++
 mm/internal.h             |    2 --
 mm/readahead.c            |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_inline.h~mm-move-lru_to_page-to-mm_inlineh include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-move-lru_to_page-to-mm_inlineh
+++ a/include/linux/mm_inline.h
@@ -100,4 +100,6 @@ static __always_inline enum lru_list pag
 	return lru;
 }
 
+#define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
+
 #endif
diff -puN mm/internal.h~mm-move-lru_to_page-to-mm_inlineh mm/internal.h
--- a/mm/internal.h~mm-move-lru_to_page-to-mm_inlineh
+++ a/mm/internal.h
@@ -119,8 +119,6 @@ extern int isolate_lru_page(struct page
 extern void putback_lru_page(struct page *page);
 extern bool zone_reclaimable(struct zone *zone);
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
-
 /*
  * in mm/rmap.c:
  */
diff -puN mm/readahead.c~mm-move-lru_to_page-to-mm_inlineh mm/readahead.c
--- a/mm/readahead.c~mm-move-lru_to_page-to-mm_inlineh
+++ a/mm/readahead.c
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/mm_inline.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-slabc-add-a-helper-function-get_first_slab.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch
mm-ksmc-use-list_for_each_entry_safe.patch
mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
dma-mapping-use-offset_in_page-macro.patch

