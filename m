From: akpm@linux-foundation.org
Subject: +
 mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch added to -mm tree
Date: Wed, 11 Feb 2015 14:06:38 -0800
Message-ID: <54dbd26e.aCmSARuJ4MT7DwwZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbbBKWGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 17:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andre.przywara@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix
has been added to the -mm tree.  Its filename is
     mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix

fix build with STRICT_MM_TYPECHECKS

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -259,7 +259,7 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 /* represent a notpresent pmd by zero, this is used by pmdp_invalidate */
 static inline pmd_t pmd_mknotpresent(pmd_t pmd)
 {
-	return 0;
+	return __pmd(0);
 }
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch

