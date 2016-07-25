From: akpm@linux-foundation.org
Subject: +
 mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch added to -mm tree
Date: Mon, 25 Jul 2016 16:32:05 -0700
Message-ID: <5796a175.i0IDWypZJwUuZczg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbcGYXcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 19:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, ard.biesheuvel@linaro.org, david@gibson.dropbear.id.au, dev@g0hl1n.net, kuleshovmail@gmail.com, tangchen@cn.fujitsu.com, tj@kernel.org, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix index adjustment error in  __next_mem_range_rev()
has been added to the -mm tree.  Its filename is
     mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memblockc-fix-index-adjustment-error-in-__next_mem_range_rev.patch

