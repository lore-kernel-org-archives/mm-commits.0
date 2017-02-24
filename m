From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:34:10 -0800
Message-ID: <58b0b4e2.6QxJ+SSUcreSTOm5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbdBXWkx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:40:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, alexander.kapshuk@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,x86: fix SMP x86 32bit build for native_pud_clear()
has been removed from the -mm tree.  Its filename was
     mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch

This patch was dropped because it was folded into mm-x86-add-support-for-pud-sized-transparent-hugepages.patch

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm,x86: fix SMP x86 32bit build for native_pud_clear()

The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
that broke the SMP case that was working previously. Add ifdef so the dummy
function only show up for 32bit UP case only.

Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build

Link: http://lkml.kernel.org/r/148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reported-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Tested-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/pgtable-3level.h~mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,9 +121,11 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
+#ifndef CONFIG_SMP
 static inline void native_pud_clear(pud_t *pudp)
 {
 }
+#endif
 
 static inline void pud_clear(pud_t *pudp)
 {
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages-for-device-dax.patch
mm-replace-fault_flag_size-with-parameter-to-huge_fault.patch

