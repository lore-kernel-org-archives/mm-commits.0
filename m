From: akpm@linux-foundation.org
Subject: + arch-um-os-linux-mainc-fix-memory-leaks.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:38:44 -0700
Message-ID: <200804012238.m31MciEj017294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYDAWiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     arch/um/os-Linux/main.c: fix memory leaks
has been added to the -mm tree.  Its filename is
     arch-um-os-linux-mainc-fix-memory-leaks.patch

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
Subject: arch/um/os-Linux/main.c: fix memory leaks
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix possible memory leaks in the main() function of arch/um/os-Linux/main.c.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/main.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN arch/um/os-Linux/main.c~arch-um-os-linux-mainc-fix-memory-leaks arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~arch-um-os-linux-mainc-fix-memory-leaks
+++ a/arch/um/os-Linux/main.c
@@ -113,14 +113,10 @@ static void setup_env_path(void)
 
 extern void scan_elf_aux( char **envp);
 
-int __init main(int argc, char **argv, char **envp)
+static char** dup_argv(int argc, char **argv)
 {
+	int i;
 	char **new_argv;
-	int ret, i, err;
-
-	set_stklim();
-
-	setup_env_path();
 
 	new_argv = malloc((argc + 1) * sizeof(char *));
 	if (new_argv == NULL) {
@@ -135,6 +131,28 @@ int __init main(int argc, char **argv, c
 		}
 	}
 	new_argv[argc] = NULL;
+	return new_argv;
+}
+
+static void free_argv(int argc, char **argv)
+{
+	int i;
+	for (i = 0; i < argc; i++) {
+		free(argv[i]);
+	}
+	free(argv);
+}
+
+int __init main(int argc, char **argv, char **envp)
+{
+	char **new_argv;
+	int ret, i, err;
+
+	set_stklim();
+
+	setup_env_path();
+
+	new_argv = dup_argv(argc, argv);
 
 	/*
 	 * Allow these signals to bring down a UML if all other
@@ -185,6 +203,7 @@ int __init main(int argc, char **argv, c
 		perror("Failed to exec kernel");
 		ret = 1;
 	}
+	free_argv(argc, new_argv);
 	printf("\n");
 	return uml_exitcode;
 }
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
arch-um-os-linux-mainc-fix-memory-leaks.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

