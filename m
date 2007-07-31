From: akpm@linux-foundation.org
Subject: + uml-move-userspace-code-to-userspace-file.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:29:10 -0700
Message-ID: <200707310129.l6V1TA04008473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166AbXGaB31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: move userspace code to userspace file
has been added to the -mm tree.  Its filename is
     uml-move-userspace-code-to-userspace-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: move userspace code to userspace file
From: Jeff Dike <jdike@addtoit.com>

Move some code from a kernelspace file to a userspace file where it fits
better.  This enables some tidying which is the subject of a later patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |   48 ---------------------------------
 arch/um/drivers/chan_user.c |   49 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 48 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-move-userspace-code-to-userspace-file arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-move-userspace-code-to-userspace-file
+++ a/arch/um/drivers/chan_kern.c
@@ -89,54 +89,6 @@ static const struct chan_ops not_configg
 };
 #endif /* CONFIG_NOCONFIG_CHAN */
 
-void generic_close(int fd, void *unused)
-{
-	os_close_file(fd);
-}
-
-int generic_read(int fd, char *c_out, void *unused)
-{
-	int n;
-
-	n = os_read_file(fd, c_out, sizeof(*c_out));
-
-	if(n == -EAGAIN)
-		return 0;
-	else if(n == 0)
-		return -EIO;
-	return n;
-}
-
-/* XXX Trivial wrapper around os_write_file */
-
-int generic_write(int fd, const char *buf, int n, void *unused)
-{
-	return os_write_file(fd, buf, n);
-}
-
-int generic_window_size(int fd, void *unused, unsigned short *rows_out,
-			unsigned short *cols_out)
-{
-	int rows, cols;
-	int ret;
-
-	ret = os_window_size(fd, &rows, &cols);
-	if(ret < 0)
-		return ret;
-
-	ret = ((*rows_out != rows) || (*cols_out != cols));
-
-	*rows_out = rows;
-	*cols_out = cols;
-
-	return ret;
-}
-
-void generic_free(void *data)
-{
-	kfree(data);
-}
-
 static void tty_receive_char(struct tty_struct *tty, char ch)
 {
 	if(tty == NULL) return;
diff -puN arch/um/drivers/chan_user.c~uml-move-userspace-code-to-userspace-file arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-move-userspace-code-to-userspace-file
+++ a/arch/um/drivers/chan_user.c
@@ -19,6 +19,55 @@
 #include "os.h"
 #include "choose-mode.h"
 #include "mode.h"
+#include "um_malloc.h"
+
+void generic_close(int fd, void *unused)
+{
+	os_close_file(fd);
+}
+
+int generic_read(int fd, char *c_out, void *unused)
+{
+	int n;
+
+	n = os_read_file(fd, c_out, sizeof(*c_out));
+
+	if(n == -EAGAIN)
+		return 0;
+	else if(n == 0)
+		return -EIO;
+	return n;
+}
+
+/* XXX Trivial wrapper around os_write_file */
+
+int generic_write(int fd, const char *buf, int n, void *unused)
+{
+	return os_write_file(fd, buf, n);
+}
+
+int generic_window_size(int fd, void *unused, unsigned short *rows_out,
+			unsigned short *cols_out)
+{
+	int rows, cols;
+	int ret;
+
+	ret = os_window_size(fd, &rows, &cols);
+	if(ret < 0)
+		return ret;
+
+	ret = ((*rows_out != rows) || (*cols_out != cols));
+
+	*rows_out = rows;
+	*cols_out = cols;
+
+	return ret;
+}
+
+void generic_free(void *data)
+{
+	kfree(data);
+}
 
 int generic_console_write(int fd, const char *buf, int n)
 {
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
