From: akpm@linux-foundation.org
Subject: + parisc-set-memory-ranges-in-n_normal_memory-when-onlined.patch added to -mm tree
Date: Fri, 22 Apr 2011 13:29:12 -0700
Message-ID: <201104222029.p3MKTCur030477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab1DVU32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:29:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, James.Bottomley@hansenpartnership.com, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     parisc: set memory ranges in N_NORMAL_MEMORY when onlined
has been added to the -mm tree.  Its filename is
     parisc-set-memory-ranges-in-n_normal_memory-when-onlined.patch

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
Subject: parisc: set memory ranges in N_NORMAL_MEMORY when onlined
From: David Rientjes <rientjes@google.com>

When a DISCONTIGMEM memory range is brought online as a NUMA node, it also
needs to have its bet set in N_NORMAL_MEMORY.  This is necessary for
generic kernel code that utilizes N_NORMAL_MEMORY as a subset of N_ONLINE
for memory savings.

These types of hacks can hopefully be removed once DISCONTIGMEM is either
removed or abstracted away from CONFIG_NUMA.

Fixes a panic in the slub code which only initializes structures for
N_NORMAL_MEMORY to save memory:

	Backtrace:
	 [<000000004021c938>] add_partial+0x28/0x98
	 [<000000004021faa0>] __slab_free+0x1d0/0x1d8
	 [<000000004021fd04>] kmem_cache_free+0xc4/0x128
	 [<000000004033bf9c>] ida_get_new_above+0x21c/0x2c0
	 [<00000000402a8980>] sysfs_new_dirent+0xd0/0x238
	 [<00000000402a974c>] create_dir+0x5c/0x168
	 [<00000000402a9ab0>] sysfs_create_dir+0x98/0x128
	 [<000000004033d6c4>] kobject_add_internal+0x114/0x258
	 [<000000004033d9ac>] kobject_add_varg+0x7c/0xa0
	 [<000000004033df20>] kobject_add+0x50/0x90
	 [<000000004033dfb4>] kobject_create_and_add+0x54/0xc8
	 [<00000000407862a0>] cgroup_init+0x138/0x1f0
	 [<000000004077ce50>] start_kernel+0x5a0/0x840
	 [<000000004011fa3c>] start_parisc+0xa4/0xb8
	 [<00000000404bb034>] packet_ioctl+0x16c/0x208
	 [<000000004049ac30>] ip_mroute_setsockopt+0x260/0xf20

Tested-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/parisc/mm/init.c~parisc-set-memory-ranges-in-n_normal_memory-when-onlined arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~parisc-set-memory-ranges-in-n_normal_memory-when-onlined
+++ a/arch/parisc/mm/init.c
@@ -264,8 +264,10 @@ static void __init setup_bootmem(void)
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
-	for (i = 0; i < npmem_ranges; i++)
+	for (i = 0; i < npmem_ranges; i++) {
+		node_set_state(i, N_NORMAL_MEMORY);
 		node_set_online(i);
+	}
 #endif
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-use-pte-pages-in-oom-score.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
parisc-enable-config_numa-for-discontigmem-and-fix-build-errors.patch
parisc-set-memory-ranges-in-n_normal_memory-when-onlined.patch
alpha-mm-set-all-online-nodes-in-n_normal_memory.patch
m32r-mm-set-all-online-nodes-in-n_normal_memory.patch
m68k-mm-set-all-online-nodes-in-n_normal_memory.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

