From: akpm@linux-foundation.org
Subject: + coredump-add-%f-for-executable-filename.patch added to
 -mm tree
Date: Thu, 02 Jul 2020 22:10:18 -0700
Message-ID: <20200703051018.sTajv2lra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGCFKT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 01:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ytht.net@gmail.com


The patch titled
     Subject: coredump: add %f for executable filename.
has been added to the -mm tree.  Its filename is
     coredump-add-%f-for-executable-filename.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-add-%25f-for-executable-filename.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-add-%25f-for-executable-filename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lepton Wu <ytht.net@gmail.com>
Subject: coredump: add %f for executable filename.

The document reads "%e" should be "executable filename" while actually it
could be changed by things like pr_ctl PR_SET_NAME.  People who uses "%e"
in core_pattern get surprised when they find out they get thread name
instead of executable filename.

This is either a bug of document or a bug of code.  Since the behavior of
"%e" is there for long time, it could bring another surprise for users if
we "fix" the code.

So we just "fix" the document.  And more, for users who really need the
"executable filename" in core_pattern, we introduce a new "%f" for the
real executable filename.  We already have "%E" for executable path in
kernel, so just reuse most of its code for the new added "%f" format.

Link: http://lkml.kernel.org/r/20200701031432.2978761-1-ytht.net@gmail.com
Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    3 ++-
 fs/coredump.c                               |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~coredump-add-%f-for-executable-filename
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -164,7 +164,8 @@ core_pattern
 	%s		signal number
 	%t		UNIX time of dump
 	%h		hostname
-	%e		executable filename (may be shortened)
+	%e		executable filename (may be shortened, could be changed by prctl etc)
+	%f      	executable filename
 	%E		executable path
 	%c		maximum size of core file by resource limit RLIMIT_CORE
 	%<OTHER>	both are dropped
--- a/fs/coredump.c~coredump-add-%f-for-executable-filename
+++ a/fs/coredump.c
@@ -153,10 +153,10 @@ int cn_esc_printf(struct core_name *cn,
 	return ret;
 }
 
-static int cn_print_exe_file(struct core_name *cn)
+static int cn_print_exe_file(struct core_name *cn, bool name_only)
 {
 	struct file *exe_file;
-	char *pathbuf, *path;
+	char *pathbuf, *path, *ptr;
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
@@ -175,6 +175,11 @@ static int cn_print_exe_file(struct core
 		goto free_buf;
 	}
 
+	if (name_only) {
+		ptr = strrchr(path, '/');
+		if (ptr)
+			path = ptr + 1;
+	}
 	ret = cn_esc_printf(cn, "%s", path);
 
 free_buf:
@@ -301,12 +306,16 @@ static int format_corename(struct core_n
 					      utsname()->nodename);
 				up_read(&uts_sem);
 				break;
-			/* executable */
+			/* executable, could be changed by prctl PR_SET_NAME etc */
 			case 'e':
 				err = cn_esc_printf(cn, "%s", current->comm);
 				break;
+			/* file name of executable */
+			case 'f':
+				err = cn_print_exe_file(cn, true);
+				break;
 			case 'E':
-				err = cn_print_exe_file(cn);
+				err = cn_print_exe_file(cn, false);
 				break;
 			/* core limit size */
 			case 'c':
_

Patches currently in -mm which might be from ytht.net@gmail.com are

coredump-add-%f-for-executable-filename.patch
