From: akpm@linux-foundation.org
Subject: + mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
 added to -mm tree
Date: Thu, 02 Apr 2015 13:04:44 -0700
Message-ID: <551da0dc.Ceo9l+8wiL2HHfGX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbbDBUEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 16:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: use '%zu' for printing 'size_t' variable
has been added to the -mm tree.  Its filename is
     mm-mempool-poison-elements-backed-by-page-allocator-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-poison-elements-backed-by-page-allocator-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
linux-next.patch

