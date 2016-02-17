From: akpm@linux-foundation.org
Subject: + zsmalloc-drop-unused-member-mapping_area-huge.patch added to
 -mm tree
Date: Wed, 17 Feb 2016 11:54:07 -0800
Message-ID: <56c4cfdf.8YoE/0Z6bmvqdpgB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbcBQTyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 14:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuyiping@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: drop unused member 'mapping_area->huge'
has been added to the -mm tree.  Its filename is
     zsmalloc-drop-unused-member-mapping_area-huge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-drop-unused-member-mapping_area-huge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-drop-unused-member-mapping_area-huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-drop-unused-member-mapping_area-huge.patch

