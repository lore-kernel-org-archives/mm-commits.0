From: akpm@linux-foundation.org
Subject: [merged] argv_split-teach-it-to-handle-mutable-strings.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:17 -0700
Message-ID: <20130430185317.7EBF55A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56063 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3D3SxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:18 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86474vbf.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: argv_split(): teach it to handle mutable strings
has been removed from the -mm tree.  Its filename was
     argv_split-teach-it-to-handle-mutable-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: argv_split(): teach it to handle mutable strings

argv_split() allocates argv[count_argc(str)] array and assumes that it
will find the same number of arguments later.  This is obviously wrong if
this string can be changed, say, by sysctl.

With this patch argv_split() kstrndup's the whole string and does not
split it, we simply replace the spaces with zeroes and keep the allocated
memory in argv[-1] for argv_free(arg).

We do not use argv[0] because:

	- str can be all-spaces or empty. In fact this case is fine,
	  we could kfree() it before return, but:

	- str can have a space at the start, and we can not rely on
	  kstrndup(skip_spaces(str)) because it can equally race if
	  this string is mutable.

Also, simplify count_argc() and kill the no longer used skip_arg().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |   87 ++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 47 deletions(-)

diff -puN lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings lib/argv_split.c
--- a/lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings
+++ a/lib/argv_split.c
@@ -8,23 +8,17 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
-static const char *skip_arg(const char *cp)
-{
-	while (*cp && !isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
 static int count_argc(const char *str)
 {
 	int count = 0;
+	bool was_space;
 
-	while (*str) {
-		str = skip_spaces(str);
-		if (*str) {
+	for (was_space = true; *str; str++) {
+		if (isspace(*str)) {
+			was_space = true;
+		} else if (was_space) {
+			was_space = false;
 			count++;
-			str = skip_arg(str);
 		}
 	}
 
@@ -39,10 +33,8 @@ static int count_argc(const char *str)
  */
 void argv_free(char **argv)
 {
-	char **p;
-	for (p = argv; *p; p++)
-		kfree(*p);
-
+	argv--;
+	kfree(argv[0]);
 	kfree(argv);
 }
 EXPORT_SYMBOL(argv_free);
@@ -59,43 +51,44 @@ EXPORT_SYMBOL(argv_free);
  * considered to be a single argument separator.  The returned array
  * is always NULL-terminated.  Returns NULL on memory allocation
  * failure.
+ *
+ * The source string at `str' may be undergoing concurrent alteration via
+ * userspace sysctl activity (at least).  The argv_split() implementation
+ * attempts to handle this gracefully by taking a local copy to work on.
  */
 char **argv_split(gfp_t gfp, const char *str, int *argcp)
 {
-	int argc = count_argc(str);
-	char **argv = kzalloc(sizeof(*argv) * (argc+1), gfp);
-	char **argvp;
-
-	if (argv == NULL)
-		goto out;
-
-	if (argcp)
-		*argcp = argc;
-
-	argvp = argv;
-
-	while (*str) {
-		str = skip_spaces(str);
-
-		if (*str) {
-			const char *p = str;
-			char *t;
-
-			str = skip_arg(str);
+	char *argv_str;
+	bool was_space;
+	char **argv, **argv_ret;
+	int argc;
+
+	argv_str = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
+	if (!argv_str)
+		return NULL;
+
+	argc = count_argc(argv_str);
+	argv = kmalloc(sizeof(*argv) * (argc + 2), gfp);
+	if (!argv) {
+		kfree(argv_str);
+		return NULL;
+	}
 
-			t = kstrndup(p, str-p, gfp);
-			if (t == NULL)
-				goto fail;
-			*argvp++ = t;
+	*argv = argv_str;
+	argv_ret = ++argv;
+	for (was_space = true; *argv_str; argv_str++) {
+		if (isspace(*argv_str)) {
+			was_space = true;
+			*argv_str = 0;
+		} else if (was_space) {
+			was_space = false;
+			*argv++ = argv_str;
 		}
 	}
-	*argvp = NULL;
-
-  out:
-	return argv;
+	*argv = NULL;
 
-  fail:
-	argv_free(argv);
-	return NULL;
+	if (argcp)
+		*argcp = argc;
+	return argv_ret;
 }
 EXPORT_SYMBOL(argv_split);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch
kernel-smpc-use-=-for-csd_lock.patch
kernel-smpc-remove-priv-of-call_single_data.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
set_task_comm-kill-the-pointless-memset-wmb.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

