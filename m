From: akpm@linux-foundation.org
Subject: [merged] uml-free-resources.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:42 -0700
Message-ID: <201107260753.p6Q7rj7a003259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1GZICy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 04:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, richard@nod.at, vitalivanov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: free resources
has been removed from the -mm tree.  Its filename was
     uml-free-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: free resources
From: Davidlohr Bueso <dave@gnu.org>

When creating the temp file there's a memory and file descriptor leak upon
error.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/mem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/os-Linux/mem.c~uml-free-resources arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-free-resources
+++ a/arch/um/os-Linux/mem.c
@@ -176,7 +176,7 @@ static int __init make_tempfile(const ch
 
 	find_tempdir();
 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
-		return -1;
+		goto out;
 
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
@@ -191,13 +191,15 @@ static int __init make_tempfile(const ch
 	}
 	if (do_unlink && (unlink(tempname) < 0)) {
 		perror("unlink");
-		goto out;
+		goto close;
 	}
 	if (out_tempname) {
 		*out_tempname = tempname;
 	} else
 		free(tempname);
 	return fd;
+close:
+	close(fd);
 out:
 	free(tempname);
 	return -1;
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch

