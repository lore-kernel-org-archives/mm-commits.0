From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vm_insert_pages-2.patch added to -mm tree
Date: Thu, 13 Feb 2020 18:50:22 -0800
Message-ID: <20200214025022.0V-MZ3p6p%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNCuX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:50:23 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, soheil@google.com, willy@infradead.org


The patch titled
     Subject: add missing page_count() check to vm_insert_pages().
has been added to the -mm tree.  Its filename is
     mm-add-vm_insert_pages-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vm_insert_pages-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vm_insert_pages-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-add-vm_insert_pages-2
+++ a/mm/memory.c
@@ -1463,8 +1463,11 @@ static int insert_page_into_pte_locked(s
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
mm-add-vm_insert_pages.patch
mm-add-vm_insert_pages-2.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
