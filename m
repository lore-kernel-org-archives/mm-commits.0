From: akpm@linux-foundation.org
Subject: + arm-arch-arm-include-asm-pageh-needs-personalityh.patch added
 to -mm tree
Date: Wed, 27 Jan 2016 13:32:45 -0800
Message-ID: <56a9377d.yjDoBpvonW/dGJ2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965818AbcA0Vcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 16:32:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koct9i@gmail.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: arch/arm/include/asm/page.h needs personality.h
has been added to the -mm tree.  Its filename is
     arm-arch-arm-include-asm-pageh-needs-personalityh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-arch-arm-include-asm-pageh-needs-personalityh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-arch-arm-include-asm-pageh-needs-personalityh.patch

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
Subject: arm: arch/arm/include/asm/page.h needs personality.h

VM_DATA_DEFAULT_FLAGS uses READ_IMPLIES_EXEC, so page.h should include
personality.h to provide this.

This is needed for "mm: warn about VmData over RLIMIT_DATA".

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/page.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/arm/include/asm/page.h~arm-arch-arm-include-asm-pageh-needs-personalityh arch/arm/include/asm/page.h
--- a/arch/arm/include/asm/page.h~arm-arch-arm-include-asm-pageh-needs-personalityh
+++ a/arch/arm/include/asm/page.h
@@ -10,6 +10,8 @@
 #ifndef _ASMARM_PAGE_H
 #define _ASMARM_PAGE_H
 
+#include <linux/personality.h>	/* For READ_IMPLIES_EXEC */
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

