From: akpm@linux-foundation.org
Subject: - uml-fix-style-violations.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:27 -0800
Message-ID: <200702112249.l1BMnRP1015749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59866 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbXBKWt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: fix style violations
has been removed from the -mm tree.  Its filename was
     uml-fix-style-violations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix style violations
From: Jeff Dike <jdike@addtoit.com>

Fix a bunch of style violations in mem.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/mem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/mem.c~uml-fix-style-violations arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-fix-style-violations
+++ a/arch/um/os-Linux/mem.c
@@ -35,7 +35,8 @@ static void __init find_tempdir(void)
 	int i;
 	char *dir = NULL;
 
-	if(tempdir != NULL) return;	/* We've already been called */
+	if(tempdir != NULL) /* We've already been called */
+		return;
 	for(i = 0; dirs[i]; i++){
 		dir = getenv(dirs[i]);
 		if((dir != NULL) && (*dir != '\0'))
@@ -193,7 +194,7 @@ int make_tempfile(const char *template, 
 	} else {
 		free(tempname);
 	}
-	return(fd);
+	return fd;
 out:
 	free(tempname);
 	return -1;
@@ -238,7 +239,7 @@ int create_tmp_file(unsigned long long l
 		exit(1);
 	}
 
-	return(fd);
+	return fd;
 }
 
 int create_mem_file(unsigned long long len)
@@ -252,7 +253,7 @@ int create_mem_file(unsigned long long l
 		errno = -err;
 		perror("exec_close");
 	}
-	return(fd);
+	return fd;
 }
 
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
