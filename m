From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
 removed from -mm tree
Date: Mon, 12 Sep 2016 15:19:12 -0700
Message-ID: <57d729e0.ZrC/RtgwVxGmNQa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51227 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754928AbcILWTN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 18:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check that we haven't used more than 32 bits in address_space.flags
has been removed from the -mm tree.  Its filename was
     mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: check that we haven't used more than 32 bits in address_space.flags

After "mm: don't use radix tree writeback tags for pages in swap cache",
all the flags are now used up on 32-bit builds.

Add a build-time assertion to prevent 64-bit developers from accidentally
breaking things.

Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 init/main.c             |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN include/linux/pagemap.h~mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags
+++ a/include/linux/pagemap.h
@@ -27,6 +27,8 @@ enum mapping_flags {
 	AS_EXITING	= __GFP_BITS_SHIFT + 4, /* final truncate in progress */
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = __GFP_BITS_SHIFT + 5,
+
+	AS_LAST_FLAG,
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
diff -puN init/main.c~mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags init/main.c
--- a/init/main.c~mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags
+++ a/init/main.c
@@ -59,6 +59,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
@@ -463,6 +464,9 @@ void __init __weak thread_stack_cache_in
  */
 static void __init mm_init(void)
 {
+	/* Does address_space.flags still fit into a 32-bit ulong? */
+	BUILD_BUG_ON(AS_LAST_FLAG > 32);
+
 	/*
 	 * page_ext requires contiguous pages,
 	 * bigger than MAX_ORDER unless SPARSEMEM.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

