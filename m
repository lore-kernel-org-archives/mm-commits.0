From: akpm@linux-foundation.org
Subject: - documentation-make-headers_installtxt.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:13 -0700
Message-ID: <200710180704.l9I74DTV031532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756302AbXJRH3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Documentation/make/headers_install.txt
has been removed from the -mm tree.  Its filename was
     documentation-make-headers_installtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation/make/headers_install.txt
From: Rob Landley <rob@landley.net>

Some documentation for "make headers_install".

Signed-off-by: Rob Landley <rob@landley.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/make/headers_install.txt |   46 +++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN /dev/null Documentation/make/headers_install.txt
--- /dev/null
+++ a/Documentation/make/headers_install.txt
@@ -0,0 +1,46 @@
+Exporting kernel headers for use by userspace
+=============================================
+
+The "make headers_install" command exports the kernel's header files in a
+form suitable for use by userspace programs.
+
+The linux kernel's exported header files describe the API for user space
+programs attempting to use kernel services.  These kernel header files are
+used by the system's C library (such as glibc or uClibc) to define available
+system calls, as well as constants and structures to be used with these
+system calls.  The C library's header files include the kernel header files
+from the "linux" subdirectory.  The system's libc headers are usually
+installed at the default location /usr/include and the kernel headers in
+subdirectories under that (most notably /usr/include/linux and
+/usr/include/asm).
+
+Kernel headers are backwards compatible, but not forwards compatible.  This
+means that a program built against a C library using older kernel headers
+should run on a newer kernel (although it may not have access to new
+features), but a program built against newer kernel headers may not work on an
+older kernel.
+
+The "make headers_install" command can be run in the top level directory of the
+kernel source code (or using a standard out-of-tree build).  It takes two
+optional arguments:
+
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+
+ARCH indicates which architecture to produce headers for, and defaults to the
+current architecture.  The linux/asm directory of the exported kernel headers
+is platform-specific, to see a complete list of supported architectures use
+the command:
+
+  ls -d include/asm-* | sed 's/.*-//'
+
+INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
+"./usr/include".
+
+The command "make headers_install_all" exports headers for all architectures
+simultaneously.  (This is mostly of interest to distribution maintainers,
+who create an architecture-independent tarball from the resulting include
+directory.)  Remember to provide the appropriate linux/asm directory via "mv"
+or "ln -s" before building a C library with headers exported this way.
+
+The kernel header export infrastructure is maintained by David Woodhouse
+<dwmw2@infradead.org>.
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
