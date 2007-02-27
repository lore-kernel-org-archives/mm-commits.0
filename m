From: akpm@linux-foundation.org
Subject: + ia64-permon-use-after-free-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:36:26 -0800
Message-ID: <200702272036.l1RKaUc2027601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096AbXB0UnA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, eranian@hpl.hp.com, tony.luck@intel.com


The patch titled
     ia64: permon use-after-free fix
has been added to the -mm tree.  Its filename is
     ia64-permon-use-after-free-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: permon use-after-free fix
From: Nick Piggin <npiggin@suse.de>

Perfmon associates vmalloc()ed memory with a file descriptor, and installs
a vma mapping that memory.  Unfortunately, the vm_file field is not filled
in, so processes with mappings to that memory do not prevent the file from
being closed and the memory freed.  This results in use-after-free bugs and
multiple freeing of pages, etc.

I saw this bug on an Altix on SLES9.  Haven't reproduced upstream but it
looks like the same issue is there.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~ia64-permon-use-after-free-fix arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-permon-use-after-free-fix
+++ a/arch/ia64/kernel/perfmon.c
@@ -2299,7 +2299,7 @@ pfm_remap_buffer(struct vm_area_struct *
  * allocate a sampling buffer and remaps it into the user address space of the task
  */
 static int
-pfm_smpl_buffer_alloc(struct task_struct *task, pfm_context_t *ctx, unsigned long rsize, void **user_vaddr)
+pfm_smpl_buffer_alloc(struct task_struct *task, struct file *filp, pfm_context_t *ctx, unsigned long rsize, void **user_vaddr)
 {
 	struct mm_struct *mm = task->mm;
 	struct vm_area_struct *vma = NULL;
@@ -2349,6 +2349,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 * partially initialize the vma for the sampling buffer
 	 */
 	vma->vm_mm	     = mm;
+	vma->vm_file	     = filp;
 	vma->vm_flags	     = VM_READ| VM_MAYREAD |VM_RESERVED;
 	vma->vm_page_prot    = PAGE_READONLY; /* XXX may need to change */
 
@@ -2387,6 +2388,8 @@ pfm_smpl_buffer_alloc(struct task_struct
 		goto error;
 	}
 
+	get_file(filp);
+
 	/*
 	 * now insert the vma in the vm list for the process, must be
 	 * done with mmap lock held
@@ -2464,7 +2467,7 @@ pfarg_is_sane(struct task_struct *task, 
 }
 
 static int
-pfm_setup_buffer_fmt(struct task_struct *task, pfm_context_t *ctx, unsigned int ctx_flags,
+pfm_setup_buffer_fmt(struct task_struct *task, struct file *filp, pfm_context_t *ctx, unsigned int ctx_flags,
 		     unsigned int cpu, pfarg_context_t *arg)
 {
 	pfm_buffer_fmt_t *fmt = NULL;
@@ -2505,7 +2508,7 @@ pfm_setup_buffer_fmt(struct task_struct 
 		/*
 		 * buffer is always remapped into the caller's address space
 		 */
-		ret = pfm_smpl_buffer_alloc(current, ctx, size, &uaddr);
+		ret = pfm_smpl_buffer_alloc(current, filp, ctx, size, &uaddr);
 		if (ret) goto error;
 
 		/* keep track of user address of buffer */
@@ -2716,7 +2719,7 @@ pfm_context_create(pfm_context_t *ctx, v
 	 * does the user want to sample?
 	 */
 	if (pfm_uuid_cmp(req->ctx_smpl_buf_id, pfm_null_uuid)) {
-		ret = pfm_setup_buffer_fmt(current, ctx, ctx_flags, 0, req);
+		ret = pfm_setup_buffer_fmt(current, filp, ctx, ctx_flags, 0, req);
 		if (ret) goto buffer_error;
 	}
 
_

Patches currently in -mm which might be from npiggin@suse.de are

ia64-permon-use-after-free-fix.patch
git-block.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
set_page_dirty-debugging-checks.patch
