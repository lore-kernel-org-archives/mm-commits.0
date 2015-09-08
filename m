From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:11 -0700
Message-ID: <55ef231b.bSkMBbIzJZr81voL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbbIHSEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: teach vma_merge to merge across vma->vm_userfaultfd_ctx
has been removed from the -mm tree.  Its filename was
     userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: teach vma_merge to merge across vma->vm_userfaultfd_ctx

vma->vm_userfaultfd_ctx is yet another vma parameter that vma_merge
must be aware about so that we can merge vmas back like they were
originally before arming the userfaultfd on some memory range.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/madvise.c       |    3 ++-
 mm/mempolicy.c     |    4 ++--
 mm/mlock.c         |    3 ++-
 mm/mmap.c          |   40 +++++++++++++++++++++++++++-------------
 mm/mprotect.c      |    3 ++-
 6 files changed, 36 insertions(+), 19 deletions(-)

diff -puN include/linux/mm.h~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx include/linux/mm.h
--- a/include/linux/mm.h~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/include/linux/mm.h
@@ -1835,7 +1835,7 @@ extern int vma_adjust(struct vm_area_str
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
-	struct mempolicy *);
+	struct mempolicy *, struct vm_userfaultfd_ctx);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int split_vma(struct mm_struct *,
 	struct vm_area_struct *, unsigned long addr, int new_below);
diff -puN mm/madvise.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx mm/madvise.c
--- a/mm/madvise.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/mm/madvise.c
@@ -103,7 +103,8 @@ static long madvise_behavior(struct vm_a
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, new_flags, vma->anon_vma,
-				vma->vm_file, pgoff, vma_policy(vma));
+			  vma->vm_file, pgoff, vma_policy(vma),
+			  vma->vm_userfaultfd_ctx);
 	if (*prev) {
 		vma = *prev;
 		goto success;
diff -puN mm/mempolicy.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx mm/mempolicy.c
--- a/mm/mempolicy.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/mm/mempolicy.c
@@ -722,8 +722,8 @@ static int mbind_range(struct mm_struct
 		pgoff = vma->vm_pgoff +
 			((vmstart - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, pgoff,
-				  new_pol);
+				 vma->anon_vma, vma->vm_file, pgoff,
+				 new_pol, vma->vm_userfaultfd_ctx);
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
diff -puN mm/mlock.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx mm/mlock.c
--- a/mm/mlock.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/mm/mlock.c
@@ -510,7 +510,8 @@ static int mlock_fixup(struct vm_area_st
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
-			  vma->vm_file, pgoff, vma_policy(vma));
+			  vma->vm_file, pgoff, vma_policy(vma),
+			  vma->vm_userfaultfd_ctx);
 	if (*prev) {
 		vma = *prev;
 		goto success;
diff -puN mm/mmap.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx mm/mmap.c
--- a/mm/mmap.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/mm/mmap.c
@@ -41,6 +41,7 @@
 #include <linux/notifier.h>
 #include <linux/memory.h>
 #include <linux/printk.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -919,7 +920,8 @@ again:			remove_next = 1 + (end > next->
  * per-vma resources, so we don't attempt to merge those.
  */
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
-			struct file *file, unsigned long vm_flags)
+				struct file *file, unsigned long vm_flags,
+				struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -935,6 +937,8 @@ static inline int is_mergeable_vma(struc
 		return 0;
 	if (vma->vm_ops && vma->vm_ops->close)
 		return 0;
+	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
+		return 0;
 	return 1;
 }
 
@@ -965,9 +969,11 @@ static inline int is_mergeable_anon_vma(
  */
 static int
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
-	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
+		     struct anon_vma *anon_vma, struct file *file,
+		     pgoff_t vm_pgoff,
+		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
 {
-	if (is_mergeable_vma(vma, file, vm_flags) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return 1;
@@ -984,9 +990,11 @@ can_vma_merge_before(struct vm_area_stru
  */
 static int
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
-	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
+		    struct anon_vma *anon_vma, struct file *file,
+		    pgoff_t vm_pgoff,
+		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
 {
-	if (is_mergeable_vma(vma, file, vm_flags) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
@@ -1029,7 +1037,8 @@ struct vm_area_struct *vma_merge(struct
 			struct vm_area_struct *prev, unsigned long addr,
 			unsigned long end, unsigned long vm_flags,
 			struct anon_vma *anon_vma, struct file *file,
-			pgoff_t pgoff, struct mempolicy *policy)
+			pgoff_t pgoff, struct mempolicy *policy,
+			struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
@@ -1056,14 +1065,17 @@ struct vm_area_struct *vma_merge(struct
 	if (prev && prev->vm_end == addr &&
 			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
-						anon_vma, file, pgoff)) {
+					    anon_vma, file, pgoff,
+					    vm_userfaultfd_ctx)) {
 		/*
 		 * OK, it can.  Can we now merge in the successor as well?
 		 */
 		if (next && end == next->vm_start &&
 				mpol_equal(policy, vma_policy(next)) &&
 				can_vma_merge_before(next, vm_flags,
-					anon_vma, file, pgoff+pglen) &&
+						     anon_vma, file,
+						     pgoff+pglen,
+						     vm_userfaultfd_ctx) &&
 				is_mergeable_anon_vma(prev->anon_vma,
 						      next->anon_vma, NULL)) {
 							/* cases 1, 6 */
@@ -1084,7 +1096,8 @@ struct vm_area_struct *vma_merge(struct
 	if (next && end == next->vm_start &&
 			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
-					anon_vma, file, pgoff+pglen)) {
+					     anon_vma, file, pgoff+pglen,
+					     vm_userfaultfd_ctx)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = vma_adjust(prev, prev->vm_start,
 				addr, prev->vm_pgoff, NULL);
@@ -1570,8 +1583,8 @@ unsigned long mmap_region(struct file *f
 	/*
 	 * Can we just expand an old mapping?
 	 */
-	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff,
-			NULL);
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
+			NULL, file, pgoff, NULL, NULL_VM_UFFD_CTX);
 	if (vma)
 		goto out;
 
@@ -2757,7 +2770,7 @@ static unsigned long do_brk(unsigned lon
 
 	/* Can we just expand an old private anonymous mapping? */
 	vma = vma_merge(mm, prev, addr, addr + len, flags,
-					NULL, NULL, pgoff, NULL);
+			NULL, NULL, pgoff, NULL, NULL_VM_UFFD_CTX);
 	if (vma)
 		goto out;
 
@@ -2913,7 +2926,8 @@ struct vm_area_struct *copy_vma(struct v
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
 		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
-			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
+			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
+			    vma->vm_userfaultfd_ctx);
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
diff -puN mm/mprotect.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx mm/mprotect.c
--- a/mm/mprotect.c~userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx
+++ a/mm/mprotect.c
@@ -292,7 +292,8 @@ mprotect_fixup(struct vm_area_struct *vm
 	 */
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*pprev = vma_merge(mm, *pprev, start, end, newflags,
-			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
+			   vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
+			   vma->vm_userfaultfd_ctx);
 	if (*pprev) {
 		vma = *pprev;
 		goto success;
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

