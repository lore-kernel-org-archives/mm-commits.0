From: akpm@linux-foundation.org
Subject: [merged] mm-shmem-mark-expected-switch-fall-through.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:05:06 -0800
Message-ID: <20171116200506.8Cdzc75R3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935859AbdKPUFH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garsilva@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: mark expected switch fall-through
has been removed from the -mm tree.  Its filename was
     mm-shmem-mark-expected-switch-fall-through.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from garsilva@embeddedor.com are


