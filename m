From: akpm@linux-foundation.org
Subject: + kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:35:58 -0700
Message-ID: <55d253be.s3DdF4FmTiWvA9On%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbHQVf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/profile.c: replace cpu_to_mem() with cpu_to_node()
has been added to the -mm tree.  Its filename is
     kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 			page = alloc_pages_exact_node(node,
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

linux-next.patch
x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition.patch
kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch
sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
i40e-use-numa_mem_id-to-better-support-memoryless-node.patch
i40evf-use-numa_mem_id-to-better-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

