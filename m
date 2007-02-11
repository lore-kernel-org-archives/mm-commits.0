From: akpm@linux-foundation.org
Subject: - uml-locking-comments-in-memory-and-tempfile-code.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:19 -0800
Message-ID: <200702112249.l1BMnJTi015728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59843 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbXBKWtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: locking comments in memory and tempfile code
has been removed from the -mm tree.  Its filename was
     uml-locking-comments-in-memory-and-tempfile-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: locking comments in memory and tempfile code
From: Jeff Dike <jdike@addtoit.com>

Locking comments and emacs comment removal in the low-level memory and
temp file code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
