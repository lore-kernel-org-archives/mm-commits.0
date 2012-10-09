From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:05 -0700
Message-ID: <20121009181305.E27CD100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38978 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2JISNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:07 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so519002qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, aarcange@redhat.com, arnd@arndb.de, cmetcalf@tilera.com, gerald.schaefer@de.ibm.com, kirill@shutemov.name, mhocko@suse.cz, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix the pmd_clear() arguments in pmdp_get_and_clear()
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: thp: fix the pmd_clear() arguments in pmdp_get_and_clear()

The CONFIG_TRANSPARENT_HUGEPAGE implementation of pmdp_get_and_clear()
calls pmd_clear() with 3 arguments instead of 1.

This happens only for !__HAVE_ARCH_PMDP_GET_AND_CLEAR which doesn't seem
to happen because x86 defines this and it uses pmd_update.

[mhocko@suse.cz: changelog addition]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear
+++ a/include/asm-generic/pgtable.h
@@ -87,7 +87,7 @@ static inline pmd_t pmdp_get_and_clear(s
 				       pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
-	pmd_clear(mm, address, pmdp);
+	pmd_clear(pmdp);
 	return pmd;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

