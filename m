From: akpm@linux-foundation.org
Subject: [patch 121/131] mm/shmem.c: mark expected switch
 fall-through
Date: Wed, 15 Nov 2017 17:38:45 -0800
Message-ID: <20171116013845.8xSNzp5kW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933675AbdKPBir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, garsilva@embeddedor.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: mm/shmem.c: mark expected switch fall-through

In preparation to enabling -Wimplicit-fallthrough, mark switch cases where
we are expecting to fall through.

Link: http://lkml.kernel.org/r/20171020191058.GA24427@embeddedor.com
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~mm-shmem-mark-expected-switch-fall-through mm/shmem.c
--- a/mm/shmem.c~mm-shmem-mark-expected-switch-fall-through
+++ a/mm/shmem.c
@@ -4098,6 +4098,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			if (i_size >= HPAGE_PMD_SIZE &&
 					i_size >> PAGE_SHIFT >= off)
 				return true;
+			/* fall through */
 		case SHMEM_HUGE_ADVISE:
 			/* TODO: implement fadvise() hints */
 			return (vma->vm_flags & VM_HUGEPAGE);
_
