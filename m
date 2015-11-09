From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:08 -0800
Message-ID: <5640f7c4.S2NScDIpvZyX4zyW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbKITpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix obj_to_head use page_private(page) as value but not pointer
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: zsmalloc: fix obj_to_head use page_private(page) as value but not pointer

In obj_malloc():

	if (!class->huge)
		/* record handle in the header of allocated chunk */
		link->handle = handle;
	else
		/* record handle in first_page->private */
		set_page_private(first_page, handle);

In the hugepage we save handle to private directly.

But in obj_to_head():

	if (class->huge) {
		VM_BUG_ON(!is_first_page(page));
		return *(unsigned long *)page_private(page);
	} else
		return *(unsigned long *)obj;

It is used as a pointer.

The reason why there is no problem until now is huge-class page is born
with ZS_FULL so it can't be migrated.  However, we need this patch for
future work: "VM-aware zsmalloced page migration" to reduce external
fragmentation.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer
+++ a/mm/zsmalloc.c
@@ -825,7 +825,7 @@ static unsigned long obj_to_head(struct
 {
 	if (class->huge) {
 		VM_BUG_ON(!is_first_page(page));
-		return *(unsigned long *)page_private(page);
+		return page_private(page);
 	} else
 		return *(unsigned long *)obj;
 }
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are


