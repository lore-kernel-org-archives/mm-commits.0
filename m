From: akpm@linux-foundation.org
Subject: [merged] mm-make-expand_downwards-symmetrical-with-expand_upwards.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:02 -0700
Message-ID: <201105252026.p4PKQPdg014493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1EYU07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, James.Bottomley@HansenPartnership.com, hughd@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm: make expand_downwards() symmetrical with expand_upwards()
has been removed from the -mm tree.  Its filename was
     mm-make-expand_downwards-symmetrical-with-expand_upwards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make expand_downwards() symmetrical with expand_upwards()
From: Michal Hocko <mhocko@suse.cz>

Currently we have expand_upwards exported while expand_downwards is
accessible only via expand_stack or expand_stack_downwards.

check_stack_guard_page is a nice example of the asymmetry.  It uses
expand_stack for VM_GROWSDOWN while expand_upwards is called for
VM_GROWSUP case.

Let's clean this up by exporting both functions and make those names
consistent.  Let's use expand_{upwards,downwards} because expanding
doesn't always involve stack manipulation (an example is
ia64_do_page_fault which uses expand_upwards for registers backing store
expansion).  expand_downwards has to be defined for both
CONFIG_STACK_GROWS{UP,DOWN} because get_arg_page calls the downwards
version in the early process initialization phase for growsup
configuration.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 +-
 include/linux/mm.h |    8 +++++---
 mm/memory.c        |    2 +-
 mm/mmap.c          |    7 +------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/exec.c~mm-make-expand_downwards-symmetrical-with-expand_upwards fs/exec.c
--- a/fs/exec.c~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/fs/exec.c
@@ -200,7 +200,7 @@ static struct page *get_arg_page(struct 
 
 #ifdef CONFIG_STACK_GROWSUP
 	if (write) {
-		ret = expand_stack_downwards(bprm->vma, pos);
+		ret = expand_downwards(bprm->vma, pos);
 		if (ret < 0)
 			return NULL;
 	}
diff -puN include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards include/linux/mm.h
--- a/include/linux/mm.h~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/include/linux/mm.h
@@ -1519,15 +1519,17 @@ unsigned long ra_submit(struct file_ra_s
 			struct address_space *mapping,
 			struct file *filp);
 
-/* Do stack extension */
+/* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
+
+/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+extern int expand_downwards(struct vm_area_struct *vma,
+		unsigned long address);
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
   #define expand_upwards(vma, address) do { } while (0)
 #endif
-extern int expand_stack_downwards(struct vm_area_struct *vma,
-				  unsigned long address);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
diff -puN mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards mm/memory.c
--- a/mm/memory.c~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/mm/memory.c
@@ -2966,7 +2966,7 @@ static inline int check_stack_guard_page
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack(vma, address - PAGE_SIZE);
+		expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
diff -puN mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards mm/mmap.c
--- a/mm/mmap.c~mm-make-expand_downwards-symmetrical-with-expand_upwards
+++ a/mm/mmap.c
@@ -1775,7 +1775,7 @@ int expand_upwards(struct vm_area_struct
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static int expand_downwards(struct vm_area_struct *vma,
+int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1822,11 +1822,6 @@ static int expand_downwards(struct vm_ar
 	return error;
 }
 
-int expand_stack_downwards(struct vm_area_struct *vma, unsigned long address)
-{
-	return expand_downwards(vma, address);
-}
