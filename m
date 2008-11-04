From: akpm@linux-foundation.org
Subject: + fs-execc-__bprm_mm_init-clean-up-error-handling.patch added to -mm tree
Date: Tue, 04 Nov 2008 10:58:37 -0800
Message-ID: <200811041858.mA4Iwc7A002734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYKDS71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 13:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lcapitulino@mandriva.com.br


The patch titled
     fs/exec.c:__bprm_mm_init(): clean up error handling
has been added to the -mm tree.  Its filename is
     fs-execc-__bprm_mm_init-clean-up-error-handling.patch

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
Subject: fs/exec.c:__bprm_mm_init(): clean up error handling
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>

Untangle the error unwinding in this function, saving a test of local
variable `vma'.

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~fs-execc-__bprm_mm_init-clean-up-error-handling fs/exec.c
--- a/fs/exec.c~fs-execc-__bprm_mm_init-clean-up-error-handling
+++ a/fs/exec.c
@@ -233,13 +233,13 @@ static void flush_arg_page(struct linux_
 
 static int __bprm_mm_init(struct linux_binprm *bprm)
 {
-	int err = -ENOMEM;
+	int err;
 	struct vm_area_struct *vma = NULL;
 	struct mm_struct *mm = bprm->mm;
 
 	bprm->vma = vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
-		goto err;
+		return -ENOMEM;
 
 	down_write(&mm->mmap_sem);
 	vma->vm_mm = mm;
@@ -252,28 +252,20 @@ static int __bprm_mm_init(struct linux_b
 	 */
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
-
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	err = insert_vm_struct(mm, vma);
-	if (err) {
-		up_write(&mm->mmap_sem);
+	if (err)
 		goto err;
-	}
 
 	mm->stack_vm = mm->total_vm = 1;
 	up_write(&mm->mmap_sem);
-
 	bprm->p = vma->vm_end - sizeof(void *);
-
 	return 0;
-
 err:
-	if (vma) {
-		bprm->vma = NULL;
-		kmem_cache_free(vm_area_cachep, vma);
-	}
