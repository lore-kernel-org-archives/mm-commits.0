From: akpm@linux-foundation.org
Subject: - coredump-masking-reimplementation-of-dumpable-using-two-flags.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:15 -0700
Message-ID: <200707192002.l6JK2F5x019648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878AbXGSUce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     coredump masking: reimplementation of dumpable using two flags
has been removed from the -mm tree.  Its filename was
     coredump-masking-reimplementation-of-dumpable-using-two-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coredump masking: reimplementation of dumpable using two flags
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch changes mm_struct.dumpable to a pair of bit flags.

set_dumpable() converts three-value dumpable to two flags and stores it into
lower two bits of mm_struct.flags instead of mm_struct.dumpable. 
get_dumpable() behaves in the opposite way.

[akpm@linux-foundation.org: export set_dumpable]
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                    |   62 +++++++++++++++++++++++++++++----
 fs/proc/base.c               |    2 -
 include/asm-ia64/processor.h |    4 +-
 include/linux/sched.h        |    9 ++++
 kernel/ptrace.c              |    2 -
 kernel/sys.c                 |   24 ++++++------
 security/commoncap.c         |    2 -
 security/dummy.c             |    2 -
 8 files changed, 82 insertions(+), 25 deletions(-)

diff -puN fs/exec.c~coredump-masking-reimplementation-of-dumpable-using-two-flags fs/exec.c
--- a/fs/exec.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/fs/exec.c
@@ -1058,9 +1058,9 @@ int flush_old_exec(struct linux_binprm *
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (current->euid == current->uid && current->egid == current->gid)
-		current->mm->dumpable = 1;
+		set_dumpable(current->mm, 1);
 	else
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 	name = bprm->filename;
 
@@ -1088,7 +1088,7 @@ int flush_old_exec(struct linux_binprm *
 	    file_permission(bprm->file, MAY_READ) ||
 	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 	}
 
 	/* An exec changes our domain. We are no longer part of the thread
@@ -1665,6 +1665,56 @@ fail:
 	return core_waiters;
 }
 
+/*
+ * set_dumpable converts traditional three-value dumpable to two flags and
+ * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
+ * these bits are not changed atomically.  So get_dumpable can observe the
+ * intermediate state.  To avoid doing unexpected behavior, get get_dumpable
+ * return either old dumpable or new one by paying attention to the order of
+ * modifying the bits.
+ *
+ * dumpable |   mm->flags (binary)
+ * old  new | initial interim  final
+ * ---------+-----------------------
+ *  0    1  |   00      01      01
+ *  0    2  |   00      10(*)   11
+ *  1    0  |   01      00      00
+ *  1    2  |   01      11      11
+ *  2    0  |   11      10(*)   00
+ *  2    1  |   11      11      01
+ *
+ * (*) get_dumpable regards interim value of 10 as 11.
+ */
+void set_dumpable(struct mm_struct *mm, int value)
+{
+	switch (value) {
+	case 0:
+		clear_bit(MMF_DUMPABLE, &mm->flags);
+		smp_wmb();
+		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
+		break;
+	case 1:
+		set_bit(MMF_DUMPABLE, &mm->flags);
+		smp_wmb();
+		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
+		break;
+	case 2:
+		set_bit(MMF_DUMP_SECURELY, &mm->flags);
+		smp_wmb();
+		set_bit(MMF_DUMPABLE, &mm->flags);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(set_dumpable);
+
+int get_dumpable(struct mm_struct *mm)
+{
+	int ret;
+
+	ret = mm->flags & 0x3;
+	return (ret >= 2) ? 2 : ret;
+}
+
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
 	char corename[CORENAME_MAX_SIZE + 1];
@@ -1683,7 +1733,7 @@ int do_coredump(long signr, int exit_cod
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 	down_write(&mm->mmap_sem);
-	if (!mm->dumpable) {
+	if (!get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
@@ -1693,11 +1743,11 @@ int do_coredump(long signr, int exit_cod
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
-	if (mm->dumpable == 2) {	/* Setuid core dump mode */
+	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	mm->dumpable = 0;
+	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
diff -puN fs/proc/base.c~coredump-masking-reimplementation-of-dumpable-using-two-flags fs/proc/base.c
--- a/fs/proc/base.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/fs/proc/base.c
@@ -1014,7 +1014,7 @@ static int task_dumpable(struct task_str
 	task_lock(task);
 	mm = task->mm;
 	if (mm)
-		dumpable = mm->dumpable;
+		dumpable = get_dumpable(mm);
 	task_unlock(task);
 	if(dumpable == 1)
 		return 1;
diff -puN include/asm-ia64/processor.h~coredump-masking-reimplementation-of-dumpable-using-two-flags include/asm-ia64/processor.h
--- a/include/asm-ia64/processor.h~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/include/asm-ia64/processor.h
@@ -295,9 +295,9 @@ struct thread_struct {
 	regs->ar_bspstore = current->thread.rbs_bot;						\
 	regs->ar_fpsr = FPSR_DEFAULT;								\
 	regs->loadrs = 0;									\
-	regs->r8 = current->mm->dumpable;	/* set "don't zap registers" flag */		\
+	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!current->mm->dumpable)) {							\
+	if (unlikely(!get_dumpable(current->mm))) {							\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
diff -puN include/linux/sched.h~coredump-masking-reimplementation-of-dumpable-using-two-flags include/linux/sched.h
--- a/include/linux/sched.h~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/include/linux/sched.h
@@ -345,6 +345,13 @@ typedef unsigned long mm_counter_t;
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
+extern void set_dumpable(struct mm_struct *mm, int value);
+extern int get_dumpable(struct mm_struct *mm);
+
+/* mm flags */
+#define MMF_DUMPABLE      0  /* core dump is permitted */
+#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -402,7 +409,7 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
-	unsigned char dumpable:2;
+	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
 	int core_waiters;
diff -puN kernel/ptrace.c~coredump-masking-reimplementation-of-dumpable-using-two-flags kernel/ptrace.c
--- a/kernel/ptrace.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/kernel/ptrace.c
@@ -142,7 +142,7 @@ static int may_attach(struct task_struct
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
-		dumpable = task->mm->dumpable;
+		dumpable = get_dumpable(task->mm);
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
diff -puN kernel/sys.c~coredump-masking-reimplementation-of-dumpable-using-two-flags kernel/sys.c
--- a/kernel/sys.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/kernel/sys.c
@@ -1036,7 +1036,7 @@ asmlinkage long sys_setregid(gid_t rgid,
 			return -EPERM;
 	}
 	if (new_egid != old_egid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	if (rgid != (gid_t) -1 ||
@@ -1066,13 +1066,13 @@ asmlinkage long sys_setgid(gid_t gid)
 
 	if (capable(CAP_SETGID)) {
 		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->gid = current->egid = current->sgid = current->fsgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
 		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->egid = current->fsgid = gid;
@@ -1103,7 +1103,7 @@ static int set_user(uid_t new_ruid, int 
 	switch_uid(new_user);
 
 	if (dumpclear) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->uid = new_ruid;
@@ -1159,7 +1159,7 @@ asmlinkage long sys_setreuid(uid_t ruid,
 		return -EAGAIN;
 
 	if (new_euid != old_euid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->fsuid = current->euid = new_euid;
@@ -1209,7 +1209,7 @@ asmlinkage long sys_setuid(uid_t uid)
 		return -EPERM;
 
 	if (old_euid != uid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->fsuid = current->euid = uid;
@@ -1254,7 +1254,7 @@ asmlinkage long sys_setresuid(uid_t ruid
 	}
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->euid = euid;
@@ -1304,7 +1304,7 @@ asmlinkage long sys_setresgid(gid_t rgid
 	}
 	if (egid != (gid_t) -1) {
 		if (egid != current->egid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->egid = egid;
@@ -1350,7 +1350,7 @@ asmlinkage long sys_setfsuid(uid_t uid)
 	    uid == current->suid || uid == current->fsuid || 
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->fsuid = uid;
@@ -1379,7 +1379,7 @@ asmlinkage long sys_setfsgid(gid_t gid)
 	    gid == current->sgid || gid == current->fsgid || 
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->fsgid = gid;
@@ -2176,14 +2176,14 @@ asmlinkage long sys_prctl(int option, un
 			error = put_user(current->pdeath_signal, (int __user *)arg2);
 			break;
 		case PR_GET_DUMPABLE:
-			error = current->mm->dumpable;
+			error = get_dumpable(current->mm);
 			break;
 		case PR_SET_DUMPABLE:
 			if (arg2 < 0 || arg2 > 1) {
 				error = -EINVAL;
 				break;
 			}
-			current->mm->dumpable = arg2;
+			set_dumpable(current->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
diff -puN security/commoncap.c~coredump-masking-reimplementation-of-dumpable-using-two-flags security/commoncap.c
--- a/security/commoncap.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/security/commoncap.c
@@ -148,7 +148,7 @@ void cap_bprm_apply_creds (struct linux_
 
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
diff -puN security/dummy.c~coredump-masking-reimplementation-of-dumpable-using-two-flags security/dummy.c
--- a/security/dummy.c~coredump-masking-reimplementation-of-dumpable-using-two-flags
+++ a/security/dummy.c
@@ -130,7 +130,7 @@ static void dummy_bprm_free_security (st
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
 			bprm->e_uid = current->uid;
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
