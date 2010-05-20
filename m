From: akpm@linux-foundation.org
Subject: + percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch added to -mm tree
Date: Thu, 20 May 2010 13:44:56 -0700
Message-ID: <201005202044.o4KKiup1004227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab0ETUpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 16:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaohong.guo@intel.com, andi@firstfloor.org, prarit@redhat.com, stable@kernel.org, tj@kernel.org


The patch titled
     percpu: online CPU before memory failed in pcpu_alloc_pages()
has been added to the -mm tree.  Its filename is
     percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch

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
Subject: percpu: online CPU before memory failed in pcpu_alloc_pages()
From: minskey guo <chaohong.guo@intel.com>

The operation of "enable CPU to online before memory within a node"
fails in some case according to Prarit. The warnings as follows:

Pid: 7440, comm: bash Not tainted 2.6.32 #2
Call Trace:
 [<ffffffff81155985>] pcpu_alloc+0xa05/0xa70
 [<ffffffff81155a20>] __alloc_percpu+0x10/0x20
 [<ffffffff81089605>] __create_workqueue_key+0x75/0x280
 [<ffffffff8110e050>] ? __build_all_zonelists+0x0/0x5d0
 [<ffffffff810c1eba>] stop_machine_create+0x3a/0xb0
 [<ffffffff810c1f57>] stop_machine+0x27/0x60
 [<ffffffff8110f1a0>] build_all_zonelists+0xd0/0x2b0
 [<ffffffff814c1d12>] cpu_up+0xb3/0xe3
 [<ffffffff814b3c40>] store_online+0x70/0xa0
 [<ffffffff81326100>] sysdev_store+0x20/0x30
 [<ffffffff811d29a5>] sysfs_write_file+0xe5/0x170
 [<ffffffff81163d28>] vfs_write+0xb8/0x1a0
 [<ffffffff810cfd22>] ? audit_syscall_entry+0x252/0x280
 [<ffffffff81164761>] sys_write+0x51/0x90
 [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 12331603
PERCPU: allocation failed, size=128 align=64, failed to populate

With "enable CPU to online before memory" patch, when the 1st CPU of
an offlined node is being onlined, we build zonelists for that node.
If per-cpu area needs to be extended during zonelists building period,
alloc_pages_node() will be called. The routine alloc_pages_node() fails
on the node in-onlining because the node doesn't have zonelists created
yet.

To fix this issue,  we try to alloc memory from current node.

Signed-off-by: minskey guo <chaohong.guo@intel.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>		[same patch, to mm/percpu.c]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN mm/percpu-vm.c~percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages mm/percpu-vm.c
--- a/mm/percpu-vm.c~percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages
+++ a/mm/percpu-vm.c
@@ -110,13 +110,29 @@ static int pcpu_alloc_pages(struct pcpu_
 {
 	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
 	unsigned int cpu;
+	int nid;
 	int i;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			nid = cpu_to_node(cpu);
+
+			/*
+			 * It is allowable to online a CPU within a NUMA
+			 * node which doesn't have onlined local memory.
+			 * In this case, we need to create zonelists for
+			 * that node when cpu is being onlined. If per-cpu
+			 * area needs to be extended at the exact time when
+			 * zonelists of that node is being created, we alloc
+			 * memory from current node.
+			 */
+			if ((nid == -1) ||
+			    !(node_zonelist(nid, GFP_KERNEL)->_zonerefs->zone))
+				nid = numa_node_id();
+
+			*pagep = alloc_pages_node(nid, gfp, 0);
 			if (!*pagep) {
 				pcpu_free_pages(chunk, pages, populated,
 						page_start, page_end);
_

Patches currently in -mm which might be from chaohong.guo@intel.com are

percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch

