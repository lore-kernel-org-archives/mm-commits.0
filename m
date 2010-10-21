From: akpm@linux-foundation.org
Subject: + mm-stack-based-kmap_atomic-fix2.patch added to -mm tree
Date: Thu, 21 Oct 2010 10:29:10 -0700
Message-ID: <201010211728.o9LHSm7a025617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab0JUR3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 13:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com


The patch titled
     mm, x86: Fix stack based kmap_atomic debug warnings
has been added to the -mm tree.  Its filename is
     mm-stack-based-kmap_atomic-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, x86: Fix stack based kmap_atomic debug warnings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Due to a massive brainfart I got the x86 kunmap_atomic debug code that
is supposed to avoid stack violations wrong.

Use the form all other architectures already use (which was also
independently suggested by Andrew).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    3 +--
 arch/x86/mm/iomap_32.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~mm-stack-based-kmap_atomic-fix2 arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-stack-based-kmap_atomic-fix2
+++ a/arch/x86/mm/highmem_32.c
@@ -78,8 +78,7 @@ void __kunmap_atomic(void *kvaddr)
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-		WARN_ON_ONCE(idx !=
-			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));
+		WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 #endif
 		/*
 		 * Force other mappings to Oops if they'll try to access this
diff -puN arch/x86/mm/iomap_32.c~mm-stack-based-kmap_atomic-fix2 arch/x86/mm/iomap_32.c
--- a/arch/x86/mm/iomap_32.c~mm-stack-based-kmap_atomic-fix2
+++ a/arch/x86/mm/iomap_32.c
@@ -102,8 +102,7 @@ iounmap_atomic(void __iomem *kvaddr)
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-		WARN_ON_ONCE(idx !=
-			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));
+		WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 #endif
 		/*
 		 * Force other mappings to Oops if they'll try to access this
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
softirq-cleanup-preempt-check.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-fix.patch
mm-stack-based-kmap_atomic-fix2.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
mm-retry-page-fault-when-blocking-on-disk-transfer-update.patch
mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix.patch
x86-access_error-api-cleanup.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
kernel-remove-pf_flusher.patch

