From: akpm@linux-foundation.org
Subject: [merged] audit-execve-record-remove-bogus-newline.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:59 -0700
Message-ID: <200904061939.n36Jdxjp014121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbZDFTnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpirko@redhat.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: EXECVE record: remove bogus newline
has been removed from the -mm tree.  Its filename was
     audit-execve-record-remove-bogus-newline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: EXECVE record: remove bogus newline
From: Jiri Pirko <jpirko@redhat.com>

EXECVE records contain a newline after every argument.  auditd converts
"\n" to " " so you cannot see newlines even in raw logs, but they're there
nevertheless.  If you're not using auditd, you need to work round them. 
These '\n' chars are can be easily replaced by spaces when creating record
in kernel.  Note there is no need for trailing '\n' in an audit record.

record before this patch:
"type=EXECVE msg=audit(1231421801.566:31): argc=4 a0=\"./test\"\na1=\"a\"\na2=\"b\"\na3=\"c\"\n"

record after this patch:
"type=EXECVE msg=audit(1231421801.566:31): argc=4 a0=\"./test\" a1=\"a\" a2=\"b\" a3=\"c\""

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/auditsc.c~audit-execve-record-remove-bogus-newline kernel/auditsc.c
--- a/kernel/auditsc.c~audit-execve-record-remove-bogus-newline
+++ a/kernel/auditsc.c
@@ -1023,7 +1023,7 @@ static int audit_log_single_execve_arg(s
 {
 	char arg_num_len_buf[12];
 	const char __user *tmp_p = p;
-	/* how many digits are in arg_num? 3 is the length of a=\n */
+	/* how many digits are in arg_num? 3 is the length of " a=" */
 	size_t arg_num_len = snprintf(arg_num_len_buf, 12, "%d", arg_num) + 3;
 	size_t len, len_left, to_send;
 	size_t max_execve_audit_len = MAX_EXECVE_AUDIT_LEN;
@@ -1109,7 +1109,7 @@ static int audit_log_single_execve_arg(s
 		 * so we can be sure nothing was lost.
 		 */
 		if ((i == 0) && (too_long))
-			audit_log_format(*ab, "a%d_len=%zu ", arg_num,
+			audit_log_format(*ab, " a%d_len=%zu", arg_num,
 					 has_cntl ? 2*len : len);
 
 		/*
@@ -1129,7 +1129,7 @@ static int audit_log_single_execve_arg(s
 		buf[to_send] = '\0';
 
 		/* actually log it */
-		audit_log_format(*ab, "a%d", arg_num);
+		audit_log_format(*ab, " a%d", arg_num);
 		if (too_long)
 			audit_log_format(*ab, "[%d]", i);
 		audit_log_format(*ab, "=");
@@ -1137,7 +1137,6 @@ static int audit_log_single_execve_arg(s
 			audit_log_n_hex(*ab, buf, to_send);
 		else
 			audit_log_format(*ab, "\"%s\"", buf);
-		audit_log_format(*ab, "\n");
 
 		p += to_send;
 		len_left -= to_send;
@@ -1165,7 +1164,7 @@ static void audit_log_execve_info(struct
 
 	p = (const char __user *)axi->mm->arg_start;
 
-	audit_log_format(*ab, "argc=%d ", axi->argc);
+	audit_log_format(*ab, "argc=%d", axi->argc);
 
 	/*
 	 * we need some kernel buffer to hold the userspace args.  Just
_

Patches currently in -mm which might be from jpirko@redhat.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch

