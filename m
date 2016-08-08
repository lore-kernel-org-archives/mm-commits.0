From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-fix-null-dereference-error.patch removed
 from -mm tree
Date: Mon, 08 Aug 2016 13:15:19 -0700
Message-ID: <57a8e857.YMTzVrBiRoW2upMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix NULL dereference error
has been removed from the -mm tree.  Its filename was
     mm-memblockc-fix-null-dereference-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/memblock.c: fix NULL dereference error

It causes NULL dereference error and failure to get type_a->regions[0]
info if parameter type_b of __next_mem_range_rev() == NULL

Fix this by checking before dereferring and initializing idx_b to 0

The approach is tested by dumping all types of region via
__memblock_dump_all() and __next_mem_range_rev() fixed to UART separately
the result is okay after checking the logs.

Link: http://lkml.kernel.org/r/57A0320D.6070102@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Tested-by: zijun_hu <zijun_hu@htc.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-fix-null-dereference-error mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-fix-null-dereference-error
+++ a/mm/memblock.c
@@ -994,7 +994,10 @@ void __init_memblock __next_mem_range_re
 
 	if (*idx == (u64)ULLONG_MAX) {
 		idx_a = type_a->cnt - 1;
-		idx_b = type_b->cnt;
+		if (type_b != NULL)
+			idx_b = type_b->cnt;
+		else
+			idx_b = 0;
 	}
 
 	for (; idx_a >= 0; idx_a--) {
_

Patches currently in -mm which might be from zijun_hu@htc.com are


