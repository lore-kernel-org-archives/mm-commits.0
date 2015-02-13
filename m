From: akpm@linux-foundation.org
Subject: [merged]
 lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:32 -0800
Message-ID: <54de5d08.2r4Ffir/3hAewrEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbbBMUWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshik@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: fix the end addr check in addr_in_gen_pool()
has been removed from the -mm tree.  Its filename was
     lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kikuchi <toshik@chromium.org>
Subject: lib/genalloc.c: fix the end addr check in addr_in_gen_pool()

Since chunk->end_addr is (chunk->start_addr + size - 1), the end address
to compare should be (start + size - 1).

Signed-off-by: Toshi Kikuchi <toshik@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool
+++ a/lib/genalloc.c
@@ -415,7 +415,7 @@ bool addr_in_gen_pool(struct gen_pool *p
 			size_t size)
 {
 	bool found = false;
-	unsigned long end = start + size;
+	unsigned long end = start + size - 1;
 	struct gen_pool_chunk *chunk;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from toshik@chromium.org are

origin.patch

