From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-x86-add-support-for-pud-sized-transparent-hugepages-fix.patch removed
 from -mm tree
Date: Fri, 24 Feb 2017 14:34:07 -0800
Message-ID: <58b0b4df.H1CsZ+b0kFF/rdwT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdBXWkx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:40:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, mawilcox@microsoft.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,x86: native_pud_clear missing on i386 build
has been removed from the -mm tree.  Its filename was
     mm-x86-add-support-for-pud-sized-transparent-hugepages-fix.patch

This patch was dropped because it was folded into mm-x86-add-support-for-pud-sized-transparent-hugepages.patch

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm,x86: native_pud_clear missing on i386 build

Missing dummy function native_pud_clear() for 32bit x86 build caught
by 0-day build.

Fix: a10a1701 mm, x86: add support for PUD-sized transparent hugepages

Link: http://lkml.kernel.org/r/148640375195.69754.3315433724330910314.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/include/asm/pgtable-3level.h~mm-x86-add-support-for-pud-sized-transparent-hugepages-fix arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~mm-x86-add-support-for-pud-sized-transparent-hugepages-fix
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,6 +121,10 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
+static inline void native_pud_clear(pud_t *pudp)
+{
+}
+
 static inline void pud_clear(pud_t *pudp)
 {
 	set_pud(pudp, __pud(0));
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch
dax-support-for-transparent-pud-pages-for-device-dax.patch
mm-replace-fault_flag_size-with-parameter-to-huge_fault.patch

