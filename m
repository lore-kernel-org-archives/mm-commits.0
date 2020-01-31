From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 074/118] zswap: potential NULL dereference on
 error in init_zswap()
Date: Thu, 30 Jan 2020 22:15:07 -0800
Message-ID: <20200131061507.Ird0gLXRR%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGPI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:15:08 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vitaly.wool@konsulko.com

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
