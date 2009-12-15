From: akpm@linux-foundation.org
Subject: [merged] vt-introduce-and-use-vt_kmsg_redirect-function.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:43 -0800
Message-ID: <200912152156.nBFLuhSF015664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761295AbZLOV5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernhard@bwalle.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     vt: introduce and use vt_kmsg_redirect() function
has been removed from the -mm tree.  Its filename was
     vt-introduce-and-use-vt_kmsg_redirect-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: introduce and use vt_kmsg_redirect() function
From: Bernhard Walle <bernhard@bwalle.de>

The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
redirect the kernel messages to a specific console.

However, since it's not possible to switch to the kernel message console
after a panic(), it would be nice if the kernel would print the panic
message on the current console.

This patch series adds a new interface to access the global kmsg_redirect
variable by a function to be able to use it in code where
CONFIG_VT_CONSOLE is not set (kernel/panic.c).



This patch:

Instead of using and exporting a global value kmsg_redirect, introduce a
function vt_kmsg_redirect() that both can set and return the console where
messages are printed.

Change all users of kmsg_redirect (the VT code itself and kernel/power.c)
to the new interface.

The main advantage is that vt_kmsg_redirect() can also be used when
CONFIG_VT_CONSOLE is not set.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c      |   43 +++++++++++++++++++++++++++++++++------
 include/linux/tty.h    |    2 -
 include/linux/vt.h     |   15 +++++++++++++
 kernel/power/console.c |    7 ++----
 4 files changed, 55 insertions(+), 12 deletions(-)

diff -puN drivers/char/vt.c~vt-introduce-and-use-vt_kmsg_redirect-function drivers/char/vt.c
--- a/drivers/char/vt.c~vt-introduce-and-use-vt_kmsg_redirect-function
+++ a/drivers/char/vt.c
@@ -184,12 +184,10 @@ static DECLARE_WORK(console_work, consol
  * fg_console is the current virtual console,
  * last_console is the last used one,
  * want_console is the console we want to switch to,
- * kmsg_redirect is the console for kernel messages,
  */
 int fg_console;
 int last_console;
 int want_console = -1;
-int kmsg_redirect;
 
 /*
  * For each existing display, we have a pointer to console currently visible
@@ -2434,6 +2432,37 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
+/**
+ * vt_kmsg_redirect() - Sets/gets the kernel message console
+ * @new:	The new virtual terminal number or -1 if the console should stay
+ * 		unchanged
+ *
+ * By default, the kernel messages are always printed on the current virtual
+ * console. However, the user may modify that default with the
+ * TIOCL_SETKMSGREDIRECT ioctl call.
+ *
+ * This function sets the kernel message console to be @new. It returns the old
+ * virtual console number. The virtual terminal number 0 (both as parameter and
+ * return value) means no redirection (i.e. always printed on the currently
+ * active console).
+ *
+ * The parameter -1 means that only the current console is returned, but the
+ * value is not modified. You may use the macro vt_get_kmsg_redirect() in that
+ * case to make the code more understandable.
+ *
+ * When the kernel is compiled without CONFIG_VT_CONSOLE, this function ignores
+ * the parameter and always returns 0.
+ */
+int vt_kmsg_redirect(int new)
+{
+	static int kmsg_con;
+
+	if (new != -1)
+		return xchg(&kmsg_con, new);
+	else
+		return kmsg_con;
+}
+
 /*
  *	Console on virtual terminal
  *
@@ -2448,6 +2477,7 @@ static void vt_console_print(struct cons
 	const ushort *start;
 	ushort cnt = 0;
 	ushort myx;
+	int kmsg_console;
 
 	/* console busy or not yet initialized */
 	if (!printable)
@@ -2455,8 +2485,9 @@ static void vt_console_print(struct cons
 	if (!spin_trylock(&printing_lock))
 		return;
 
-	if (kmsg_redirect && vc_cons_allocated(kmsg_redirect - 1))
-		vc = vc_cons[kmsg_redirect - 1].d;
+	kmsg_console = vt_get_kmsg_redirect();
+	if (kmsg_console && vc_cons_allocated(kmsg_console - 1))
+		vc = vc_cons[kmsg_console - 1].d;
 
 	/* read `x' only after setting currcons properly (otherwise
 	   the `x' macro will read the x of the foreground console). */
@@ -2613,7 +2644,7 @@ int tioclinux(struct tty_struct *tty, un
 			ret = set_vesa_blanking(p);
 			break;
 		case TIOCL_GETKMSGREDIRECT:
-			data = kmsg_redirect;
+			data = vt_get_kmsg_redirect();
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_SETKMSGREDIRECT:
@@ -2623,7 +2654,7 @@ int tioclinux(struct tty_struct *tty, un
 				if (get_user(data, p+1))
 					ret = -EFAULT;
 				else
-					kmsg_redirect = data;
+					vt_kmsg_redirect(data);
 			}
 			break;
 		case TIOCL_GETFGCONSOLE:
diff -puN include/linux/tty.h~vt-introduce-and-use-vt_kmsg_redirect-function include/linux/tty.h
--- a/include/linux/tty.h~vt-introduce-and-use-vt_kmsg_redirect-function
+++ a/include/linux/tty.h
@@ -350,8 +350,6 @@ extern void tty_write_flush(struct tty_s
 
 extern struct ktermios tty_std_termios;
 
-extern int kmsg_redirect;
-
 extern void console_init(void);
 extern int vcs_init(void);
 
diff -puN include/linux/vt.h~vt-introduce-and-use-vt_kmsg_redirect-function include/linux/vt.h
--- a/include/linux/vt.h~vt-introduce-and-use-vt_kmsg_redirect-function
+++ a/include/linux/vt.h
@@ -84,4 +84,19 @@ struct vt_setactivate {
 
 #define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
 
+#ifdef CONFIG_VT_CONSOLE
+
+extern int vt_kmsg_redirect(int new);
+
+#else
+
+static inline int vt_kmsg_redirect(int new)
+{
+	return 0;
+}
+
+#endif
+
+#define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
+
 #endif /* _LINUX_VT_H */
diff -puN kernel/power/console.c~vt-introduce-and-use-vt_kmsg_redirect-function kernel/power/console.c
--- a/kernel/power/console.c~vt-introduce-and-use-vt_kmsg_redirect-function
+++ a/kernel/power/console.c
@@ -6,7 +6,7 @@
 
 #include <linux/vt_kern.h>
 #include <linux/kbd_kern.h>
-#include <linux/console.h>
+#include <linux/vt.h>
 #include <linux/module.h>
 #include "power.h"
 
@@ -21,8 +21,7 @@ int pm_prepare_console(void)
 	if (orig_fgconsole < 0)
 		return 1;
 
-	orig_kmsg = kmsg_redirect;
-	kmsg_redirect = SUSPEND_CONSOLE;
+	orig_kmsg = vt_kmsg_redirect(SUSPEND_CONSOLE);
 	return 0;
 }
 
@@ -30,7 +29,7 @@ void pm_restore_console(void)
 {
 	if (orig_fgconsole >= 0) {
 		vt_move_to_console(orig_fgconsole, 0);
-		kmsg_redirect = orig_kmsg;
+		vt_kmsg_redirect(orig_kmsg);
 	}
 }
 #endif
_

Patches currently in -mm which might be from bernhard@bwalle.de are

origin.patch

