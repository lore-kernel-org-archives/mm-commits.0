From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-vm_insert_pages-fix.patch removed
 from -mm tree
Date: Fri, 10 Apr 2020 11:58:51 -0700
Message-ID: <20200410185851.OD531J2Nc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJS6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy.kdev@gmail.com, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, willy@infradead.org


The patch titled
     Subject: mm-add-vm_insert_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-add-vm_insert_pages-fix.patch

This patch was dropped because it was folded into mm-add-vm_insert_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-vm_insert_pages-fix

pte_alloc() no longer takes the `addr' argument

Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-add-vm_insert_pages-fix
+++ a/mm/memory.c
@@ -1533,7 +1533,7 @@ more:
 
 	/* Allocate the PTE if necessary; takes PMD lock once only. */
 	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd, addr))
+	if (pte_alloc(mm, pmd))
 		goto out;
 	pte_lock = pte_lockptr(mm, pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-cma-numa-node-interface-fix.patch
mm-add-vm_insert_pages.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
