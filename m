From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempool-poison-elements-backed-by-page-allocator-fix.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 15:37:38 -0700
Message-ID: <552ee832.YlUB6wywK/1rS7dH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbDOWhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: use '%zu' for printing 'size_t' variable
has been removed from the -mm tree.  Its filename was
     mm-mempool-poison-elements-backed-by-page-allocator-fix.patch

This patch was dropped because it was folded into mm-mempool-poison-elements-backed-by-slab-allocator.patch

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: mm, mempool: use '%zu' for printing 'size_t' variable

fix printk warning

Commit 8b65aaa9c53404 ("mm, mempool: poison elements backed by page allocator")
caused the following build warning on ARM:

mm/mempool.c:31:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' [-Wformat]

Use '%zu' for printing 'size_t' variable.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix
+++ a/mm/mempool.c
@@ -28,7 +28,7 @@ static void poison_error(mempool_t *pool
 	int i;
 
 	pr_err("BUG: mempool element poison mismatch\n");
-	pr_err("Mempool %p size %ld\n", pool, size);
+	pr_err("Mempool %p size %zu\n", pool, size);
 	pr_err(" nr=%d @ %p: %s0x", nr, element, start > 0 ? "... " : "");
 	for (i = start; i < end; i++)
 		pr_cont("%x ", *(u8 *)(element + i));
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch

