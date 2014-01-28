From: akpm@linux-foundation.org
Subject: +
 numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch added to -mm tree
Date: Tue, 28 Jan 2014 11:23:06 -0800
Message-ID: <52e8039a.VVpLjQU6k+V1t7bv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaA1TXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, guz.fnst@cn.fujitsu.com, davej@redhat.com, akpm@linux-foundation.org

Subject: + numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch added to -mm tree
To: akpm@linux-foundation.org,davej@redhat.com,guz.fnst@cn.fujitsu.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tangchen@cn.fujitsu.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:23:06 -0800


The patch titled
     Subject: numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix
has been added to the -mm tree.  Its filename is
     numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch

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
Subject: numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix

use NODE_MASK_NONE, per David

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix
+++ a/arch/x86/mm/numa.c
@@ -565,12 +565,10 @@ static void __init numa_init_array(void)
 static void __init numa_clear_kernel_node_hotplug(void)
 {
 	int i, nid;
-	nodemask_t numa_kernel_nodes;
+	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
-	nodes_clear(numa_kernel_nodes);
-
 	/* Mark all kernel nodes. */
 	for (i = 0; i < type->cnt; i++)
 		node_set(type->regions[i].nid, numa_kernel_nodes);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
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
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

