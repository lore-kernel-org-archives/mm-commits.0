From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:14:07 -0800
Message-ID: <569e990f.ENoM+AzSjse+VCMZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: use macro IS_ALIGNED to judge the aligment
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: mm/vmalloc.c: use macro IS_ALIGNED to judge the aligment

Just cleanup, no functional change.

Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment
+++ a/mm/vmalloc.c
@@ -455,7 +455,7 @@ found:
 	free_vmap_cache = &va->rb_node;
 	spin_unlock(&vmap_area_lock);
 
-	BUG_ON(va->va_start & (align-1));
+	BUG_ON(!IS_ALIGNED(va->va_start, align));
 	BUG_ON(va->va_start < vstart);
 	BUG_ON(va->va_end > vend);
 
@@ -1086,7 +1086,7 @@ void vm_unmap_ram(const void *mem, unsig
 	BUG_ON(!addr);
 	BUG_ON(addr < VMALLOC_START);
 	BUG_ON(addr > VMALLOC_END);
-	BUG_ON(addr & (PAGE_SIZE-1));
+	BUG_ON(!IS_ALIGNED(addr, PAGE_SIZE));
 
 	debug_check_no_locks_freed(mem, size);
 	vmap_debug_free_range(addr, addr+size);
_

Patches currently in -mm which might be from wangxq10@lzu.edu.cn are


