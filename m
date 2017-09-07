From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:40:28 -0700
Message-ID: <20170907184028.Se3ZUjHJq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755551AbdIGSk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd: shmem: wire up shmem_mfill_zeropage_pte
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: wire up shmem_mfill_zeropage_pte

For shmem VMAs we can use shmem_mfill_zeropage_pte for UFFDIO_ZEROPAGE

Link: http://lkml.kernel.org/r/1497939652-16528-6-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte
+++ a/mm/userfaultfd.c
@@ -389,11 +389,13 @@ static __always_inline ssize_t mfill_ato
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
 	} else {
-		err = -EINVAL; /* if zeropage is true return -EINVAL */
-		if (likely(!zeropage))
+		if (!zeropage)
 			err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
 						     dst_vma, dst_addr,
 						     src_addr, page);
+		else
+			err = shmem_mfill_zeropage_pte(dst_mm, dst_pmd,
+						       dst_vma, dst_addr);
 	}
 
 	return err;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


