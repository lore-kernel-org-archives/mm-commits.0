From: akpm@linux-foundation.org
Subject: - mmapc-deinline-a-few-functions.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:39 -0700
Message-ID: <200810202033.m9KKXdgG010674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbYJTUeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mmap.c: deinline a few functions
has been removed from the -mm tree.  Its filename was
     mmapc-deinline-a-few-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap.c: deinline a few functions
From: Denys Vlasenko <vda.linux@googlemail.com>

__vma_link_file and expand_downwards functions are not small, yeat they
are marked inline.  They probably had one callsite sometime in the past,
but now they have more.  In order to prevent similar thing, I also
deinlined expand_upwards, despite it having only pne callsite.  Nowadays
gcc auto-inlines such static functions anyway.  In find_extend_vma, I
removed one extra level of indirection.

Patch is deliberately generated with -U $BIGNUM to make
it easier to see that functions are big.

Result:

# size */*/mmap.o */vmlinux
   text    data     bss     dec     hex filename
   9514     188      16    9718    25f6 0.org/mm/mmap.o
   9237     188      16    9441    24e1 deinline/mm/mmap.o
6124402  858996  389480 7372878  70804e 0.org/vmlinux
6124113  858996  389480 7372589  707f2d deinline/vmlinux

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mmapc-deinline-a-few-functions mm/mmap.c
--- a/mm/mmap.c~mmapc-deinline-a-few-functions
+++ a/mm/mmap.c
@@ -410,7 +410,7 @@ void __vma_link_rb(struct mm_struct *mm,
 	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
 }
 
-static inline void __vma_link_file(struct vm_area_struct *vma)
+static void __vma_link_file(struct vm_area_struct *vma)
 {
 	struct file * file;
 
@@ -1591,7 +1591,7 @@ static int acct_stack_growth(struct vm_a
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
 #ifndef CONFIG_IA64
-static inline
+static
 #endif
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
@@ -1641,7 +1641,7 @@ int expand_upwards(struct vm_area_struct
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static inline int expand_downwards(struct vm_area_struct *vma,
+static int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1703,7 +1703,7 @@ find_extend_vma(struct mm_struct *mm, un
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (!prev || expand_stack(prev, addr))
+	if (expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

