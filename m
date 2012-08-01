From: akpm@linux-foundation.org
Subject: + mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch added to -mm tree
Date: Wed, 01 Aug 2012 15:28:56 -0700
Message-ID: <20120801222856.D816B1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59553 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2HAW27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 18:28:59 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5494219obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 15:28:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: use mm->exe_file instead of first VM_EXECUTABLE vma->vm_file
has been added to the -mm tree.  Its filename is
     mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: use mm->exe_file instead of first VM_EXECUTABLE vma->vm_file

Some security modules and oprofile still uses VM_EXECUTABLE for retrieving
a task's executable file.  After this patch they will use mm->exe_file
directly.  mm->exe_file is protected with mm->mmap_sem, so locking stays
the same.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>			[arch/tile]
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>	[tomoyo]
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/oprofile/cell/spu_task_sync.c |   15 ++++-----------
 arch/tile/mm/elf.c                         |   19 +++++++------------
 drivers/oprofile/buffer_sync.c             |   17 +++--------------
 kernel/auditsc.c                           |   13 ++-----------
 kernel/fork.c                              |    3 +--
 security/tomoyo/util.c                     |    9 ++-------
 6 files changed, 19 insertions(+), 57 deletions(-)

diff -puN arch/powerpc/oprofile/cell/spu_task_sync.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file arch/powerpc/oprofile/cell/spu_task_sync.c
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -304,7 +304,7 @@ static inline unsigned long fast_get_dco
 	return cookie;
 }
 
-/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
+/* Look up the dcookie for the task's mm->exe_file,
  * which corresponds loosely to "application name". Also, determine
  * the offset for the SPU ELF object.  If computed offset is
  * non-zero, it implies an embedded SPU object; otherwise, it's a
@@ -321,7 +321,6 @@ get_exec_dcookie_and_offset(struct spu *
 {
 	unsigned long app_cookie = 0;
 	unsigned int my_offset = 0;
-	struct file *app = NULL;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = spu->mm;
 
@@ -330,16 +329,10 @@ get_exec_dcookie_and_offset(struct spu *
 
 	down_read(&mm->mmap_sem);
 
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (!vma->vm_file)
-			continue;
-		if (!(vma->vm_flags & VM_EXECUTABLE))
-			continue;
-		app_cookie = fast_get_dcookie(&vma->vm_file->f_path);
+	if (mm->exe_file) {
+		app_cookie = fast_get_dcookie(&mm->exe_file->f_path);
 		pr_debug("got dcookie for %s\n",
-			 vma->vm_file->f_dentry->d_name.name);
-		app = vma->vm_file;
-		break;
+			 mm->exe_file->f_dentry->d_name.name);
 	}
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
diff -puN arch/tile/mm/elf.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file arch/tile/mm/elf.c
--- a/arch/tile/mm/elf.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/arch/tile/mm/elf.c
@@ -36,19 +36,14 @@ static void sim_notify_exec(const char *
 	} while (c);
 }
 
-static int notify_exec(void)
+static int notify_exec(struct mm_struct *mm)
 {
 	int retval = 0;  /* failure */
-	struct vm_area_struct *vma = current->mm->mmap;
-	while (vma) {
-		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file)
-			break;
-		vma = vma->vm_next;
-	}
-	if (vma) {
+
+	if (mm->exe_file) {
 		char *buf = (char *) __get_free_page(GFP_KERNEL);
 		if (buf) {
-			char *path = d_path(&vma->vm_file->f_path,
+			char *path = d_path(&mm->exe_file->f_path,
 					    buf, PAGE_SIZE);
 			if (!IS_ERR(path)) {
 				sim_notify_exec(path);
@@ -106,16 +101,16 @@ int arch_setup_additional_pages(struct l
 	unsigned long vdso_base;
 	int retval = 0;
 
+	down_write(&mm->mmap_sem);
+
 	/*
 	 * Notify the simulator that an exec just occurred.
 	 * If we can't find the filename of the mapping, just use
 	 * whatever was passed as the linux_binprm filename.
 	 */
-	if (!notify_exec())
+	if (!notify_exec(mm))
 		sim_notify_exec(bprm->filename);
 
-	down_write(&mm->mmap_sem);
-
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
 	 */
diff -puN drivers/oprofile/buffer_sync.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/drivers/oprofile/buffer_sync.c
@@ -216,7 +216,7 @@ static inline unsigned long fast_get_dco
 }
 
 
-/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
+/* Look up the dcookie for the task's mm->exe_file,
  * which corresponds loosely to "application name". This is
  * not strictly necessary but allows oprofile to associate
  * shared-library samples with particular applications
@@ -224,21 +224,10 @@ static inline unsigned long fast_get_dco
 static unsigned long get_exec_dcookie(struct mm_struct *mm)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct *vma;
-
-	if (!mm)
-		goto out;
 
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (!vma->vm_file)
-			continue;
-		if (!(vma->vm_flags & VM_EXECUTABLE))
-			continue;
-		cookie = fast_get_dcookie(&vma->vm_file->f_path);
-		break;
-	}
+	if (mm && mm->exe_file)
+		cookie = fast_get_dcookie(&mm->exe_file->f_path);
 
-out:
 	return cookie;
 }
 
diff -puN kernel/auditsc.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file kernel/auditsc.c
--- a/kernel/auditsc.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/kernel/auditsc.c
@@ -1158,7 +1158,6 @@ static void audit_log_task_info(struct a
 {
 	char name[sizeof(tsk->comm)];
 	struct mm_struct *mm = tsk->mm;
-	struct vm_area_struct *vma;
 
 	/* tsk == current */
 
@@ -1168,16 +1167,8 @@ static void audit_log_task_info(struct a
 
 	if (mm) {
 		down_read(&mm->mmap_sem);
-		vma = mm->mmap;
-		while (vma) {
-			if ((vma->vm_flags & VM_EXECUTABLE) &&
-			    vma->vm_file) {
-				audit_log_d_path(ab, " exe=",
-						 &vma->vm_file->f_path);
-				break;
-			}
-			vma = vma->vm_next;
-		}
+		if (mm->exe_file)
+			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
 		up_read(&mm->mmap_sem);
 	}
 	audit_log_task_context(ab);
diff -puN kernel/fork.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file kernel/fork.c
--- a/kernel/fork.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/kernel/fork.c
@@ -657,8 +657,7 @@ struct file *get_mm_exe_file(struct mm_s
 {
 	struct file *exe_file;
 
-	/* We need mmap_sem to protect against races with removal of
-	 * VM_EXECUTABLE vmas */
+	/* We need mmap_sem to protect against races with removal of exe_file */
 	down_read(&mm->mmap_sem);
 	exe_file = mm->exe_file;
 	if (exe_file)
diff -puN security/tomoyo/util.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file security/tomoyo/util.c
--- a/security/tomoyo/util.c~mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file
+++ a/security/tomoyo/util.c
@@ -949,18 +949,13 @@ bool tomoyo_path_matches_pattern(const s
 const char *tomoyo_get_exe(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	const char *cp = NULL;
 
 	if (!mm)
 		return NULL;
 	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
-			cp = tomoyo_realpath_from_path(&vma->vm_file->f_path);
-			break;
-		}
-	}
+	if (mm->exe_file)
+		cp = tomoyo_realpath_from_path(&mm->exe_file->f_path);
 	up_read(&mm->mmap_sem);
 	return cp;
 }
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

