From: akpm@linux-foundation.org
Subject: + core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch added to -mm tree
Date: Tue, 24 Aug 2010 15:47:52 -0700
Message-ID: <201008242247.o7OMlq9q019344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383Ab0HXWsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 18:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com, oleg@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update
has been added to the -mm tree.  Its filename is
     core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch

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
Subject: core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update
From: Xiaotian Feng <dfeng@redhat.com>

Changes since v3:
make handling of single char also uses cn_printf, suggested by Andrew Morton.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   78 ++++++++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 51 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update fs/exec.c
--- a/fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update
+++ a/fs/exec.c
@@ -1473,8 +1473,6 @@ static int cn_printf(struct core_name *c
 	int ret;
 	va_list arg;
 
-	cur = cn->corename + cn->used;
-
 	va_start(arg, fmt);
 	need = vsnprintf(NULL, 0, fmt, arg);
 	va_end(arg);
@@ -1487,6 +1485,7 @@ static int cn_printf(struct core_name *c
 		goto expand_fail;
 
 out_printf:
+	cur = cn->corename + cn->used;
 	va_start(arg, fmt);
 	vsnprintf(cur, need + 1, fmt, arg);
 	va_end(arg);
@@ -1506,119 +1505,96 @@ static int format_corename(struct core_n
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
-	char *out_ptr;
 	int pid_in_pattern = 0;
+	int err = 0;
 
 	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
 	cn->corename = kmalloc(cn->size, GFP_KERNEL);
 	cn->used = 0;
 
 	if (!cn->corename)
-		goto out_fail;
+		return -ENOMEM;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (cn->used == cn->size)
-				if (expand_corename(cn))
-					goto out_fail;
-
-			out_ptr = cn->corename + cn->used;
-			*out_ptr = *pat_ptr++;
-			cn->used++;
+			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
+			/* single % at the end, drop that */
 			case 0:
+				err = cn_printf(cn, "%c", '\0');
+				if (err)
+					break;
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
-				if (cn->used == cn->size)
-					if (expand_corename(cn))
-						goto out_fail;
-
-				out_ptr = cn->corename + cn->used;
-				*out_ptr = '%';
-				cn->used++;
+				err = cn_printf(cn, "%c", '%');
 				break;
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				if (cn_printf(cn, "%d",
-					      task_tgid_vnr(current)))
-					goto out_fail;
+				err = cn_printf(cn, "%d",
+					      task_tgid_vnr(current));
 				break;
 			/* uid */
 			case 'u':
-				if (cn_printf(cn, "%d", cred->uid))
-					goto out_fail;
+				err = cn_printf(cn, "%d", cred->uid);
 				break;
 			/* gid */
 			case 'g':
-				if (cn_printf(cn, "%d", cred->gid))
-					goto out_fail;
+				err = cn_printf(cn, "%d", cred->gid);
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				if (cn_printf(cn, "%ld", signr))
-					goto out_fail;
+				err = cn_printf(cn, "%ld", signr);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
 				struct timeval tv;
 				do_gettimeofday(&tv);
-				if (cn_printf(cn, "%lu", tv.tv_sec))
-					goto out_fail;
+				err = cn_printf(cn, "%lu", tv.tv_sec);
 				break;
 			}
 			/* hostname */
 			case 'h':
 				down_read(&uts_sem);
-				if (cn_printf(cn, "%s",
-					      utsname()->nodename)) {
-					up_read(&uts_sem);
-					goto out_fail;
-				}
+				err = cn_printf(cn, "%s",
+					      utsname()->nodename);
 				up_read(&uts_sem);
 				break;
 			/* executable */
 			case 'e':
-				if (cn_printf(cn, "%s", current->comm))
-					goto out_fail;
+				err = cn_printf(cn, "%s", current->comm);
 				break;
 			/* core limit size */
 			case 'c':
-				if (cn_printf(cn, "%lu",
-					      rlimit(RLIMIT_CORE)))
-					goto out_fail;
+				err = cn_printf(cn, "%lu",
+					      rlimit(RLIMIT_CORE));
 				break;
 			default:
 				break;
 			}
 			++pat_ptr;
 		}
+
+		if (err)
+			return err;
 	}
+
 	/* Backward compatibility with core_uses_pid:
 	 *
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
-		if (cn_printf(cn, ".%d", task_tgid_vnr(current)))
-			goto out_fail;
+		err = cn_printf(cn, ".%d", task_tgid_vnr(current));
+		if (err)
+			return err;
 	}
 out:
-	out_ptr = cn->corename + cn->used;
-	if (cn->used == cn->size)
-		if (expand_corename(cn))
-			goto out_fail;
-
-	out_ptr = cn->corename + cn->used;
-	*out_ptr = 0;
 	return ispipe;
