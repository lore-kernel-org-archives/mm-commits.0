From: akpm@linux-foundation.org
Subject: [folded-merged]
 numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch removed from -mm tree
Date: Tue, 04 Feb 2014 15:31:06 -0800
Message-ID: <52f1783a.wB+I+69OUYWBF3sg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaBDXbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 18:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, guz.fnst@cn.fujitsu.com, davej@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davej@redhat.com,guz.fnst@cn.fujitsu.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 15:31:06 -0800


The patch titled
     Subject: numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix
has been removed from the -mm tree.  Its filename was
     numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch

This patch was dropped because it was folded into numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

