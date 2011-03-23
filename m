From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-atmel_tclibc-fix-a-memory-leak.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:45 -0700
Message-ID: <201103232042.p2NKgLYk028752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933444Ab1CWUmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/atmel_tclib.c: fix a memory leak
has been removed from the -mm tree.  Its filename was
     drivers-misc-atmel_tclibc-fix-a-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/atmel_tclib.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

request_mem_region() will call kzalloc to allocate memory for struct
resource.  release_resource() unregisters the resource but does not free
the allocated memory, thus use release_mem_region() instead to fix the
memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel_tclib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/atmel_tclib.c~drivers-misc-atmel_tclibc-fix-a-memory-leak drivers/misc/atmel_tclib.c
--- a/drivers/misc/atmel_tclib.c~drivers-misc-atmel_tclibc-fix-a-memory-leak
+++ a/drivers/misc/atmel_tclib.c
@@ -75,7 +75,7 @@ out:
 	return tc;
 
 fail_ioremap:
-	release_resource(r);
+	release_mem_region(r->start, ATMEL_TC_IOMEM_SIZE);
 fail:
 	tc = NULL;
 	goto out;
@@ -95,7 +95,7 @@ void atmel_tc_free(struct atmel_tc *tc)
 	spin_lock(&tc_list_lock);
 	if (tc->regs) {
 		iounmap(tc->regs);
-		release_resource(tc->iomem);
+		release_mem_region(tc->iomem->start, ATMEL_TC_IOMEM_SIZE);
 		tc->regs = NULL;
 		tc->iomem = NULL;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

