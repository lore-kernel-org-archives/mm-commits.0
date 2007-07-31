From: akpm@linux-foundation.org
Subject: + uml-tidy-recently-moved-code.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:29:13 -0700
Message-ID: <200707310129.l6V1TDLO008478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756611AbXGaBaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: tidy recently-moved code
has been added to the -mm tree.  Its filename is
     uml-tidy-recently-moved-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: tidy recently-moved code
From: Jeff Dike <jdike@addtoit.com>

Now that the generic console operations are in a userspace file, we
can do the following:
	directly call into libc instead of through the os_* wrappers
	eliminate os_window_size since it has only one user

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c |   30 +++++++++++++++---------------
 arch/um/include/os.h        |    1 -
 arch/um/os-Linux/file.c     |   13 -------------
 3 files changed, 15 insertions(+), 29 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-tidy-recently-moved-code arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-tidy-recently-moved-code
+++ a/arch/um/drivers/chan_user.c
@@ -23,43 +23,43 @@
 
 void generic_close(int fd, void *unused)
 {
-	os_close_file(fd);
+	close(fd);
 }
 
 int generic_read(int fd, char *c_out, void *unused)
 {
 	int n;
 
-	n = os_read_file(fd, c_out, sizeof(*c_out));
-
-	if(n == -EAGAIN)
+	n = read(fd, c_out, sizeof(*c_out));
+	if (n > 0)
+		return n;
+	else if (errno == EAGAIN)
 		return 0;
-	else if(n == 0)
+	else if (n == 0)
 		return -EIO;
-	return n;
+	return -errno;
 }
 
-/* XXX Trivial wrapper around os_write_file */
+/* XXX Trivial wrapper around write */
 
 int generic_write(int fd, const char *buf, int n, void *unused)
 {
-	return os_write_file(fd, buf, n);
+	return write(fd, buf, n);
 }
 
 int generic_window_size(int fd, void *unused, unsigned short *rows_out,
 			unsigned short *cols_out)
 {
-	int rows, cols;
+	struct winsize size;
 	int ret;
 
-	ret = os_window_size(fd, &rows, &cols);
-	if(ret < 0)
-		return ret;
+	if(ioctl(fd, TIOCGWINSZ, &size) < 0)
+		return -errno;
 
-	ret = ((*rows_out != rows) || (*cols_out != cols));
+	ret = ((*rows_out != size.ws_row) || (*cols_out != size.ws_col));
 
-	*rows_out = rows;
-	*cols_out = cols;
+	*rows_out = size.ws_row;
+	*cols_out = size.ws_col;
 
 	return ret;
 }
diff -puN arch/um/include/os.h~uml-tidy-recently-moved-code arch/um/include/os.h
--- a/arch/um/include/os.h~uml-tidy-recently-moved-code
+++ a/arch/um/include/os.h
@@ -134,7 +134,6 @@ extern void os_print_error(int error, co
 extern int os_get_exec_close(int fd, int *close_on_exec);
 extern int os_set_exec_close(int fd, int close_on_exec);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
-extern int os_window_size(int fd, int *rows, int *cols);
 extern int os_new_tty_pgrp(int fd, int pid);
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
diff -puN arch/um/os-Linux/file.c~uml-tidy-recently-moved-code arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-tidy-recently-moved-code
+++ a/arch/um/os-Linux/file.c
@@ -101,19 +101,6 @@ int os_ioctl_generic(int fd, unsigned in
 	return err;
 }
 
-int os_window_size(int fd, int *rows, int *cols)
-{
-	struct winsize size;
-
-	if(ioctl(fd, TIOCGWINSZ, &size) < 0)
-		return -errno;
-
-	*rows = size.ws_row;
-	*cols = size.ws_col;
-
-	return 0;
-}
-
 int os_new_tty_pgrp(int fd, int pid)
 {
 	if(ioctl(fd, TIOCSCTTY, 0) < 0)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-console-should-handle-spurious-irqs.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
