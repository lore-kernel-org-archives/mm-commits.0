From: akpm@osdl.org
Subject: + uml-locking-comments-in-memory-and-tempfile-code.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:03:41 -0800
Message-ID: <200701250603.l0P63f32007575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbXAYGDo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: locking comments in memory and tempfile code
has been added to the -mm tree.  Its filename is
     uml-locking-comments-in-memory-and-tempfile-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: locking comments in memory and tempfile code
From: Jeff Dike <jdike@addtoit.com>

Locking comments and emacs comment removal in the low-level memory and
temp file code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/include/tempfile.h |   10 ----------
 arch/um/kernel/mem.c       |    3 ++-
 arch/um/os-Linux/mem.c     |    7 +++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

diff -puN arch/um/include/tempfile.h~uml-locking-comments-in-memory-and-tempfile-code arch/um/include/tempfile.h
--- a/arch/um/include/tempfile.h~uml-locking-comments-in-memory-and-tempfile-code
+++ a/arch/um/include/tempfile.h
@@ -9,13 +9,3 @@
 extern int make_tempfile(const char *template, char **tempname, int do_unlink);
 
 #endif
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/mem.c~uml-locking-comments-in-memory-and-tempfile-code arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-locking-comments-in-memory-and-tempfile-code
+++ a/arch/um/kernel/mem.c
@@ -24,8 +24,9 @@
 #include "init.h"
 #include "kern_constants.h"
 
-/* Changed during early boot */
+/* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
+/* allocated in paging_init and unchanged thereafter */
 unsigned long *empty_bad_page = NULL;
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long long highmem;
diff -puN arch/um/os-Linux/mem.c~uml-locking-comments-in-memory-and-tempfile-code arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-locking-comments-in-memory-and-tempfile-code
+++ a/arch/um/os-Linux/mem.c
@@ -20,7 +20,13 @@
 
 #include <sys/param.h>
 
+/* Modified by which_tmpdir, which is called during early boot */
 static char *default_tmpdir = "/tmp";
+
+/*
+ *  Modified when creating the physical memory file and when checking
+ * the tmp filesystem for usability, both happening during early boot.
+ */
 static char *tempdir = NULL;
 
 static void __init find_tempdir(void)
@@ -83,6 +89,7 @@ static int next(int fd, char *buf, int s
 	return 1;
 }
 
+/* which_tmpdir is called only during early boot */
 static int checked_tmpdir = 0;
 
 /* Look for a tmpfs mounted at /dev/shm.  I couldn't find a cleaner
_

Patches currently in -mm which might be from jdike@addtoit.com are

fix-uml-on-non-standard-vm-split-hosts.patch
uml-fix-mknod.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
