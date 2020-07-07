From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch
 added to -mm tree
Date: Tue, 07 Jul 2020 12:27:15 -0700
Message-ID: <20200707192715.BYYBZcMOl%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgGGT1Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:27:16 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, jroedel@suse.de, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm: vmalloc: remove redundant asignmnet in unmap_kernel_range_noflush()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: vmalloc: remove redundant asignmnet in unmap_kernel_range_noflush()

'addr' is set to 'start' and then a few lines afterwards 'start' is set to
'addr'.  Remove the second asignment.

Link: http://lkml.kernel.org/r/20200707163226.374685-1-rppt@kernel.org
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush
+++ a/mm/vmalloc.c
@@ -175,7 +175,6 @@ void unmap_kernel_range_noflush(unsigned
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	start = addr;
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch
