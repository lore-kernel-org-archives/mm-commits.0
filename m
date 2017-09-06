From: akpm@linux-foundation.org
Subject: [patch 082/119] userfaultfd: shmem: wire up
 shmem_mfill_zeropage_pte
Date: Wed, 06 Sep 2017 16:23:09 -0700
Message-ID: <20170906232309.T5gkDAubW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdIFXXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, xemul@virtuozzo.com

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
