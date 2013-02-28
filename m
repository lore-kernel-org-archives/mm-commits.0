From: akpm@linux-foundation.org
Subject: [merged] coredump-remove-redundant-defines-for-dumpable-states.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:40 -0800
Message-ID: <20130228201140.C42255A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:37216 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:42 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244780vea.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, alan@linux.intel.com, dledford@redhat.com, ebiederm@xmission.com, gang.chen@asianux.com, james.l.morris@oracle.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: remove redundant defines for dumpable states
has been removed from the -mm tree.  Its filename was
     coredump-remove-redundant-defines-for-dumpable-states.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: coredump: remove redundant defines for dumpable states

The existing SUID_DUMP_* defines duplicate the newer SUID_DUMPABLE_*
defines introduced in 54b501992dd ("coredump: warn about unsafe
suid_dumpable / core_pattern combo").  Remove the new ones, and use the
prior values instead.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c         |    2 +-
 fs/exec.c             |   10 +++++-----
 fs/proc/internal.h    |    3 ++-
 include/linux/sched.h |    5 -----
 kernel/sysctl.c       |    2 +-
 5 files changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/coredump.c~coredump-remove-redundant-defines-for-dumpable-states fs/coredump.c
--- a/fs/coredump.c~coredump-remove-redundant-defines-for-dumpable-states
+++ a/fs/coredump.c
@@ -501,7 +501,7 @@ void do_coredump(siginfo_t *siginfo)
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_SAFE) {
+	if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
diff -puN fs/exec.c~coredump-remove-redundant-defines-for-dumpable-states fs/exec.c
--- a/fs/exec.c~coredump-remove-redundant-defines-for-dumpable-states
+++ a/fs/exec.c
@@ -1111,7 +1111,7 @@ void setup_new_exec(struct linux_binprm 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
+		set_dumpable(current->mm, SUID_DUMP_USER);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
@@ -1639,17 +1639,17 @@ EXPORT_SYMBOL(set_binfmt);
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	switch (value) {
-	case SUID_DUMPABLE_DISABLED:
+	case SUID_DUMP_DISABLE:
 		clear_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case SUID_DUMPABLE_ENABLED:
+	case SUID_DUMP_USER:
 		set_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case SUID_DUMPABLE_SAFE:
+	case SUID_DUMP_ROOT:
 		set_bit(MMF_DUMP_SECURELY, &mm->flags);
 		smp_wmb();
 		set_bit(MMF_DUMPABLE, &mm->flags);
@@ -1662,7 +1662,7 @@ int __get_dumpable(unsigned long mm_flag
 	int ret;
 
 	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret > SUID_DUMPABLE_ENABLED) ? SUID_DUMPABLE_SAFE : ret;
+	return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
 }
 
 int get_dumpable(struct mm_struct *mm)
diff -puN fs/proc/internal.h~coredump-remove-redundant-defines-for-dumpable-states fs/proc/internal.h
--- a/fs/proc/internal.h~coredump-remove-redundant-defines-for-dumpable-states
+++ a/fs/proc/internal.h
@@ -11,6 +11,7 @@
 
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/binfmts.h>
 struct  ctl_table_header;
 struct  mempolicy;
 
@@ -108,7 +109,7 @@ static inline int task_dumpable(struct t
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if (dumpable == SUID_DUMPABLE_ENABLED)
+	if (dumpable == SUID_DUMP_USER)
 		return 1;
 	return 0;
 }
diff -puN include/linux/sched.h~coredump-remove-redundant-defines-for-dumpable-states include/linux/sched.h
--- a/include/linux/sched.h~coredump-remove-redundant-defines-for-dumpable-states
+++ a/include/linux/sched.h
@@ -346,11 +346,6 @@ static inline void arch_pick_mmap_layout
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
-/* get/set_dumpable() values */
-#define SUID_DUMPABLE_DISABLED	0
-#define SUID_DUMPABLE_ENABLED	1
-#define SUID_DUMPABLE_SAFE	2
