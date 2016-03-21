From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-reuse-page_aligned-to-check-page_size-aligned.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:31 -0700
Message-ID: <56f0401f.s2qmIohpXRwGoOy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbcCUT4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.lin@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use PAGE_ALIGNED() to check PAGE_SIZE alignment
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-reuse-page_aligned-to-check-page_size-aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shawn Lin <shawn.lin@rock-chips.com>
Subject: mm/vmalloc: use PAGE_ALIGNED() to check PAGE_SIZE alignment

We have PAGE_ALIGNED() in mm.h, so let's use it instead of IS_ALIGNED()
for checking PAGE_SIZE aligned case.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-reuse-page_aligned-to-check-page_size-aligned mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-reuse-page_aligned-to-check-page_size-aligned
+++ a/mm/vmalloc.c
@@ -1085,7 +1085,7 @@ void vm_unmap_ram(const void *mem, unsig
 	BUG_ON(!addr);
 	BUG_ON(addr < VMALLOC_START);
 	BUG_ON(addr > VMALLOC_END);
-	BUG_ON(!IS_ALIGNED(addr, PAGE_SIZE));
+	BUG_ON(!PAGE_ALIGNED(addr));
 
 	debug_check_no_locks_freed(mem, size);
 	vmap_debug_free_range(addr, addr+size);
_

Patches currently in -mm which might be from shawn.lin@rock-chips.com are


