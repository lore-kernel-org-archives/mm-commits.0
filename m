From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 14:16:37 -0700
Message-ID: <57801835.du1gdwgjkkRr4nuY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbcGHVQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: take obj index back from find_alloced_obj
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: take obj index back from find_alloced_obj

the obj index value should be updated after return from
find_alloced_obj() to avoid CPU burning caused by unnecessary
object scanning.

Link: http://lkml.kernel.org/r/1467882338-4300-2-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-take-obj-index-back-from-find_alloced_obj mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-take-obj-index-back-from-find_alloced_obj
+++ a/mm/zsmalloc.c
@@ -1744,10 +1744,11 @@ static void zs_object_copy(struct size_c
  * return handle.
  */
 static unsigned long find_alloced_obj(struct size_class *class,
-					struct page *page, int index)
+					struct page *page, int *obj_idx)
 {
 	unsigned long head;
 	int offset = 0;
+	int index = *obj_idx;
 	unsigned long handle = 0;
 	void *addr = kmap_atomic(page);
 
@@ -1768,6 +1769,9 @@ static unsigned long find_alloced_obj(st
 	}
 
 	kunmap_atomic(addr);
+
+	*obj_idx = index;
+
 	return handle;
 }
 
@@ -1793,7 +1797,7 @@ static int migrate_zspage(struct zs_pool
 	int ret = 0;
 
 	while (1) {
-		handle = find_alloced_obj(class, s_page, obj_idx);
+		handle = find_alloced_obj(class, s_page, &obj_idx);
 		if (!handle) {
 			s_page = get_next_page(s_page);
 			if (!s_page)
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-migrate-support-non-lru-movable-page-migration-fix.patch
mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch
mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch
mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch
mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch
mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch
mm-zsmalloc-keep-comments-consistent-with-code.patch
mm-zsmalloc-add-__init__exit-attribute.patch
mm-zsmalloc-use-helper-to-clear-page-flags-bit.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

