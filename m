From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:22:52 -0700
Message-ID: <20170711192252.cUt6hCl6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTWx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garsilva@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: add NULL check to avoid potential NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     mm-add-null-check-to-avoid-potential-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: mm/memory_hotplug.c: add NULL check to avoid potential NULL pointer dereference

NULL check at line 1226: if (!pgdat), implies that pointer pgdat
might be NULL.

rollback_node_hotadd() dereferences this pointer.  Add NULL check to avoid
a potential NULL pointer dereference.

Addresses-Coverity-ID: 1369133
Link: http://lkml.kernel.org/r/20170530212436.GA6195@embeddedgus
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-add-null-check-to-avoid-potential-null-pointer-dereference mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-null-check-to-avoid-potential-null-pointer-dereference
+++ a/mm/memory_hotplug.c
@@ -1268,7 +1268,7 @@ register_fail:
 
 error:
 	/* rollback pgdat allocation and others */
-	if (new_pgdat)
+	if (new_pgdat && pgdat)
 		rollback_node_hotadd(nid, pgdat);
 	memblock_remove(start, size);
 
_

Patches currently in -mm which might be from garsilva@embeddedor.com are


