From: akpm@linux-foundation.org
Subject: [failures] fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch removed from -mm tree
Date: Wed, 15 Jun 2011 21:53:10 -0700
Message-ID: <201106160453.p5G4r20u007461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab1FPExi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jun 2011 00:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mel@csn.ul.ie, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
has been removed from the -mm tree.  Its filename was
     fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
From: Michal Hocko <mhocko@suse.cz>

a8bef8ff ("mm: migration: avoid race between shift_arg_pages() and
rmap_walk() during migration by not migrating temporary stacks")
introduced a BUG_ON() to ensure that VM_STACK_FLAGS and
VM_STACK_INCOMPLETE_SETUP do not overlap.  The check is a compile time
one, so BUILD_BUG_ON is more appropriate.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup fs/exec.c
--- a/fs/exec.c~fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup
+++ a/fs/exec.c
@@ -277,7 +277,7 @@ static int __bprm_mm_init(struct linux_b
 	 * use STACK_TOP because that can depend on attributes which aren't
 	 * configured yet.
 	 */
-	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
+	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-compaction-fix-special-case-1-order-checks.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-v6.patch
memcg-avoid-percpu-cached-charge-draining-at-softlimit.patch
mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone.patch
mm-vmscan-do-not-use-page_count-without-a-page-pin.patch
mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2.patch
mm-remove-the-leftovers-of-noswapaccount.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

