From: akpm@linux-foundation.org
Subject: [merged]
 zswap-potential-null-dereference-on-error-in-init_zswap.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:19:24 -0800
Message-ID: <20200131231924.SZHl6oPXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXTZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org, vitaly.wool@konsulko.com


The patch titled
     Subject: zswap: potential NULL dereference on error in init_zswap()
has been removed from the -mm tree.  Its filename was
     zswap-potential-null-dereference-on-error-in-init_zswap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: zswap: potential NULL dereference on error in init_zswap()

The "pool" pointer can be NULL at the end of the init_zswap().  (We would
allocate a new pool later in that situation.) So in the error handling
then we need to make sure pool is a valid pointer before calling
"zswap_pool_destroy(pool);" because that function dereferences the
argument.

Link: http://lkml.kernel.org/r/20200114050902.og32fkllkod5ycf5@kili.mountain
Fixes: 93d4dfa9fbd0 ("mm/zswap.c: add allocation hysteresis if pool limit is hit")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-potential-null-dereference-on-error-in-init_zswap
+++ a/mm/zswap.c
@@ -1359,7 +1359,8 @@ static int __init init_zswap(void)
 	return 0;
 
 fallback_fail:
-	zswap_pool_destroy(pool);
+	if (pool)
+		zswap_pool_destroy(pool);
 hp_fail:
 	cpuhp_remove_state(CPUHP_MM_ZSWP_MEM_PREPARE);
 dstmem_fail:
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are
