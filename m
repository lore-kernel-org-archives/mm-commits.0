From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-vm_insert_pages-2.patch removed
 from -mm tree
Date: Fri, 10 Apr 2020 11:58:54 -0700
Message-ID: <20200410185854.7BDpxouG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJS6z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, willy@infradead.org


The patch titled
     Subject: add missing page_count() check to vm_insert_pages().
has been removed from the -mm tree.  Its filename was
     mm-add-vm_insert_pages-2.patch

This patch was dropped because it was folded into mm-add-vm_insert_pages.patch

------------------------------------------------------
From: Arjun Roy <arjunroy@google.com>
Subject: add missing page_count() check to vm_insert_pages().

Add missing page_count() check to vm_insert_pages(), specifically inside
insert_page_in_batch_locked().  This was accidentally forgotten in the
original patchset.

See: https://marc.info/?l=linux-mm&m=158156166403807&w=2

The intention of this patch-set is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

Link: http://lkml.kernel.org/r/20200214005929.104481-1-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-add-vm_insert_pages-2
+++ a/mm/memory.c
@@ -1475,8 +1475,11 @@ static int insert_page_into_pte_locked(s
 static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
-	const int err = validate_page_before_insert(page);
+	int err;
 
+	if (!page_count(page))
+		return -EINVAL;
+	err = validate_page_before_insert(page);
 	return err ? err : insert_page_into_pte_locked(
 		mm, pte_offset_map(pmd, addr), addr, page, prot);
 }
_

Patches currently in -mm which might be from arjunroy@google.com are

mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch
mm-define-pte_index-as-macro-for-x86.patch
mm-add-vm_insert_pages.patch
mm-add-vm_insert_pages-2-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
