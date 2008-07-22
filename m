From: akpm@linux-foundation.org
Subject: + mmapc-deinline-a-few-functions.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:35:32 -0700
Message-ID: <200807220935.m6M9ZW3I021147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbYGVJfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, hugh@veritas.com


The patch titled
     mmap.c: deinline a few functions
has been added to the -mm tree.  Its filename is
     mmapc-deinline-a-few-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -411,7 +411,7 @@ void __vma_link_rb(struct mm_struct *mm,
 	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
 }
 
-static inline void __vma_link_file(struct vm_area_struct *vma)
+static void __vma_link_file(struct vm_area_struct *vma)
 {
 	struct file * file;
 
@@ -1598,7 +1598,7 @@ out:
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
 #ifndef CONFIG_IA64
-static inline
+static
 #endif
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
@@ -1648,7 +1648,7 @@ int expand_upwards(struct vm_area_struct
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static inline int expand_downwards(struct vm_area_struct *vma,
+static int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1710,7 +1710,7 @@ find_extend_vma(struct mm_struct *mm, un
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (!prev || expand_stack(prev, addr))
+	if (expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		int nr_pages = mlock_vma_pages_range(prev, addr, prev->vm_end);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch
aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser.patch
aic7xxx-update-reg-files.patch
aic7xxx-update-_shipped-files.patch
mmapc-deinline-a-few-functions.patch

