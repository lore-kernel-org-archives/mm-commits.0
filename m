From: akpm@linux-foundation.org
Subject: + mm-make-expand_downwards-symmetrical-with-expand_upwards.patch added to -mm tree
Date: Mon, 18 Apr 2011 13:56:42 -0700
Message-ID: <201104182056.p3IKugne024313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab1DRU5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 16:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hughd@google.com


The patch titled
     mm: make expand_downwards() symmetrical with expand_upwards()
has been added to the -mm tree.  Its filename is
     mm-make-expand_downwards-symmetrical-with-expand_upwards.patch

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
Subject: mm: make expand_downwards() symmetrical with expand_upwards()
From: Michal Hocko <mhocko@suse.cz>

Currently we have expand_upwards() exported while expand_downwards() is
accessible only via expand_stack() or expand_stack_downwards().

check_stack_guard_page() is a nice example of the asymmetry.  It uses
expand_stack for VM_GROWSDOWN while expand_upwards is called for
VM_GROWSUP case.

Let's clean this up by exporting both functions and make those name
consistent.  Let's use expand_stack_{upwards,downwards} so that we are
explicit about stack manipulation in the name.  expand_stack_downwards has
to be defined for both CONFIG_STACK_GROWS{UP,DOWN} because get_arg_page
calls the downwards version in the early process initialization phase for
growsup configuration.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 ++++++++-----
 mm/memory.c        |    4 ++--
 mm/mmap.c          |   13 ++++---------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff -puN include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards include/linux/mm.h
--- a/include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/include/linux/mm.h
@@ -1496,15 +1496,18 @@ unsigned long ra_submit(struct file_ra_s
 			struct address_space *mapping,
 			struct file *filp);
 
-/* Do stack extension */
+/* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
+
+/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+extern int expand_stack_downwards(struct vm_area_struct *vma,
+		unsigned long address);
 #if VM_GROWSUP
-extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
+extern int expand_stack_upwards(struct vm_area_struct *vma,
+		unsigned long address);
 #else
-  #define expand_upwards(vma, address) do { } while (0)
+  #define expand_stack_upwards(vma, address) do { } while (0)
 #endif
-extern int expand_stack_downwards(struct vm_area_struct *vma,
-				  unsigned long address);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
diff -puN mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards mm/memory.c
--- a/mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/mm/memory.c
@@ -2969,7 +2969,7 @@ static inline int check_stack_guard_page
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack(vma, address - PAGE_SIZE);
+		expand_stack_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -2978,7 +2978,7 @@ static inline int check_stack_guard_page
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_upwards(vma, address + PAGE_SIZE);
+		expand_stack_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }
diff -puN mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards mm/mmap.c
--- a/mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/mm/mmap.c
@@ -1721,7 +1721,7 @@ static int acct_stack_growth(struct vm_a
  * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
-int expand_upwards(struct vm_area_struct *vma, unsigned long address)
+int expand_stack_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	int error;
 
@@ -1772,7 +1772,7 @@ int expand_upwards(struct vm_area_struct
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static int expand_downwards(struct vm_area_struct *vma,
+int expand_stack_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1819,15 +1819,10 @@ static int expand_downwards(struct vm_ar
 	return error;
 }
 
-int expand_stack_downwards(struct vm_area_struct *vma, unsigned long address)
-{
-	return expand_downwards(vma, address);
-}
-
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_upwards(vma, address);
+	return expand_stack_upwards(vma, address);
 }
 
 struct vm_area_struct *
@@ -1849,7 +1844,7 @@ find_extend_vma(struct mm_struct *mm, un
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_downwards(vma, address);
+	return expand_stack_downwards(vma, address);
 }
 
 struct vm_area_struct *
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-make-expand_downwards-symmetrical-with-expand_upwards.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

