From: akpm@linux-foundation.org
Subject: + fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch added to -mm tree
Date: Fri, 17 Jun 2011 14:26:30 -0700
Message-ID: <201106172126.p5HLQUpX001874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab1FQV1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 17:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, mel@csn.ul.ie, richard@nod.at


The patch titled
     fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
has been added to the -mm tree.  Its filename is
     fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

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

origin.patch
mm-remove-the-leftovers-of-noswapaccount.patch
um-clean-up-vm-flagsh.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

