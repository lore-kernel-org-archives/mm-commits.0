From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:01 -0800
Message-ID: <569e95c1.WZrP3ry/nLbKIyxm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASUAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use list_for_each_entry_safe in free_swap_count_continuations
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

