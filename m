From: akpm@linux-foundation.org
Subject: + mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch added to -mm tree
Date: Thu, 26 May 2016 14:10:58 -0700
Message-ID: <57476662.QCE1Fc4dk7U1KhOc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbcEZVK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch

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
Subject: mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes

WARNING: line over 80 characters
#128: FILE: mm/cma.c:186:
+	alignment = PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order);

WARNING: line over 80 characters
#137: FILE: mm/cma.c:270:
+		(phys_addr_t)PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order));

total: 0 errors, 2 warnings, 16 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-cma-silence-warnings-due-to-max-usage.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/cma.c~mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes mm/cma.c
--- a/mm/cma.c~mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes
+++ a/mm/cma.c
@@ -183,7 +183,8 @@ int __init cma_init_reserved_mem(phys_ad
 		return -EINVAL;
 
 	/* ensure minimal alignment required by mm core */
-	alignment = PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order);
+	alignment = PAGE_SIZE <<
+			max_t(unsigned long, MAX_ORDER - 1, pageblock_order);
 
 	/* alignment should be aligned with order_per_bit */
 	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
@@ -266,8 +267,8 @@ int __init cma_declare_contiguous(phys_a
 	 * migratetype page by page allocator's buddy algorithm. In the case,
 	 * you couldn't get a contiguous memory, which is not what we want.
 	 */
-	alignment = max(alignment,
-		(phys_addr_t)PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
+	alignment = max(alignment,  (phys_addr_t)PAGE_SIZE <<
+			  max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

