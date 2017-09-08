From: akpm@linux-foundation.org
Subject: [folded-merged] lib-add-test-for-bitmap_parselist-fix.patch
 removed from -mm tree
Date: Fri, 08 Sep 2017 16:04:06 -0700
Message-ID: <59b321e6.a1pMhdgLM06rTluC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49970 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932730AbdIHXEH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, noamca@mellanox.com, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-add-test-for-bitmap_parselist-fix
has been removed from the -mm tree.  Its filename was
     lib-add-test-for-bitmap_parselist-fix.patch

This patch was dropped because it was folded into lib-add-test-for-bitmap_parselist.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-add-test-for-bitmap_parselist-fix

fix printk warning

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Noam Camus <noamca@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/test_bitmap.c~lib-add-test-for-bitmap_parselist-fix lib/test_bitmap.c
--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parselist-fix
+++ a/lib/test_bitmap.c
@@ -232,8 +232,9 @@ static void __init test_bitmap_parselist
 		}
 
 		if (ptest.flags & PARSE_TIME)
-			pr_err("test %d: input is '%s' OK, Time: %lu\n",
-					i, ptest.in, cycles);
+			pr_err("test %d: input is '%s' OK, Time: %llu\n",
+					i, ptest.in,
+					(unsigned long long)cycles);
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-add-test-for-bitmap_parselist.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

