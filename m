From: akpm@linux-foundation.org
Subject: - uml-move-remaining-useful-contents-of-user_utilh.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:21 -0700
Message-ID: <200705080006.l4806L8i009182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967481AbXEHALt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: move remaining useful contents of user_util.h
has been removed from the -mm tree.  Its filename was
     uml-move-remaining-useful-contents-of-user_utilh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: move remaining useful contents of user_util.h
From: Jeff Dike <jdike@addtoit.com>

Rescue the useful contents of the soon-to-be-gone user-util.h.

pty.c now gets ptsname from stdlib.h like it should have always done.

CATCH_EINTR is now in os.h, although perhaps all usage should be under
os-Linux at some point.

get_pty is also in os.h.

This patch restores the old definition of ARRAY_SIZE in user.h.  This file is
included only in userspace files, so there will be no conflict with the
kernel's new ARRAY_SIZE.  The copy of the kernel's ARRAY_SIZE and associated
infrastructure is now gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/pty.c           |    1 +
 arch/um/include/os.h            |    6 ++++++
 arch/um/include/user.h          |   19 ++++++++-----------
 arch/um/include/user_util.h     |   18 ------------------
 arch/um/os-Linux/sys-i386/tls.c |    1 +
 5 files changed, 16 insertions(+), 29 deletions(-)

diff -puN arch/um/drivers/pty.c~uml-move-remaining-useful-contents-of-user_utilh arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-move-remaining-useful-contents-of-user_utilh
+++ a/arch/um/drivers/pty.c
@@ -4,6 +4,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
diff -puN arch/um/include/os.h~uml-move-remaining-useful-contents-of-user_utilh arch/um/include/os.h
--- a/arch/um/include/os.h~uml-move-remaining-useful-contents-of-user_utilh
+++ a/arch/um/include/os.h
@@ -16,6 +16,8 @@
 #include "sysdep/tls.h"
 #include "sysdep/archsetjmp.h"
 
+#define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
+
 #define OS_TYPE_FILE 1
 #define OS_TYPE_DIR 2
 #define OS_TYPE_SYMLINK 3
@@ -341,6 +343,10 @@ extern void maybe_sigio_broken(int fd, i
 extern void sig_handler_common_skas(int sig, void *sc_ptr);
 extern void user_signal(int sig, union uml_pt_regs *regs, int pid);
 
+/* sys-x86_64/prctl.c */
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
 
+/* tty.c */
+int get_pty(void);
+
 #endif
diff -puN arch/um/include/user.h~uml-move-remaining-useful-contents-of-user_utilh arch/um/include/user.h
--- a/arch/um/include/user.h~uml-move-remaining-useful-contents-of-user_utilh
+++ a/arch/um/include/user.h
@@ -6,6 +6,14 @@
 #ifndef __USER_H__
 #define __USER_H__
 
+/*
+ * The usual definition - copied here because the kernel provides its own,
+ * fancier, type-safe, definition.  Using that one would require
+ * copying too much infrastructure for my taste, so userspace files
+ * get less checking than kernel files.
+ */
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 extern int printk(const char *fmt, ...)
@@ -18,14 +26,3 @@ extern unsigned long strlcpy(char *, con
 extern unsigned long strlcat(char *, const char *, unsigned long);
 
 #endif
-
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
diff -puN arch/um/include/user_util.h~uml-move-remaining-useful-contents-of-user_utilh arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-move-remaining-useful-contents-of-user_utilh
+++ a/arch/um/include/user_util.h
@@ -8,31 +8,13 @@
 
 #include "sysdep/ptrace.h"
 
-/* Copied from kernel.h and compiler-gcc.h */
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
-
-/* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a) \
-  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
-
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
-
-#define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
-
 extern int mode_tt;
 
 extern int grantpt(int __fd);
 extern int unlockpt(int __fd);
-extern char *ptsname(int __fd);
 
 extern void *add_signal_handler(int sig, void (*handler)(int));
 extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
-extern int get_pty(void);
 extern int switcheroo(int fd, int prot, void *from, void *to, int size);
 extern void do_exec(int old_pid, int new_pid);
 extern void tracer_panic(char *msg, ...)
diff -puN arch/um/os-Linux/sys-i386/tls.c~uml-move-remaining-useful-contents-of-user_utilh arch/um/os-Linux/sys-i386/tls.c
--- a/arch/um/os-Linux/sys-i386/tls.c~uml-move-remaining-useful-contents-of-user_utilh
+++ a/arch/um/os-Linux/sys-i386/tls.c
@@ -5,6 +5,7 @@
 #include <unistd.h>
 
 #include "sysdep/tls.h"
+#include "user.h"
 #include "user_util.h"
 
 /* Checks whether host supports TLS, and sets *tls_min according to the value
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
