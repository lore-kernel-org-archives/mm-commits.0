From: akpm@linux-foundation.org
Subject: + audit-use-timespec64-to-represent-audit-timestamps.patch added
 to -mm tree
Date: Mon, 10 Apr 2017 15:34:25 -0700
Message-ID: <58ec0871.wJYJxFkiuN9vz11x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdDJWe0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, eparis@redhat.com, paul@paul-moore.com, rgb@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: use timespec64 to represent audit timestamps
has been added to the -mm tree.  Its filename is
     audit-use-timespec64-to-represent-audit-timestamps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/audit-use-timespec64-to-represent-audit-timestamps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/audit-use-timespec64-to-represent-audit-timestamps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: audit: use timespec64 to represent audit timestamps

struct timespec is not y2038 safe.  Audit timestamps are recorded in
string format into an audit buffer for a given context.  These mark the
entry timestamps for the syscalls.  Use y2038 safe struct timespec64 to
represent the times.  The log strings can handle this transition as
strings can hold upto 1024 characters.

Link: http://lkml.kernel.org/r/1491613030-11599-7-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |    4 ++--
 kernel/audit.c        |   10 +++++-----
 kernel/audit.h        |    2 +-
 kernel/auditsc.c      |    6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/audit.h~audit-use-timespec64-to-represent-audit-timestamps include/linux/audit.h
--- a/include/linux/audit.h~audit-use-timespec64-to-represent-audit-timestamps
+++ a/include/linux/audit.h
@@ -332,7 +332,7 @@ static inline void audit_ptrace(struct t
 				/* Private API (for audit.c only) */
 extern unsigned int audit_serial(void);
 extern int auditsc_get_stamp(struct audit_context *ctx,
-			      struct timespec *t, unsigned int *serial);
+			      struct timespec64 *t, unsigned int *serial);
 extern int audit_set_loginuid(kuid_t loginuid);
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
@@ -511,7 +511,7 @@ static inline void __audit_seccomp(unsig
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 { }
 static inline int auditsc_get_stamp(struct audit_context *ctx,
-			      struct timespec *t, unsigned int *serial)
+			      struct timespec64 *t, unsigned int *serial)
 {
 	return 0;
 }
diff -puN kernel/audit.c~audit-use-timespec64-to-represent-audit-timestamps kernel/audit.c
--- a/kernel/audit.c~audit-use-timespec64-to-represent-audit-timestamps
+++ a/kernel/audit.c
@@ -1625,10 +1625,10 @@ unsigned int audit_serial(void)
 }
 
 static inline void audit_get_stamp(struct audit_context *ctx,
-				   struct timespec *t, unsigned int *serial)
+				   struct timespec64 *t, unsigned int *serial)
 {
 	if (!ctx || !auditsc_get_stamp(ctx, t, serial)) {
-		*t = CURRENT_TIME;
+		ktime_get_real_ts64(t);
 		*serial = audit_serial();
 	}
 }
@@ -1652,7 +1652,7 @@ struct audit_buffer *audit_log_start(str
 				     int type)
 {
 	struct audit_buffer *ab;
-	struct timespec t;
+	struct timespec64 t;
 	unsigned int uninitialized_var(serial);
 
 	if (audit_initialized != AUDIT_INITIALIZED)
@@ -1705,8 +1705,8 @@ struct audit_buffer *audit_log_start(str
 	}
 
 	audit_get_stamp(ab->ctx, &t, &serial);
-	audit_log_format(ab, "audit(%lu.%03lu:%u): ",
-			 t.tv_sec, t.tv_nsec/1000000, serial);
+	audit_log_format(ab, "audit(%llu.%03lu:%u): ",
+			 (unsigned long long)t.tv_sec, t.tv_nsec/1000000, serial);
 
 	return ab;
 }
diff -puN kernel/audit.h~audit-use-timespec64-to-represent-audit-timestamps kernel/audit.h
--- a/kernel/audit.h~audit-use-timespec64-to-represent-audit-timestamps
+++ a/kernel/audit.h
@@ -112,7 +112,7 @@ struct audit_context {
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
-	struct timespec	    ctime;      /* time of syscall entry */
+	struct timespec64   ctime;      /* time of syscall entry */
 	unsigned long	    argv[4];    /* syscall arguments */
 	long		    return_code;/* syscall return code */
 	u64		    prio;
diff -puN kernel/auditsc.c~audit-use-timespec64-to-represent-audit-timestamps kernel/auditsc.c
--- a/kernel/auditsc.c~audit-use-timespec64-to-represent-audit-timestamps
+++ a/kernel/auditsc.c
@@ -1533,7 +1533,7 @@ void __audit_syscall_entry(int major, un
 		return;
 
 	context->serial     = 0;
-	context->ctime      = CURRENT_TIME;
+	ktime_get_real_ts64(&context->ctime);
 	context->in_syscall = 1;
 	context->current_state  = state;
 	context->ppid       = 0;
@@ -1942,13 +1942,13 @@ EXPORT_SYMBOL_GPL(__audit_inode_child);
 /**
  * auditsc_get_stamp - get local copies of audit_context values
  * @ctx: audit_context for the task
- * @t: timespec to store time recorded in the audit_context
+ * @t: timespec64 to store time recorded in the audit_context
  * @serial: serial value that is recorded in the audit_context
  *
  * Also sets the context as auditable.
  */
 int auditsc_get_stamp(struct audit_context *ctx,
-		       struct timespec *t, unsigned int *serial)
+		       struct timespec64 *t, unsigned int *serial)
 {
 	if (!ctx->in_syscall)
 		return 0;
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

