From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 12:36:36 -0800
Message-ID: <52ec0954.3mFNy3zmG2FtRJpf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaAaUgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 15:36:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, hughd@google.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hughd@google.com,weijie.yang@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 12:36:36 -0800


The patch titled
     Subject: mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch

This patch was dropped because it was folded into mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix

tidy up code comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix
+++ a/mm/swapfile.c
@@ -1949,10 +1949,10 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	filp_close(swap_file, NULL);
 
 	/*
-	* clear SWP_USED flag after all resources freed
-	* so that swapon can reuse this swap_info in alloc_swap_info() safely
-	* it is ok to not hold p->lock after we cleared its SWP_WRITEOK
-	*/
+	 * Clear the SWP_USED flag after all resources are freed so that swapon
+	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
+	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 */
 	spin_lock(&swap_lock);
 	p->flags = 0;
 	spin_unlock(&swap_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

