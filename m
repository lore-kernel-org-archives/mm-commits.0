From: akpm@linux-foundation.org
Subject: [merged] kernel-audit-consolidate-handling-of-mm-exe_file.patch
 removed from -mm tree
Date: Wed, 25 Feb 2015 12:52:01 -0800
Message-ID: <54ee35f1.MyTyjzCDrKkCwwQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbBYUwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 15:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, eparis@redhat.com, paul@paul-moore.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/audit: consolidate handling of mm->exe_file
has been removed from the -mm tree.  Its filename was
     kernel-audit-consolidate-handling-of-mm-exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: kernel/audit: consolidate handling of mm->exe_file

Add a audit_log_d_path_exe() helper function to share how we handle
auditing of the exe_file's path.  Used by both audit and auditsc.  No
functionality is changed.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c   |   23 +++++++++++++++--------
 kernel/audit.h   |    3 +++
 kernel/auditsc.c |    9 +--------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff -puN kernel/audit.c~kernel-audit-consolidate-handling-of-mm-exe_file kernel/audit.c
--- a/kernel/audit.c~kernel-audit-consolidate-handling-of-mm-exe_file
+++ a/kernel/audit.c
@@ -1838,11 +1838,24 @@ error_path:
 }
 EXPORT_SYMBOL(audit_log_task_context);
 
+void audit_log_d_path_exe(struct audit_buffer *ab,
+			  struct mm_struct *mm)
+{
+	if (!mm) {
+		audit_log_format(ab, " exe=(null)");
+		return;
+	}
+
+	down_read(&mm->mmap_sem);
+	if (mm->exe_file)
+		audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
+	up_read(&mm->mmap_sem);
+}
+
 void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 {
 	const struct cred *cred;
 	char comm[sizeof(tsk->comm)];
-	struct mm_struct *mm = tsk->mm;
 	char *tty;
 
 	if (!ab)
@@ -1878,13 +1891,7 @@ void audit_log_task_info(struct audit_bu
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, get_task_comm(comm, tsk));
 
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		if (mm->exe_file)
-			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
-		up_read(&mm->mmap_sem);
-	} else
-		audit_log_format(ab, " exe=(null)");
+	audit_log_d_path_exe(ab, tsk->mm);
 	audit_log_task_context(ab);
 }
 EXPORT_SYMBOL(audit_log_task_info);
diff -puN kernel/audit.h~kernel-audit-consolidate-handling-of-mm-exe_file kernel/audit.h
--- a/kernel/audit.h~kernel-audit-consolidate-handling-of-mm-exe_file
+++ a/kernel/audit.h
@@ -257,6 +257,9 @@ extern struct list_head audit_filter_lis
 
 extern struct audit_entry *audit_dupe_rule(struct audit_krule *old);
 
+extern void audit_log_d_path_exe(struct audit_buffer *ab,
+				 struct mm_struct *mm);
+
 /* audit watch functions */
 #ifdef CONFIG_AUDIT_WATCH
 extern void audit_put_watch(struct audit_watch *watch);
diff -puN kernel/auditsc.c~kernel-audit-consolidate-handling-of-mm-exe_file kernel/auditsc.c
--- a/kernel/auditsc.c~kernel-audit-consolidate-handling-of-mm-exe_file
+++ a/kernel/auditsc.c
@@ -2361,7 +2361,6 @@ static void audit_log_task(struct audit_
 	kuid_t auid, uid;
 	kgid_t gid;
 	unsigned int sessionid;
-	struct mm_struct *mm = current->mm;
 	char comm[sizeof(current->comm)];
 
 	auid = audit_get_loginuid(current);
@@ -2376,13 +2375,7 @@ static void audit_log_task(struct audit_
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		if (mm->exe_file)
-			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
-		up_read(&mm->mmap_sem);
-	} else
-		audit_log_format(ab, " exe=(null)");
+	audit_log_d_path_exe(ab, current->mm);
 }
 
 /**
_

Patches currently in -mm which might be from dave@stgolabs.net are

arc-do-not-export-symbols-in-troubleshootc.patch
linux-next.patch

