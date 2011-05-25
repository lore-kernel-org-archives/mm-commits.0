From: akpm@linux-foundation.org
Subject: [merged] um-fix-uml_lib_path.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:53 -0700
Message-ID: <201105252029.p4PKTHrN014829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126Ab1EYU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: fix UML_LIB_PATH
has been removed from the -mm tree.  Its filename was
     um-fix-uml_lib_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix UML_LIB_PATH
From: Richard Weinberger <richard@nod.at>

UML_LIB_PATH is hardcoded to /usr/lib/uml/, on 64bit systems UML_LIB_PATH
needs to be /usr/lib64/uml/.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/xterm.c     |    2 +-
 arch/um/include/shared/os.h |    6 ++++++
 arch/um/os-Linux/main.c     |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/xterm.c~um-fix-uml_lib_path arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~um-fix-uml_lib_path
+++ a/arch/um/drivers/xterm.c
@@ -90,7 +90,7 @@ static int xterm_open(int input, int out
 	int pid, fd, new, err;
 	char title[256], file[] = "/tmp/xterm-pipeXXXXXX";
 	char *argv[] = { terminal_emulator, title_switch, title, exec_switch,
-			 "/usr/lib/uml/port-helper", "-uml-socket",
+			 OS_LIB_PATH "/uml/port-helper", "-uml-socket",
 			 file, NULL };
 
 	if (access(argv[4], X_OK) < 0)
diff -puN arch/um/include/shared/os.h~um-fix-uml_lib_path arch/um/include/shared/os.h
--- a/arch/um/include/shared/os.h~um-fix-uml_lib_path
+++ a/arch/um/include/shared/os.h
@@ -29,6 +29,12 @@
 #define OS_ACC_R_OK    4       /* Test for read permission.  */
 #define OS_ACC_RW_OK   (OS_ACC_W_OK | OS_ACC_R_OK) /* Test for RW permission */
 
+#ifdef CONFIG_64BIT
+#define OS_LIB_PATH	"/usr/lib64/"
+#else
+#define OS_LIB_PATH	"/usr/lib/"
+#endif
+
 /*
  * types taken from stat_file() in hostfs_user.c
  * (if they are wrong here, they are wrong there...).
diff -puN arch/um/os-Linux/main.c~um-fix-uml_lib_path arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~um-fix-uml_lib_path
+++ a/arch/um/os-Linux/main.c
@@ -78,7 +78,7 @@ static void install_fatal_handler(int si
 	}
 }
 
-#define UML_LIB_PATH	":/usr/lib/uml"
+#define UML_LIB_PATH	":" OS_LIB_PATH "/uml"
 
 static void setup_env_path(void)
 {
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

