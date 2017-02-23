From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:14:37 -0800
Message-ID: <58af50bd.1GAr0ut54WvO7SkB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add tlbflush.h header for microblaze
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: shmem: add tlbflush.h header for microblaze

It resolves this build error:

All errors (new ones prefixed by >>):

   mm/shmem.c: In function 'shmem_mcopy_atomic_pte':
   >> mm/shmem.c:2228:2: error: implicit declaration of function
   'update_mmu_cache' [-Werror=implicit-function-declaration]
        update_mmu_cache(dst_vma, dst_addr, dst_pte);

microblaze may have to be also updated to define it in asm/pgtable.h like
the other archs, then this header inclusion can be removed.

Link: http://lkml.kernel.org/r/20161216144821.5183-31-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/shmem.c~userfaultfd-shmem-add-tlbflushh-header-for-microblaze mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-add-tlbflushh-header-for-microblaze
+++ a/mm/shmem.c
@@ -34,6 +34,8 @@
 #include <linux/uio.h>
 #include <linux/khugepaged.h>
 
+#include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
+
 static struct vfsmount *shm_mnt;
 
 #ifdef CONFIG_SHMEM
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

