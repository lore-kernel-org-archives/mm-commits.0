From: akpm@linux-foundation.org
Subject: [patch 089/101] mm/memblock.c: fix index adjustment error in
  __next_mem_range_rev()
Date: Thu, 28 Jul 2016 15:48:56 -0700
Message-ID: <579a8bd8.1OA3dtW6217fG7+5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcG1Ws5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zijun_hu@htc.com, ard.biesheuvel@linaro.org, david@gibson.dropbear.id.au, dev@g0hl1n.net, kuleshovmail@gmail.com, tangchen@cn.fujitsu.com, tj@kernel.org, weiyang@linux.vnet.ibm.com

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
