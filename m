From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:33:03 -0800
Message-ID: <200802080832.m188WivQ015737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944AbYBHIeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, menage@google.com, morgan@kernel.org, pj@sgi.com, rientjes@google.com, schwidefsky@de.ibm.c


The patch titled
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch

This patch was dropped because it was folded into proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/proc/task_nommu.c: In function `task_mem':
fs/proc/task_nommu.c:61: error: `buffer' undeclared (first use in this function)
fs/proc/task_nommu.c:61: error: (Each undeclared identifier is reported only once
fs/proc/task_nommu.c:61: error: for each function it appears in.)
fs/proc/task_nommu.c:68: warning: `return' with a value, in function returning void

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

 fs/proc/task_nommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/task_nommu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix
+++ a/fs/proc/task_nommu.c
@@ -58,14 +58,13 @@ void task_mem(struct seq_file *m, struct
 
 	bytes += kobjsize(current); /* includes kernel stack */
 
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"Mem:\t%8lu bytes\n"
 		"Slack:\t%8lu bytes\n"
 		"Shared:\t%8lu bytes\n",
 		bytes, slack, sbytes);
 
 	up_read(&mm->mmap_sem);
-	return buffer;
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
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
