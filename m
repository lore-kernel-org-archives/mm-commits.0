From: akpm@linux-foundation.org
Subject: + uml-improved-error-handling-while-locating-temp-dir.patch added to -mm tree
Date: Wed, 06 Feb 2008 14:20:19 -0800
Message-ID: <200802062220.m16MKKbU000630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755217AbYBFWVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 17:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: meyering@redhat.com, jdike@linux.intel.com


The patch titled
     uml: improved error handling while locating temp dir
has been added to the -mm tree.  Its filename is
     uml-improved-error-handling-while-locating-temp-dir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: improved error handling while locating temp dir
From: Jim Meyering <meyering@redhat.com>

* arch/um/os-Linux/mem.c (make_tempfile): Don't deref NULL upon failed malloc.

* arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.

[ jdike - formatting cleanups, deleted obsolete comment ]

Signed-off-by: Jim Meyering <meyering@redhat.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/mem.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN arch/um/os-Linux/mem.c~uml-improved-error-handling-while-locating-temp-dir arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-improved-error-handling-while-locating-temp-dir
+++ a/arch/um/os-Linux/mem.c
@@ -162,11 +162,6 @@ found:
 	goto out;
 }
 
-/*
- * This proc still used in tt-mode
- * (file: kernel/tt/ptproxy/proxy.c, proc: start_debugger).
- * So it isn't 'static' yet.
- */
 static int __init make_tempfile(const char *template, char **out_tempname,
 				int do_unlink)
 {
@@ -175,10 +170,13 @@ static int __init make_tempfile(const ch
 
 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
-	if (!tempname)
-		goto out;
+	if (tempname == NULL)
+		return -1;
 
 	find_tempdir();
+	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
+		return -1;
+
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
@@ -196,9 +194,8 @@ static int __init make_tempfile(const ch
 	}
 	if (out_tempname) {
 		*out_tempname = tempname;
-	} else {
+	} else
 		free(tempname);
-	}
 	return fd;
 out:
 	free(tempname);
_

Patches currently in -mm which might be from meyering@redhat.com are

uml-improved-error-handling-while-locating-temp-dir.patch
