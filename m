From: akpm@linux-foundation.org
Subject: [merged]
 mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:39:08 -0700
Message-ID: <20200403203908.WD9Y_wmjq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbgDCUjI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, wenhu.wang@vivo.com


The patch titled
     Subject: mm/memory.c: clarify a confusing comment for vm_iomap_memory
has been removed from the -mm tree.  Its filename was
     mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Wenhu <wenhu.wang@vivo.com>
Subject: mm/memory.c: clarify a confusing comment for vm_iomap_memory

The param "start" actually referes to the physical memory start, which is
to be mapped into virtual area vma.  And it is the field vma->vm_start
which stands for the start of the area.

Most of the time, we do not read through whole implementation of a
function but only the definition and essential comments.  Accurate
comments are definitely the base stone.

Link: http://lkml.kernel.org/r/20200318052206.105104-1-wenhu.wang@vivo.com
Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-clarify-a-confusing-comment-for-vm_iomap_memory
+++ a/mm/memory.c
@@ -2009,7 +2009,7 @@ EXPORT_SYMBOL(remap_pfn_range);
 /**
  * vm_iomap_memory - remap memory to userspace
  * @vma: user vma to map to
- * @start: start of area
+ * @start: start of the physical memory to be mapped
  * @len: size of area
  *
  * This is a simplified io_remap_pfn_range() for common driver use. The
_

Patches currently in -mm which might be from wenhu.wang@vivo.com are
