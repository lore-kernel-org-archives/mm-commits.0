From: akpm@linux-foundation.org
Subject: + mm-memblockc-fix-null-dereference-error.patch added to -mm tree
Date: Thu, 04 Aug 2016 14:53:21 -0700
Message-ID: <57a3b951.ULknb7xGNtPn49ds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbcHDVxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:53:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix NULL dereference error
has been added to the -mm tree.  Its filename is
     mm-memblockc-fix-null-dereference-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-fix-null-dereference-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-fix-null-dereference-error.patch

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

mm-memblockc-fix-null-dereference-error.patch

