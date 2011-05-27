From: akpm@linux-foundation.org
Subject: [merged] coredump-add-support-for-exe_file-in-core-name.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:36 -0700
Message-ID: <201105271956.p4RJuffQ017586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757156Ab1E0T5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     coredump: add support for exe_file in core name
has been removed from the -mm tree.  Its filename was
     coredump-add-support-for-exe_file-in-core-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: add support for exe_file in core name
From: Jiri Slaby <jslaby@suse.cz>

Now, exe_file is not proc FS dependent, so we can use it to name core
file.  So we add %E pattern for core file name cration which extract path
from mm_struct->exe_file.  Then it converts slashes to exclamation marks
and pastes the result to the core file name itself.

This is useful for environments where binary names are longer than 16
character (the current->comm limitation).  Also where there are binaries
with same name but in a different path.  Further in case the binery itself
changes its current->comm after exec.

So by doing (s/$/#/ -- # is treated as git comment):
$ sysctl kernel.core_pattern='core.%p.%e.%E'
$ ln /bin/cat cat45678901234567890
$ ./cat45678901234567890
^Z
$ rm cat45678901234567890
$ fg
^\Quit (core dumped)
$ ls core*

we now get:
core.2434.cat456789012345.!root!cat45678901234567890 (deleted)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    3 +-
 fs/exec.c                       |   38 ++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-support-for-exe_file-in-core-name Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-support-for-exe_file-in-core-name
+++ a/Documentation/sysctl/kernel.txt
@@ -161,7 +161,8 @@ core_pattern is used to specify a core d
 	%s	signal number
 	%t	UNIX time of dump
 	%h	hostname
-	%e	executable filename
+	%e	executable filename (may be shortened)
+	%E	executable path
 	%<OTHER> both are dropped
 . If the first character of the pattern is a '|', the kernel will treat
   the rest of the pattern as a command to run.  The core dump will be
diff -puN fs/exec.c~coredump-add-support-for-exe_file-in-core-name fs/exec.c
--- a/fs/exec.c~coredump-add-support-for-exe_file-in-core-name
+++ a/fs/exec.c
@@ -1623,6 +1623,41 @@ expand_fail:
 	return ret;
 }
 
+static int cn_print_exe_file(struct core_name *cn)
+{
+	struct file *exe_file;
+	char *pathbuf, *path, *p;
+	int ret;
+
+	exe_file = get_mm_exe_file(current->mm);
+	if (!exe_file)
+		return cn_printf(cn, "(unknown)");
+
+	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
+	if (!pathbuf) {
+		ret = -ENOMEM;
+		goto put_exe_file;
+	}
+
+	path = d_path(&exe_file->f_path, pathbuf, PATH_MAX);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto free_buf;
+	}
+
+	for (p = path; *p; p++)
+		if (*p == '/')
+			*p = '!';
+
+	ret = cn_printf(cn, "%s", path);
+
+free_buf:
+	kfree(pathbuf);
+put_exe_file:
+	fput(exe_file);
+	return ret;
+}
+
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
@@ -1694,6 +1729,9 @@ static int format_corename(struct core_n
 			case 'e':
 				err = cn_printf(cn, "%s", current->comm);
 				break;
+			case 'E':
+				err = cn_print_exe_file(cn);
+				break;
 			/* core limit size */
 			case 'c':
 				err = cn_printf(cn, "%lu",
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

