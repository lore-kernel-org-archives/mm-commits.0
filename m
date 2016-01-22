From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 21 Jan 2016 17:17:52 -0800
Message-ID: <56a18340.Dxof/I1b/fJuPCdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcAVBRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 20:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the powerpc tree

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in:

  arch/powerpc/include/asm/pgtable.h

between commit:

  ee4889c7bc2a ("powerpc/mm: Don't have generic headers introduce functions touching pte bits")

from the powerpc tree and commit:

  e0e8474c0d55 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")

from the akpm-current tree.

I fixed it up (the code being changed was moved from this file - I added
the fix up patch below) and can carry the fix as necessary (no action
is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Dec 2015 16:30:47 +1100
Subject: [PATCH] mm, dax, gpu: merge fix for convert vm_insert_mixed to pfn_t

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

index 38b33dcfcc9d..3ed3303c1295 100644
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the powerpc tree

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in:

  arch/powerpc/include/asm/pgtable.h

between commit:

  ee4889c7bc2a ("powerpc/mm: Don't have generic headers introduce functions touching pte bits")

from the powerpc tree and commit:

  e0e8474c0d55 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")

from the akpm-current tree.

I fixed it up (the code being changed was moved from this file - I added
the fix up patch below) and can carry the fix as necessary (no action
is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Dec 2015 16:30:47 +1100
Subject: [PATCH] mm, dax, gpu: merge fix for convert vm_insert_mixed to pfn_t

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

index 38b33dcfcc9d..3ed3303c1295 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile               |    1 +
 net/mac80211/debugfs.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN Makefile~linux-next-rejects Makefile
--- a/Makefile~linux-next-rejects
+++ a/Makefile
@@ -800,6 +800,7 @@ endif
 
 include scripts/Makefile.kasan
 include scripts/Makefile.extrawarn
+include scripts/Makefile.lto
 include scripts/Makefile.ubsan
 
 # Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLAGS as the
diff -puN net/mac80211/debugfs.c~linux-next-rejects net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c~linux-next-rejects
+++ a/net/mac80211/debugfs.c
@@ -126,6 +126,7 @@ static const char *hw_flag_names[] = {
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),
 	FLAG(NEEDS_UNIQUE_STA_ADDR),
+	FLAG(SUPPORTS_REORDERING_BUFFER),
 #undef FLAG
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

