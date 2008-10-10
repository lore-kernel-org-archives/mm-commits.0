From: akpm@linux-foundation.org
Subject: + kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:02:07 -0700
Message-ID: <200810102302.m9AN2774013854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbYJJXCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ashutosh@chelsio.com, ashutosh.naik@gmail.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module
has been added to the -mm tree.  Its filename is
     kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module
From: "Ashutosh Naik" <ashutosh@chelsio.com>

This patch prevents modpost to look for a .cmd file when a module is
linked with a static library

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/sumversion.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

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
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
+		return 1;
+	else
+		return 0;
+}
 
 /* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
  * figure out source file. */
@@ -420,7 +429,7 @@ void get_src_version(const char *modname
 	while ((fname = strsep(&sources, " ")) != NULL) {
 		if (!*fname)
 			continue;
-		if (!parse_source_files(fname, &md))
+		if (!(is_static_library(fname)) && !parse_source_files(fname, &md))
 			goto release;
 	}
 
_

Patches currently in -mm which might be from ashutosh@chelsio.com are

kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch

