From: akpm@linux-foundation.org
Subject: + mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch
 added to -mm tree
Date: Fri, 08 Jan 2016 14:14:12 -0800
Message-ID: <569034b4.tyTnDnnAIwLjKvHf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbcAHWON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 17:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: use macro IS_ALIGNED to judge the aligment
has been added to the -mm tree.  Its filename is
     mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range.patch
mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch

