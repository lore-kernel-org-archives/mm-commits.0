From: akpm@linux-foundation.org
Subject: + exec-ptrace-fix-get_dumpable-incorrect-tests.patch added to -mm tree
Date: Mon, 04 Nov 2013 13:54:54 -0800
Message-ID: <527817ae.zP2mV4bLPLSPGICQ%akpm__26654.3605401695$1383602293$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDVyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, stable@vger.kernel.org, segoon@openwall.com, oleg@redhat.com, ebiederm@xmission.com, keescook@chromium.org

Subject: + exec-ptrace-fix-get_dumpable-incorrect-tests.patch added to -mm tree
To: keescook@chromium.org,ebiederm@xmission.com,oleg@redhat.com,segoon@openwall.com,stable@vger.kernel.org,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:54:54 -0800


The patch titled
     Subject: exec/ptrace: fix get_dumpable() incorrect tests
has been added to the -mm tree.  Its filename is
     exec-ptrace-fix-get_dumpable-incorrect-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-ptrace-fix-get_dumpable-incorrect-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-ptrace-fix-get_dumpable-incorrect-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec/ptrace: fix get_dumpable() incorrect tests

The get_dumpable() return value is not boolean.  Most users of the
function actually want to be testing for non-SUID_DUMP_USER(1) rather than
SUID_DUMP_DISABLE(0).  The SUID_DUMP_ROOT(2) is also considered a
protected state.  Almost all places did this correctly, excepting the two
places fixed in this patch.

Wrong logic:
    if (dumpable == SUID_DUMP_DISABLE) { /* be protective */ }
        or
    if (dumpable == 0) { /* be protective */ }
        or
    if (!dumpable) { /* be protective */ }

Correct logic:
    if (dumpable != SUID_DUMP_USER) { /* be protective */ }
        or
    if (dumpable != 1) { /* be protective */ }

Without this patch, if the system had set the sysctl fs/suid_dumpable=2, a
user was able to ptrace attach to processes that had dropped privileges to
that user.  (This may have been partially mitigated if Yama was enabled.)

The macros have been moved into the file that declares get/set_dumpable(),
which means things like the ia64 code can see them too.

CVE-2013-2929

Reported-by: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/processor.h |    2 +-
 fs/exec.c                         |    6 ++++++
 include/linux/binfmts.h           |    3 ---
 include/linux/sched.h             |    4 ++++
 kernel/ptrace.c                   |    3 ++-
 5 files changed, 13 insertions(+), 5 deletions(-)

diff -puN arch/ia64/include/asm/processor.h~exec-ptrace-fix-get_dumpable-incorrect-tests arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~exec-ptrace-fix-get_dumpable-incorrect-tests
+++ a/arch/ia64/include/asm/processor.h
@@ -319,7 +319,7 @@ struct thread_struct {
 	regs->loadrs = 0;									\
 	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!get_dumpable(current->mm))) {							\
+	if (unlikely(get_dumpable(current->mm) != SUID_DUMP_USER)) {	\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
diff -puN fs/exec.c~exec-ptrace-fix-get_dumpable-incorrect-tests fs/exec.c
--- a/fs/exec.c~exec-ptrace-fix-get_dumpable-incorrect-tests
+++ a/fs/exec.c
@@ -1668,6 +1668,12 @@ int __get_dumpable(unsigned long mm_flag
 	return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
 }
 
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
 int get_dumpable(struct mm_struct *mm)
 {
 	return __get_dumpable(mm->flags);
diff -puN include/linux/binfmts.h~exec-ptrace-fix-get_dumpable-incorrect-tests include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-ptrace-fix-get_dumpable-incorrect-tests
+++ a/include/linux/binfmts.h
@@ -99,9 +99,6 @@ extern void setup_new_exec(struct linux_
 extern void would_dump(struct linux_binprm *, struct file *);
 
 extern int suid_dumpable;
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* Stack area protections */
 #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
diff -puN include/linux/sched.h~exec-ptrace-fix-get_dumpable-incorrect-tests include/linux/sched.h
--- a/include/linux/sched.h~exec-ptrace-fix-get_dumpable-incorrect-tests
+++ a/include/linux/sched.h
@@ -322,6 +322,10 @@ static inline void arch_pick_mmap_layout
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
+#define SUID_DUMP_USER		1	/* Dump as user of process */
+#define SUID_DUMP_ROOT		2	/* Dump as root */
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff -puN kernel/ptrace.c~exec-ptrace-fix-get_dumpable-incorrect-tests kernel/ptrace.c
--- a/kernel/ptrace.c~exec-ptrace-fix-get_dumpable-incorrect-tests
+++ a/kernel/ptrace.c
@@ -257,7 +257,8 @@ ok:
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
 	rcu_read_lock();
-	if (!dumpable && !ptrace_has_cap(__task_cred(task)->user_ns, mode)) {
+	if (dumpable != SUID_DUMP_USER &&
+	    !ptrace_has_cap(__task_cred(task)->user_ns, mode)) {
 		rcu_read_unlock();
 		return -EPERM;
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch
exec-ptrace-fix-get_dumpable-incorrect-tests.patch
gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

