From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 13:52:31 -0800
Message-ID: <5641159f.5RXHGQyB3VLMBVIb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/profile.c: replace cpu_to_mem() with cpu_to_node()
has been removed from the -mm tree.  Its filename was
     kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: kernel/profile.c: replace cpu_to_mem() with cpu_to_node()

Function profile_cpu_callback() allocates memory without specifying
__GFP_THISNODE flag, so replace cpu_to_mem() with cpu_to_node() because
cpu_to_mem() may cause suboptimal memory allocation if there's no free
memory on the node returned by cpu_to_mem().

It's safe to use cpu_to_mem() because build_all_zonelists() also builds
suitable fallback zonelist for memoryless node.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/profile.c~kernel-profilec-replace-cpu_to_mem-with-cpu_to_node kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-replace-cpu_to_mem-with-cpu_to_node
+++ a/kernel/profile.c
@@ -336,7 +336,7 @@ static int profile_cpu_callback(struct n
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		node = cpu_to_mem(cpu);
+		node = cpu_to_node(cpu);
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
 			page = __alloc_pages_node(node,
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

