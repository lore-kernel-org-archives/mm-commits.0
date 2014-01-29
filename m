From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch added to -mm tree
Date: Wed, 29 Jan 2014 13:10:57 -0800
Message-ID: <52e96e61.8vfCBdeDoD0y1F2j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaA2VK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 16:10:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 13:10:57 -0800


The patch titled
     Subject: mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch

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
Subject: mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix

fix CONFIG_HIGHMEM build

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix
+++ a/mm/page-writeback.c
@@ -217,10 +217,9 @@ static unsigned long highmem_dirtyable_m
 	unsigned long x = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z =
-			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_dirtyable_memory(zone);
+		x += zone_dirtyable_memory(z);
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch
mm-mempolicyc-convert-to-pr_foo.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
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

