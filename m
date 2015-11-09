From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-remove-unless-line-in-obj_free.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:14 -0800
Message-ID: <5640f7ca.MdxgXqsi/h1pdgPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbbKITpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: remove useless line in obj_free()
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-unless-line-in-obj_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: mm/zsmalloc.c: remove useless line in obj_free()

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-unless-line-in-obj_free mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-unless-line-in-obj_free
+++ a/mm/zsmalloc.c
@@ -1429,8 +1429,6 @@ static void obj_free(struct zs_pool *poo
 	struct page *first_page, *f_page;
 	unsigned long f_objidx, f_offset;
 	void *vaddr;
-	int class_idx;
-	enum fullness_group fullness;
 
 	BUG_ON(!obj);
 
@@ -1438,7 +1436,6 @@ static void obj_free(struct zs_pool *poo
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
-	get_zspage_mapping(first_page, &class_idx, &fullness);
 	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
 
 	vaddr = kmap_atomic(f_page);
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are


