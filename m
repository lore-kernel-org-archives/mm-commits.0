From: akpm@linux-foundation.org
Subject: +
 mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch added
 to -mm tree
Date: Wed, 15 Feb 2017 12:39:49 -0800
Message-ID: <58a4bc95.wUw3v0FZUCnAXeFL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOUju (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 15:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, alexander.kapshuk@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,x86: fix SMP x86 32bit build for native_pud_clear()
has been added to the -mm tree.  Its filename is
     mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch
mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch
mm-dax-move-pmd_fault-to-take-only-vmf-parameter.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mmfsdax-change-pmd_fault-to-huge_fault-fix.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages-fix.patch
mm-x86-add-support-for-pud-sized-transparent-hugepages-fix-fix.patch
dax-support-for-transparent-pud-pages-for-device-dax.patch
mm-replace-fault_flag_size-with-parameter-to-huge_fault.patch

