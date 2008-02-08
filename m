From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:32:54 -0800
Message-ID: <200802080832.m188WZBs015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944AbYBHIdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, menage@google.com, morgan@kernel.org, pj@sgi.com, rientjes@google.com, schwidefsky@de.ibm.c


The patch titled
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch

This patch was dropped because it was folded into proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#203: FILE: fs/proc/array.c:207:
+static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)

WARNING: line over 80 characters
#264: FILE: fs/proc/array.c:281:
+static void render_cap_t(struct seq_file *m, const char *header, kernel_cap_t *a)

WARNING: line over 80 characters
#307: FILE: fs/proc/array.c:309:
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,

WARNING: line over 80 characters
#443: FILE: include/linux/cpuset.h:61:
+extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);

total: 0 errors, 4 warnings, 416 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew Morgan <morgan@kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c        |   10 ++++++----
 include/linux/cpuset.h |    3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
+++ a/fs/proc/array.c
@@ -204,7 +204,8 @@ static inline void task_state(struct seq
 	seq_printf(m, "\n");
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)
+static void render_sigset_t(struct seq_file *m, const char *header,
+				sigset_t *set)
 {
 	int i;
 
@@ -278,7 +279,8 @@ static inline void task_sig(struct seq_f
 	render_sigset_t(m, "SigCgt:\t", &caught);
 }
 
-static void render_cap_t(struct seq_file *m, const char *header, kernel_cap_t *a)
+static void render_cap_t(struct seq_file *m, const char *header,
+			kernel_cap_t *a)
 {
 	unsigned __capi;
 
@@ -306,8 +308,8 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
-int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,
-			struct task_struct *task)
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
 	struct mm_struct *mm = get_task_mm(task);
 
diff -puN include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes include/linux/cpuset.h
--- a/include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
+++ a/include/linux/cpuset.h
@@ -58,7 +58,8 @@ extern void __cpuset_memory_pressure_bum
 
 extern const struct file_operations proc_cpuset_operations;
 struct seq_file;
-extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);
+extern void cpuset_task_status_allowed(struct seq_file *m,
+					struct task_struct *task);
 
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
