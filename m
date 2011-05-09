From: akpm@linux-foundation.org
Subject: + mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch added to -mm tree
Date: Mon, 09 May 2011 13:03:24 -0700
Message-ID: <201105092003.p49K3P7x014768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550Ab1EIUDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, James.Bottomley@HansenPartnership.com, hughd@google.com, tony.luck@intel.com


The patch titled
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
has been added to the -mm tree.  Its filename is
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch

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
Subject: mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
From: Michal Hocko <mhocko@suse.cz>

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c |    2 +-
 fs/exec.c            |    2 +-
 include/linux/mm.h   |    7 +++----
 mm/memory.c          |    4 ++--
 mm/mmap.c            |    8 ++++----
 5 files changed, 11 insertions(+), 12 deletions(-)

diff -puN arch/ia64/mm/fault.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4 arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
+++ a/arch/ia64/mm/fault.c
@@ -197,7 +197,7 @@ ia64_do_page_fault (unsigned long addres
 		 */
 		if (address > vma->vm_end + PAGE_SIZE - sizeof(long))
 			goto bad_area;
-		if (expand_stack_upwards(vma, address))
+		if (expand_upwards(vma, address))
 			goto bad_area;
 	}
 	goto good_area;
diff -puN fs/exec.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4 fs/exec.c
--- a/fs/exec.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
+++ a/fs/exec.c
@@ -194,7 +194,7 @@ struct page *get_arg_page(struct linux_b
 
 #ifdef CONFIG_STACK_GROWSUP
 	if (write) {
-		ret = expand_stack_downwards(bprm->vma, pos);
+		ret = expand_downwards(bprm->vma, pos);
 		if (ret < 0)
 			return NULL;
 	}
diff -puN include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4 include/linux/mm.h
--- a/include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
+++ a/include/linux/mm.h
@@ -1501,13 +1501,12 @@ unsigned long ra_submit(struct file_ra_s
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 
 /* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
-extern int expand_stack_downwards(struct vm_area_struct *vma,
+extern int expand_downwards(struct vm_area_struct *vma,
 		unsigned long address);
 #if VM_GROWSUP
-extern int expand_stack_upwards(struct vm_area_struct *vma,
-		unsigned long address);
+extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
-  #define expand_stack_upwards(vma, address) do { } while (0)
+  #define expand_upwards(vma, address) do { } while (0)
 #endif
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
diff -puN mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4 mm/memory.c
--- a/mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
+++ a/mm/memory.c
@@ -2968,7 +2968,7 @@ static inline int check_stack_guard_page
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack_downwards(vma, address - PAGE_SIZE);
+		expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -2977,7 +2977,7 @@ static inline int check_stack_guard_page
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_stack_upwards(vma, address + PAGE_SIZE);
+		expand_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }
diff -puN mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4 mm/mmap.c
--- a/mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
+++ a/mm/mmap.c
@@ -1721,7 +1721,7 @@ static int acct_stack_growth(struct vm_a
  * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
-int expand_stack_upwards(struct vm_area_struct *vma, unsigned long address)
+int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	int error;
 
@@ -1772,7 +1772,7 @@ int expand_stack_upwards(struct vm_area_
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-int expand_stack_downwards(struct vm_area_struct *vma,
+int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1822,7 +1822,7 @@ int expand_stack_downwards(struct vm_are
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_stack_upwards(vma, address);
+	return expand_upwards(vma, address);
 }
 
 struct vm_area_struct *
@@ -1844,7 +1844,7 @@ find_extend_vma(struct mm_struct *mm, un
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_stack_downwards(vma, address);
+	return expand_downwards(vma, address);
 }
 
 struct vm_area_struct *
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-make-expand_downwards-symmetrical-with-expand_upwards.patch
mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

