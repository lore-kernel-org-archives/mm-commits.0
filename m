From: akpm@linux-foundation.org
Subject: + um-fix-uml_lib_path.patch added to -mm tree
Date: Fri, 13 May 2011 10:55:23 -0700
Message-ID: <201105131747.p4DHllQH030015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab1EMRsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 May 2011 13:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: fix UML_LIB_PATH
has been added to the -mm tree.  Its filename is
     um-fix-uml_lib_path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch
um-fix-uml_lib_path.patch
um-fix-abort.patch
um-remove-sighup-handler.patch
um-os_dump_core-cleanup.patch
lib-consolidate-debug_stack_usage-option.patch

