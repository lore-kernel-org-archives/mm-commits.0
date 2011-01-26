From: akpm@linux-foundation.org
Subject: [merged] thp-fix-paravirt-x86-32bit-nopae.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:17 -0800
Message-ID: <201101262032.p0QKWHfV003152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069Ab1AZUcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, minchan.kim@gmail.com, w.landgraf@ru.ru, mm-commits@vger.kernel.org


The patch titled
     thp: fix PARAVIRT x86 32bit noPAE
has been removed from the -mm tree.  Its filename was
     thp-fix-paravirt-x86-32bit-nopae.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix PARAVIRT x86 32bit noPAE
From: Andrea Arcangeli <aarcange@redhat.com>

This fixes TRANSPARENT_HUGEPAGE=y with PARAVIRT=y and HIGHMEM64=n.

The #ifdef that this patch removes was erratically introduced to fix a
build error for noPAE (where pmd.pmd doesn't exist).  So then the kernel
built but it failed at runtime because set_pmd_at was a noop.  This will
correct it by enabling set_pmd_at for noPAE mode too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: werner <w.landgraf@ru.ru>
Reported-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/paravirt.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/paravirt.h~thp-fix-paravirt-x86-32bit-nopae arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h~thp-fix-paravirt-x86-32bit-nopae
+++ a/arch/x86/include/asm/paravirt.h
@@ -558,13 +558,12 @@ static inline void set_pte_at(struct mm_
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-#if PAGETABLE_LEVELS >= 3
 	if (sizeof(pmdval_t) > sizeof(long))
 		/* 5 arg words */
 		pv_mmu_ops.set_pmd_at(mm, addr, pmdp, pmd);
 	else
-		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp, pmd.pmd);
-#endif
+		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp,
+			    native_pmd_val(pmd));
 }
 #endif
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

