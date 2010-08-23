From: akpm@linux-foundation.org
Subject: + core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch added to -mm tree
Date: Mon, 23 Aug 2010 14:19:03 -0700
Message-ID: <201008232119.o7NLJ3O9015278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab0HWVTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 17:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com, oleg@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     core_pattern: fix truncation by core_pattern handler with long parameters
has been added to the -mm tree.  Its filename is
     core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: core_pattern: fix truncation by core_pattern handler with long parameters
From: Xiaotian Feng <dfeng@redhat.com>

We met a parameter truncated issue, consider following:
> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
%s %c %p %u %g 11 12345678901234567890123456789012345678 %t" > \
/proc/sys/kernel/core_pattern

This is okay because the strings is less than CORENAME_MAX_SIZE.  "cat
/proc/sys/kernel/core_pattern" shows the whole string.  but after we run
core_pattern_pipe_test in man page, we found last parameter was truncated
like below:

        argc[10]=<12807486>

The root cause is core_pattern allows % specifiers, which need to be
replaced during parse time, but the replace may expand the strings to
larger than CORENAME_MAX_SIZE.  So if the last parameter is % specifiers,
the replace code is using snprintf(out_ptr, out_end - out_ptr, ...), this
will write out of corename array.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |  180 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 120 insertions(+), 60 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler fs/exec.c
--- a/fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler
+++ a/fs/exec.c
@@ -65,6 +65,12 @@ char core_pattern[CORENAME_MAX_SIZE] = "
 unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
+struct core_name {
+	char *corename;
+	int used, size;
+};
+static atomic_t call_count = ATOMIC_INIT(1);
+
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
 static LIST_HEAD(formats);
@@ -1440,106 +1446,146 @@ void set_binfmt(struct linux_binfmt *new
 
 EXPORT_SYMBOL(set_binfmt);
 
+static int expand_corename(struct core_name *cn)
+{
+	char *old_corename = cn->corename;
+
+	cn->size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
+	cn->corename = krealloc(old_corename, cn->size, GFP_KERNEL);
+
+	if (!cn->corename) {
+		kfree(old_corename);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int cn_printf(struct core_name *cn, const char *fmt, ...)
+{
+	char *cur;
+	int need;
+	int ret;
+	va_list arg;
+
+	cur = cn->corename + cn->used;
+
+	va_start(arg, fmt);
+	need = vsnprintf(NULL, 0, fmt, arg);
+	va_end(arg);
+
+	if (likely(need < cn->size - cn->used))
+		goto out_printf;
+
+	ret = expand_corename(cn);
+	if (ret)
+		goto expand_fail;
+
+out_printf:
+	va_start(arg, fmt);
+	vsnprintf(cur, need + 1, fmt, arg);
+	va_end(arg);
+	cn->used += need;
+	return 0;
+
+expand_fail:
+	return ret;
+}
+
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, long signr)
+static int format_corename(struct core_name *cn, long signr)
 {
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
-	char *out_ptr = corename;
-	char *const out_end = corename + CORENAME_MAX_SIZE;
-	int rc;
+	char *out_ptr;
 	int pid_in_pattern = 0;
 
+	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
+	cn->corename = kmalloc(cn->size, GFP_KERNEL);
+	cn->used = 0;
+
+	if (!cn->corename)
+		goto out_fail;
+
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (out_ptr == out_end)
-				goto out;
-			*out_ptr++ = *pat_ptr++;
+			if (cn->used == cn->size)
+				if (expand_corename(cn))
+					goto out_fail;
+
+			out_ptr = cn->corename + cn->used;
+			*out_ptr = *pat_ptr++;
+			cn->used++;
 		} else {
 			switch (*++pat_ptr) {
 			case 0:
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
-				if (out_ptr == out_end)
-					goto out;
-				*out_ptr++ = '%';
+				if (cn->used == cn->size)
+					if (expand_corename(cn))
+						goto out_fail;
+
+				out_ptr = cn->corename + cn->used;
+				*out_ptr = '%';
+				cn->used++;
 				break;
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", task_tgid_vnr(current));
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%d",
+					      task_tgid_vnr(current)))
+					goto out_fail;
 				break;
 			/* uid */
 			case 'u':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->uid);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%d", cred->uid))
+					goto out_fail;
 				break;
 			/* gid */
 			case 'g':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->gid);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%d", cred->gid))
+					goto out_fail;
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%ld", signr);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%ld", signr))
+					goto out_fail;
 				break;
 			/* UNIX time of coredump */
 			case 't': {
 				struct timeval tv;
 				do_gettimeofday(&tv);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", tv.tv_sec);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%lu", tv.tv_sec))
+					goto out_fail;
 				break;
 			}
 			/* hostname */
 			case 'h':
 				down_read(&uts_sem);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", utsname()->nodename);
+				if (cn_printf(cn, "%s",
+					      utsname()->nodename)) {
+					up_read(&uts_sem);
+					goto out_fail;
+				}
 				up_read(&uts_sem);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
 				break;
 			/* executable */
 			case 'e':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", current->comm);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%s", current->comm))
+					goto out_fail;
 				break;
 			/* core limit size */
 			case 'c':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", rlimit(RLIMIT_CORE));
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				if (cn_printf(cn, "%lu",
+					      rlimit(RLIMIT_CORE)))
+					goto out_fail;
 				break;
 			default:
 				break;
@@ -1553,15 +1599,21 @@ static int format_corename(char *corenam
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
-		rc = snprintf(out_ptr, out_end - out_ptr,
-			      ".%d", task_tgid_vnr(current));
-		if (rc > out_end - out_ptr)
-			goto out;
-		out_ptr += rc;
+		if (cn_printf(cn, ".%d", task_tgid_vnr(current)))
+			goto out_fail;
 	}
 out:
+	out_ptr = cn->corename + cn->used;
+	if (cn->used == cn->size)
+		if (expand_corename(cn))
+			goto out_fail;
+
+	out_ptr = cn->corename + cn->used;
 	*out_ptr = 0;
 	return ispipe;
+
+out_fail:
+	return -ENOMEM;
 }
 
 static int zap_process(struct task_struct *start, int exit_code)
@@ -1837,7 +1889,7 @@ static int umh_pipe_setup(struct subproc
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-	char corename[CORENAME_MAX_SIZE + 1];
+	struct core_name cn;
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	const struct cred *old_cred;
@@ -1892,7 +1944,13 @@ void do_coredump(long signr, int exit_co
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	ispipe = format_corename(corename, signr);
+	ispipe = format_corename(&cn, signr);
+
+	if (ispipe == -ENOMEM) {
+		printk(KERN_WARNING "format_corename failed\n");
+		printk(KERN_WARNING "Aborting core\n");
+		goto fail_corename;
+	}
 
  	if (ispipe) {
 		int dump_count;
@@ -1929,7 +1987,7 @@ void do_coredump(long signr, int exit_co
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, corename+1, NULL);
+		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
@@ -1942,7 +2000,7 @@ void do_coredump(long signr, int exit_co
 		argv_free(helper_argv);
 		if (retval) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
-			       corename);
+			       cn.corename);
 			goto close_fail;
  		}
 	} else {
@@ -1951,7 +2009,7 @@ void do_coredump(long signr, int exit_co
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
-		cprm.file = filp_open(corename,
+		cprm.file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 		if (IS_ERR(cprm.file))
@@ -1993,6 +2051,8 @@ fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	kfree(cn.corename);
+fail_corename:
 	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:
_

Patches currently in -mm which might be from dfeng@redhat.com are

core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch

