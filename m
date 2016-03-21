From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-drop-unused-member-mapping_area-huge.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:33 -0700
Message-ID: <56f04021.XqvlhJBkSVJWLvmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbcCUT4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuyiping@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: drop unused member 'mapping_area->huge'
has been removed from the -mm tree.  Its filename was
     zsmalloc-drop-unused-member-mapping_area-huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YiPing Xu <xuyiping@huawei.com>
Subject: zsmalloc: drop unused member 'mapping_area->huge'

When unmapping a huge class page in zs_unmap_object, the page will be
unmapped by kmap_atomic.  the "!area->huge" branch in __zs_unmap_object is
alway true, and no code set "area->huge" now, so we can drop it.

Signed-off-by: YiPing Xu <xuyiping@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-drop-unused-member-mapping_area-huge mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-drop-unused-member-mapping_area-huge
+++ a/mm/zsmalloc.c
@@ -281,7 +281,6 @@ struct mapping_area {
 #endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
-	bool huge;
 };
 
 static int create_handle_cache(struct zs_pool *pool)
@@ -1127,11 +1126,9 @@ static void __zs_unmap_object(struct map
 		goto out;
 
 	buf = area->vm_buf;
-	if (!area->huge) {
-		buf = buf + ZS_HANDLE_SIZE;
-		size -= ZS_HANDLE_SIZE;
-		off += ZS_HANDLE_SIZE;
-	}
+	buf = buf + ZS_HANDLE_SIZE;
+	size -= ZS_HANDLE_SIZE;
+	off += ZS_HANDLE_SIZE;
 
 	sizes[0] = PAGE_SIZE - off;
 	sizes[1] = size - sizes[0];
_

Patches currently in -mm which might be from xuyiping@huawei.com are


