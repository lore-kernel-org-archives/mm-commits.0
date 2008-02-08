From: akpm@linux-foundation.org
Subject: - uml-improved-error-handling-while-locating-temp-dir.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:07 -0800
Message-ID: <200802082020.m18KKmmU011257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935359AbYBHUhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:37:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: meyering@redhat.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: improved error handling while locating temp dir
has been removed from the -mm tree.  Its filename was
     uml-improved-error-handling-while-locating-temp-dir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
