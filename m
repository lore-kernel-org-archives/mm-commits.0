From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch added to -mm tree
Date: Thu, 17 Dec 2015 14:32:29 -0800
Message-ID: <567337fd.CS9dUReP7ofIP2bx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbbLQWca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 17:32:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use list_for_each_entry_safe in free_swap_count_continuations
has been added to the -mm tree.  Its filename is
     mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch

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
Subject: mm/swapfile.c: use list_for_each_entry_safe in free_swap_count_continuations

Use list_for_each_entry_safe() instead of list_for_each_safe() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations
+++ a/mm/swapfile.c
@@ -2953,11 +2953,10 @@ static void free_swap_count_continuation
 		struct page *head;
 		head = vmalloc_to_page(si->swap_map + offset);
 		if (page_private(head)) {
-			struct list_head *this, *next;
-			list_for_each_safe(this, next, &head->lru) {
-				struct page *page;
-				page = list_entry(this, struct page, lru);
-				list_del(this);
+			struct page *page, *next;
+
+			list_for_each_entry_safe(page, next, &head->lru, lru) {
+				list_del(&page->lru);
 				__free_page(page);
 			}
 		}
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
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
dma-mapping-use-offset_in_page-macro.patch

