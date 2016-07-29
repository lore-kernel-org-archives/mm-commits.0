From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:56:14 -0700
Message-ID: <579ba6ce.DvGxrGmozlDVm6pH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbcG2S4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: take obj index back from find_alloced_obj
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1741,10 +1741,11 @@ static void zs_object_copy(struct size_c
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
 
@@ -1765,6 +1766,9 @@ static unsigned long find_alloced_obj(st
 	}
 
 	kunmap_atomic(addr);
+
+	*obj_idx = index;
+
 	return handle;
 }
 
@@ -1790,7 +1794,7 @@ static int migrate_zspage(struct zs_pool
 	int ret = 0;
 
 	while (1) {
-		handle = find_alloced_obj(class, s_page, obj_idx);
+		handle = find_alloced_obj(class, s_page, &obj_idx);
 		if (!handle) {
 			s_page = get_next_page(s_page);
 			if (!s_page)
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

