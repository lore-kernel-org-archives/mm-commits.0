From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:57:16 -0700
Message-ID: <579ba70c.puRgnBt4yvd0dnyx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcG2S5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, ard.biesheuvel@linaro.org, david@gibson.dropbear.id.au, dev@g0hl1n.net, kuleshovmail@gmail.com, tangchen@cn.fujitsu.com, tj@kernel.org, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix index adjustment error in  __next_mem_range_rev()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/memblock.c: fix index adjustment error in  __next_mem_range_rev()

Fix region index adjustment error when parameter type_b of
__next_mem_range_rev() == NULL.

Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Richard Leitner <dev@g0hl1n.net>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev
+++ a/mm/memblock.c
@@ -1027,7 +1027,7 @@ void __init_memblock __next_mem_range_re
 				*out_end = m_end;
 			if (out_nid)
 				*out_nid = m_nid;
-			idx_a++;
+			idx_a--;
 			*idx = (u32)idx_a | (u64)idx_b << 32;
 			return;
 		}
_

Patches currently in -mm which might be from zijun_hu@htc.com are


