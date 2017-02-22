From: akpm@linux-foundation.org
Subject: [patch 075/142] userfaultfd: shmem: add tlbflush.h header for
 microblaze
Date: Wed, 22 Feb 2017 15:43:31 -0800
Message-ID: <58ae2223.YIc0ajyxk4Wb4sQC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933974AbdBVXnd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

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
