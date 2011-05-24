From: akpm@linux-foundation.org
Subject: [folded] mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch removed from -mm tree
Date: Tue, 24 May 2011 16:53:47 -0700
Message-ID: <201105242353.p4ONrlqi023741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933268Ab1EXXxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, James.Bottomley@HansenPartnership.com, hughd@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v4
has been removed from the -mm tree.  Its filename was
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch

This patch was dropped because it was folded into mm-make-expand_downwards-symmetrical-with-expand_upwards.patch

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
@@ -1523,13 +1523,12 @@ unsigned long ra_submit(struct file_ra_s
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
@@ -2966,7 +2966,7 @@ static inline int check_stack_guard_page
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack_downwards(vma, address - PAGE_SIZE);
+		expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -2975,7 +2975,7 @@ static inline int check_stack_guard_page
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
 
@@ -1775,7 +1775,7 @@ int expand_stack_upwards(struct vm_area_
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-int expand_stack_downwards(struct vm_area_struct *vma,
+int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1825,7 +1825,7 @@ int expand_stack_downwards(struct vm_are
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_stack_upwards(vma, address);
+	return expand_upwards(vma, address);
 }
 
 struct vm_area_struct *
@@ -1847,7 +1847,7 @@ find_extend_vma(struct mm_struct *mm, un
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
memsw-remove-noswapaccount-kernel-parameter.patch

