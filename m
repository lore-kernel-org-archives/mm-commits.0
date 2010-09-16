From: akpm@linux-foundation.org
Subject: + fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:49:35 -0700
Message-ID: <201009161949.o8GJnZsM010136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab0IPTuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wad@chromium.org, ebiederm@xmission.com, nhorman@tuxdriver.com, oleg@redhat.com, roland@redhat.com


The patch titled
     fs/exec.c: provide the correct process pid to the pipe helper
has been added to the -mm tree.  Its filename is
     fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

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
Subject: fs/exec.c: provide the correct process pid to the pipe helper
From: Will Drewry <wad@chromium.org>

format_corename() uses task_tgid_vnr to provide the numeric pid of a
core-dumping process.  For file-based coredumps, this is perfectly
satisfactory.  However, when the core_pattern contains a pipe, the
substituted PID is invalid in the namespace of the core_pattern pipe
helper, the init namespace.

By changing this, any core collector may now find the process in the init
namespace /proc.  This helps with VFS namespacing too since the mount root
is available via /proc.  Unfortunately, it does not help in cases of more
complex namespacing, like net namespaces.  For that, the helper thread
will need to be migrated to the core-dump namespaces.

I have a separate patch series which implements migrating the
____call_usermodehelper thread to the coredump namespace, but it adds a
fair amount of complexity which might be better handled by someone who
understands that code.  I'm happy to mail it out as well though (it works,
but I don't assign a namespaced pid which may open up issues on its own).

Signed-off-by: Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-provide-the-correct-process-pid-to-the-pipe-helper fs/exec.c
--- a/fs/exec.c~fs-execc-provide-the-correct-process-pid-to-the-pipe-helper
+++ a/fs/exec.c
@@ -1467,6 +1467,13 @@ static int format_corename(char *corenam
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
+	pid_t pid = task_tgid_vnr(current);
+
+	/* The pipe helper runs in the init namespace and should
+	 * receive the matching pid until that changes.
+	 */
+	if (ispipe)
+		pid = task_tgid_nr(current);
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1489,7 +1496,7 @@ static int format_corename(char *corenam
 			case 'p':
 				pid_in_pattern = 1;
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", task_tgid_vnr(current));
+					      "%d", pid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1568,7 +1575,7 @@ static int format_corename(char *corenam
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
-			      ".%d", task_tgid_vnr(current));
+			      ".%d", pid);
 		if (rc > out_end - out_ptr)
 			goto out;
 		out_ptr += rc;
_

Patches currently in -mm which might be from wad@chromium.org are

linux-next.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

