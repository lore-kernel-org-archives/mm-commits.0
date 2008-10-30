From: akpm@linux-foundation.org
Subject: - kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:48 -0700
Message-ID: <200810301904.m9UJ4mef024922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127AbYJ3TFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashutosh@chelsio.com, ashutosh.naik@gmail.com, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module
has been removed from the -mm tree.  Its filename was
     kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module
From: "Ashutosh Naik" <ashutosh@chelsio.com>

This fixes a compile time warning which occurs whenever a static library
is linked into a kernel module.  MODPOST tries to look for a
".<modulename>.cmd" file to look for its dependencies, but that file
doesn't exist or get generated for static libraries.

This patch prevents modpost from looking for a .cmd file when a module is
linked with a static library

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/sumversion.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN scripts/mod/sumversion.c~kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module scripts/mod/sumversion.c
--- a/scripts/mod/sumversion.c~kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module
+++ a/scripts/mod/sumversion.c
@@ -290,6 +290,15 @@ static int parse_file(const char *fname,
 	release_file(file, len);
 	return 1;
 }
+/* Check whether the file is a static library or not */
+static int is_static_library(const char *objfile)
+{
+	int len = strlen(objfile);
+	if (objfile[len - 2] == '.' && objfile[len - 1] == 'a')
+		return 1;
+	else
+		return 0;
+}
 
 /* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
  * figure out source file. */
@@ -420,7 +429,8 @@ void get_src_version(const char *modname
 	while ((fname = strsep(&sources, " ")) != NULL) {
 		if (!*fname)
 			continue;
-		if (!parse_source_files(fname, &md))
+		if (!(is_static_library(fname)) &&
+				!parse_source_files(fname, &md))
 			goto release;
 	}
 
_

Patches currently in -mm which might be from ashutosh@chelsio.com are

linux-next.patch

