Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7BCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357434AbiCYBex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357514AbiCYBdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1963CBF950
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A29AB61948
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D06C340F5;
        Fri, 25 Mar 2022 01:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171892;
        bh=kuzE5O8gjiNaMnWxW9RGfB5RDEhZOFIKhcy1GPqrq+o=;
        h=Date:To:From:Subject:From;
        b=hAiCkRM0FFdA3Ys5eclSOTyeJTqLXDqYWXwkbsio+f9oGIKCoKFgcOMbvRdpNYJR9
         ztkQjA2fA1rBDrX9IEtldF6e+wFcX8qtAdlb4rofajFz9qZtYWWTv7R6ZGAxS0iFIi
         en3CPhjEiLQJmPOTk3ugEnldtopadoyq27aEFzIw=
Date:   Thu, 24 Mar 2022 18:31:31 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        raquini@redhat.com, mhocko@suse.com, dennis@kernel.org,
        david@redhat.com, dave.hansen@linux.intel.com,
        amakhalov@vmware.com, osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arch-x86-mm-numa-do-not-initialize-nodes-twice.patch removed from -mm tree
Message-Id: <20220325013132.09D06C340F5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/numa: Do not initialize nodes twice
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-numa-do-not-initialize-nodes-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/x86/mm/numa: Do not initialize nodes twice

On x86, prior to ("mm: handle uninitialized numa nodes gracecully"), NUMA
nodes could be allocated at three different places.

- numa_register_memblks
- init_cpu_to_node
- init_gi_nodes

All these calls happen at setup_arch, and have the following order:

setup_arch
  ...
  x86_numa_init
   numa_init
    numa_register_memblks
  ...
  init_cpu_to_node
   init_memory_less_node
    alloc_node_data
    free_area_init_memoryless_node
  init_gi_nodes
   init_memory_less_node
    alloc_node_data
    free_area_init_memoryless_node

numa_register_memblks() is only interested in those nodes which have
memory, so it skips over any memoryless node it founds.  Later on, when we
have read ACPI's SRAT table, we call init_cpu_to_node() and
init_gi_nodes(), which initialize any memoryless node we might have that
have either CPU or Initiator affinity, meaning we allocate pg_data_t
struct for them and we mark them as ONLINE.

So far so good, but the thing is that after ("mm: handle uninitialized
numa nodes gracefully"), we allocate all possible NUMA nodes in
free_area_init(), meaning we have a picture like the following:

setup_arch
  x86_numa_init
   numa_init
    numa_register_memblks  <-- allocate non-memoryless node
  x86_init.paging.pagetable_init
   ...
    free_area_init
     free_area_init_memoryless <-- allocate memoryless node
  init_cpu_to_node
   alloc_node_data             <-- allocate memoryless node with CPU
   free_area_init_memoryless_node
  init_gi_nodes
   alloc_node_data             <-- allocate memoryless node with Initiator
   free_area_init_memoryless_node

free_area_init() already allocates all possible NUMA nodes, but
init_cpu_to_node() and init_gi_nodes() are clueless about that, so they go
ahead and allocate a new pg_data_t struct without checking anything,
meaning we end up allocating twice.

It should be mad clear that this only happens in the case where memoryless
NUMA node happens to have a CPU/Initiator affinity.

So get rid of init_memory_less_node() and just set the node online.

Note that setting the node online is needed, otherwise we choke down the
chain when bringup_nonboot_cpus() ends up calling
__try_online_node()->register_one_node()->...  and we blow up in
bus_add_device().  As can be seen here:

==========
[    0.585060] BUG: kernel NULL pointer dereference, address: 0000000000000060
[    0.586091] #PF: supervisor read access in kernel mode
[    0.586831] #PF: error_code(0x0000) - not-present page
[    0.586930] PGD 0 P4D 0
[    0.586930] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
[    0.586930] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc4-1-default+ #45
[    0.586930] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/4
[    0.586930] RIP: 0010:bus_add_device+0x5a/0x140
[    0.586930] Code: 8b 74 24 20 48 89 df e8 84 96 ff ff 85 c0 89 c5 75 38 48 8b 53 50 48 85 d2 0f 84 bb 00 004
[    0.586930] RSP: 0000:ffffc9000022bd10 EFLAGS: 00010246
[    0.586930] RAX: 0000000000000000 RBX: ffff888100987400 RCX: ffff8881003e4e19
[    0.586930] RDX: ffff8881009a5e00 RSI: ffff888100987400 RDI: ffff888100987400
[    0.586930] RBP: 0000000000000000 R08: ffff8881003e4e18 R09: ffff8881003e4c98
[    0.586930] R10: 0000000000000000 R11: ffff888100402bc0 R12: ffffffff822ceba0
[    0.586930] R13: 0000000000000000 R14: ffff888100987400 R15: 0000000000000000
[    0.586930] FS:  0000000000000000(0000) GS:ffff88853fc00000(0000) knlGS:0000000000000000
[    0.586930] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.586930] CR2: 0000000000000060 CR3: 000000000200a001 CR4: 00000000001706b0
[    0.586930] Call Trace:
[    0.586930]  <TASK>
[    0.586930]  device_add+0x4c0/0x910
[    0.586930]  __register_one_node+0x97/0x2d0
[    0.586930]  __try_online_node+0x85/0xc0
[    0.586930]  try_online_node+0x25/0x40
[    0.586930]  cpu_up+0x4f/0x100
[    0.586930]  bringup_nonboot_cpus+0x4f/0x60
[    0.586930]  smp_init+0x26/0x79
[    0.586930]  kernel_init_freeable+0x130/0x2f1
[    0.586930]  ? rest_init+0x100/0x100
[    0.586930]  kernel_init+0x17/0x150
[    0.586930]  ? rest_init+0x100/0x100
[    0.586930]  ret_from_fork+0x22/0x30
[    0.586930]  </TASK>
[    0.586930] Modules linked in:
[    0.586930] CR2: 0000000000000060
[    0.586930] ---[ end trace 0000000000000000 ]---
==========

The reason is simple, by the time bringup_nonboot_cpus() gets called, we
did not register the node_subsys bus yet, so we crash when
bus_add_device() tries to dereference bus()->p.

The following shows the order of the calls:

kernel_init_freeable
 smp_init
  bringup_nonboot_cpus
   ...
     bus_add_device()      <- we did not register node_subsys yet
 do_basic_setup
  do_initcalls
   postcore_initcall(register_node_type);
    register_node_type
     subsys_system_register
      subsys_register
       bus_register         <- register node_subsys bus

Why setting the node online saves us then?  Well, simply because
__try_online_node() backs off when the node is online, meaning we do not
end up calling register_one_node() in the first place.

This is subtle, broken and deserves a deep analysis and thought about how
to put this into shape, but for now let us have this easy fix for the
leaking memory issue.

[osalvador@suse.de: add comments]
  Link: https://lkml.kernel.org/r/20220221142649.3457-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20220218224302.5282-2-osalvador@suse.de
Fixes: da4490c958ad ("mm: handle uninitialized numa nodes gracefully")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   33 ++++++++++++++++++++-------------
 include/linux/mm.h |    1 -
 mm/page_alloc.c    |    2 +-
 3 files changed, 21 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/numa.c~arch-x86-mm-numa-do-not-initialize-nodes-twice
+++ a/arch/x86/mm/numa.c
@@ -738,17 +738,6 @@ void __init x86_numa_init(void)
 	numa_init(dummy_numa_init);
 }
 
-static void __init init_memory_less_node(int nid)
-{
-	/* Allocate and initialize node data. Memory-less node is now online.*/
-	alloc_node_data(nid);
-	free_area_init_memoryless_node(nid);
-
-	/*
-	 * All zonelists will be built later in start_kernel() after per cpu
-	 * areas are initialized.
-	 */
-}
 
 /*
  * A node may exist which has one or more Generic Initiators but no CPUs and no
@@ -766,9 +755,18 @@ void __init init_gi_nodes(void)
 {
 	int nid;
 
+	/*
+	 * Exclude this node from
+	 * bringup_nonboot_cpus
+	 *  cpu_up
+	 *   __try_online_node
+	 *    register_one_node
+	 * because node_subsys is not initialized yet.
+	 * TODO remove dependency on node_online
+	 */
 	for_each_node_state(nid, N_GENERIC_INITIATOR)
 		if (!node_online(nid))
-			init_memory_less_node(nid);
+			node_set_online(nid);
 }
 
 /*
@@ -798,8 +796,17 @@ void __init init_cpu_to_node(void)
 		if (node == NUMA_NO_NODE)
 			continue;
 
+		/*
+		 * Exclude this node from
+		 * bringup_nonboot_cpus
+		 *  cpu_up
+		 *   __try_online_node
+		 *    register_one_node
+		 * because node_subsys is not initialized yet.
+		 * TODO remove dependency on node_online
+		 */
 		if (!node_online(node))
-			init_memory_less_node(node);
+			node_set_online(node);
 
 		numa_set_node(cpu, node);
 	}
--- a/include/linux/mm.h~arch-x86-mm-numa-do-not-initialize-nodes-twice
+++ a/include/linux/mm.h
@@ -2449,7 +2449,6 @@ static inline spinlock_t *pud_lock(struc
 }
 
 extern void __init pagecache_init(void);
-extern void __init free_area_init_memoryless_node(int nid);
 extern void free_initmem(void);
 
 /*
--- a/mm/page_alloc.c~arch-x86-mm-numa-do-not-initialize-nodes-twice
+++ a/mm/page_alloc.c
@@ -7626,7 +7626,7 @@ static void __init free_area_init_node(i
 	free_area_init_core(pgdat);
 }
 
-void __init free_area_init_memoryless_node(int nid)
+static void __init free_area_init_memoryless_node(int nid)
 {
 	free_area_init_node(nid);
 }
_

Patches currently in -mm which might be from osalvador@suse.de are


