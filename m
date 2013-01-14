From: akpm@linux-foundation.org
Subject: [merged] audit-create-explicit-audit_seccomp-event-type.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:39:02 -0800
Message-ID: <20130114203903.4294E200069@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:34796 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3ANUjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:39:07 -0500
Received: by mail-ee0-f73.google.com with SMTP id d49so151694eek.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:39:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, ebiederm@xmission.com, eparis@redhat.com, jlayton@redhat.com, jln@google.com, sgrubb@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: create explicit AUDIT_SECCOMP event type
has been removed from the -mm tree.  Its filename was
     audit-create-explicit-audit_seccomp-event-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: audit: create explicit AUDIT_SECCOMP event type

The seccomp path was using AUDIT_ANOM_ABEND from when seccomp mode 1 could
only kill a process.  While we still want to make sure an audit record is
forced on a kill, this should use a separate record type since seccomp
mode 2 introduces other behaviors.

In the case of "handled" behaviors (process wasn't killed), only emit a
record if the process is under inspection.  This change also fixes
userspace examination of seccomp audit events, since it was considered
malformed due to missing fields of the AUDIT_ANOM_ABEND event type.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Julien Tinnes <jln@google.com>
Acked-by: Will Drewry <wad@chromium.org>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h      |    3 ++-
 include/uapi/linux/audit.h |    1 +
 kernel/auditsc.c           |   14 +++++++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff -puN include/linux/audit.h~audit-create-explicit-audit_seccomp-event-type include/linux/audit.h
--- a/include/linux/audit.h~audit-create-explicit-audit_seccomp-event-type
+++ a/include/linux/audit.h
@@ -157,7 +157,8 @@ void audit_core_dumps(long signr);
 
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 {
-	if (unlikely(!audit_dummy_context()))
+	/* Force a record to be reported if a signal was delivered. */
+	if (signr || unlikely(!audit_dummy_context()))
 		__audit_seccomp(syscall, signr, code);
 }
 
diff -puN include/uapi/linux/audit.h~audit-create-explicit-audit_seccomp-event-type include/uapi/linux/audit.h
--- a/include/uapi/linux/audit.h~audit-create-explicit-audit_seccomp-event-type
+++ a/include/uapi/linux/audit.h
@@ -106,6 +106,7 @@
 #define AUDIT_MMAP		1323	/* Record showing descriptor and flags in mmap */
 #define AUDIT_NETFILTER_PKT	1324	/* Packets traversing netfilter chains */
 #define AUDIT_NETFILTER_CFG	1325	/* Netfilter chain modifications */
+#define AUDIT_SECCOMP		1326	/* Secure Computing event */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff -puN kernel/auditsc.c~audit-create-explicit-audit_seccomp-event-type kernel/auditsc.c
--- a/kernel/auditsc.c~audit-create-explicit-audit_seccomp-event-type
+++ a/kernel/auditsc.c
@@ -2675,7 +2675,7 @@ void __audit_mmap_fd(int fd, int flags)
 	context->type = AUDIT_MMAP;
 }
 
-static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
 	kgid_t gid;
@@ -2693,6 +2693,11 @@ static void audit_log_abend(struct audit
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
+}
+
+static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+{
+	audit_log_task(ab);
 	audit_log_format(ab, " reason=");
 	audit_log_string(ab, reason);
 	audit_log_format(ab, " sig=%ld", signr);
@@ -2723,8 +2728,11 @@ void __audit_seccomp(unsigned long sysca
 {
 	struct audit_buffer *ab;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
-	audit_log_abend(ab, "seccomp", signr);
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
+	if (unlikely(!ab))
+		return;
+	audit_log_task(ab);
+	audit_log_format(ab, " sig=%ld", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
 	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

