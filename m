From: akpm@linux-foundation.org
Subject: [folded-merged]
 sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch removed
 from -mm tree
Date: Wed, 31 Jan 2018 15:51:04 -0800
Message-ID: <5a725668.XBhzeZ/gJWILhxqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753756AbeAaXvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, davem@davemloft.net, kirill.shutemov@linux.intel.com, mhocko@kernel.org, nitin.m.gupta@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix
has been removed from the -mm tree.  Its filename was
     sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch

This patch was dropped because it was folded into sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix

add a `do' to the do-while loop

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitin Gupta <nitin.m.gupta@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/mm/tlb.c~sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix arch/sparc/mm/tlb.c
--- a/arch/sparc/mm/tlb.c~sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix
+++ a/arch/sparc/mm/tlb.c
@@ -224,7 +224,7 @@ static inline pmd_t pmdp_establish(struc
 {
 	pmd_t old;
 
-	{
+	do {
 		old = *pmdp;
 	} while (cmpxchg64(&pmdp->pmd, old.pmd, pmd.pmd) != old.pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

