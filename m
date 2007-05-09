From: akpm@linux-foundation.org
Subject: + consolidate-asm-pollh.patch added to -mm tree
Date: Wed, 09 May 2007 13:44:59 -0700
Message-ID: <200705092044.l49KixBQ000608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbXEIUpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux-arch@vger.kernel.org


The patch titled
     Consolidate asm/poll.h
has been added to the -mm tree.  Its filename is
     consolidate-asm-pollh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Consolidate asm/poll.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

These files are almost all the same.

This patch could be made even simpler if we don't mind POLLREMOVE turning
up in a few architectures that didn't have it previously (which should be
OK as POLLREMOVE is not used anywhere in the current tree).

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/poll.h   |   26 ------------------------
 include/asm-arm/poll.h     |   28 --------------------------
 include/asm-arm26/poll.h   |   22 +-------------------
 include/asm-avr32/poll.h   |   28 --------------------------
 include/asm-cris/poll.h    |   27 -------------------------
 include/asm-frv/poll.h     |   18 ++---------------
 include/asm-generic/Kbuild |    1 
 include/asm-generic/poll.h |   37 +++++++++++++++++++++++++++++++++++
 include/asm-h8300/poll.h   |   18 ++---------------
 include/asm-i386/poll.h    |   28 --------------------------
 include/asm-ia64/poll.h    |   33 -------------------------------
 include/asm-m32r/poll.h    |   33 -------------------------------
 include/asm-m68k/poll.h    |   17 ----------------
 include/asm-mips/poll.h    |   21 -------------------
 include/asm-parisc/poll.h  |   28 --------------------------
 include/asm-powerpc/poll.h |   25 -----------------------
 include/asm-s390/poll.h    |   36 ----------------------------------
 include/asm-sh/poll.h      |   28 --------------------------
 include/asm-sh64/poll.h    |   33 +------------------------------
 include/asm-sparc/poll.h   |   14 -------------
 include/asm-sparc64/poll.h |   14 -------------
 include/asm-v850/poll.h    |   17 ----------------
 include/asm-x86_64/poll.h  |   28 --------------------------
 include/asm-xtensa/poll.h  |   20 ------------------
 24 files changed, 66 insertions(+), 514 deletions(-)

diff -puN include/asm-alpha/poll.h~consolidate-asm-pollh include/asm-alpha/poll.h
--- a/include/asm-alpha/poll.h~consolidate-asm-pollh
+++ a/include/asm-alpha/poll.h
@@ -1,25 +1 @@
-#ifndef __ALPHA_POLL_H
-#define __ALPHA_POLL_H
-
-#define POLLIN		(1 << 0)
-#define POLLPRI		(1 << 1)
-#define POLLOUT		(1 << 2)
-#define POLLERR		(1 << 3)
-#define POLLHUP		(1 << 4)
-#define POLLNVAL	(1 << 5)
-#define POLLRDNORM	(1 << 6)
-#define POLLRDBAND	(1 << 7)
-#define POLLWRNORM	(1 << 8)
-#define POLLWRBAND	(1 << 9)
-#define POLLMSG		(1 << 10)
-#define POLLREMOVE	(1 << 12)
-#define POLLRDHUP       (1 << 13)
-
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-arm/poll.h~consolidate-asm-pollh include/asm-arm/poll.h
--- a/include/asm-arm/poll.h~consolidate-asm-pollh
+++ a/include/asm-arm/poll.h
@@ -1,27 +1 @@
-#ifndef __ASMARM_POLL_H
-#define __ASMARM_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-arm26/poll.h~consolidate-asm-pollh include/asm-arm26/poll.h
--- a/include/asm-arm26/poll.h~consolidate-asm-pollh
+++ a/include/asm-arm26/poll.h
@@ -1,26 +1,8 @@
 #ifndef __ASMARM_POLL_H
 #define __ASMARM_POLL_H
 
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
+#include <asm-generic/poll.h>
 
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#undef POLLREMOVE
 
 #endif
diff -puN include/asm-avr32/poll.h~consolidate-asm-pollh include/asm-avr32/poll.h
--- a/include/asm-avr32/poll.h~consolidate-asm-pollh
+++ a/include/asm-avr32/poll.h
@@ -1,27 +1 @@
-#ifndef __ASM_AVR32_POLL_H
-#define __ASM_AVR32_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP	0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* __ASM_AVR32_POLL_H */
+#include <asm-generic/poll.h>
diff -puN include/asm-cris/poll.h~consolidate-asm-pollh include/asm-cris/poll.h
--- a/include/asm-cris/poll.h~consolidate-asm-pollh
+++ a/include/asm-cris/poll.h
@@ -1,26 +1 @@
-#ifndef __ASM_CRIS_POLL_H
-#define __ASM_CRIS_POLL_H
-
-/* taken from asm-alpha */
-
-#define POLLIN		1
-#define POLLPRI		2
-#define POLLOUT		4
-#define POLLERR		8
-#define POLLHUP		16
-#define POLLNVAL	32
-#define POLLRDNORM	64
-#define POLLRDBAND	128
-#define POLLWRNORM	256
-#define POLLWRBAND	512
-#define POLLMSG		1024
-#define POLLREMOVE	4096
-#define POLLRDHUP       8192
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-frv/poll.h~consolidate-asm-pollh include/asm-frv/poll.h
--- a/include/asm-frv/poll.h~consolidate-asm-pollh
+++ a/include/asm-frv/poll.h
@@ -1,24 +1,12 @@
 #ifndef _ASM_POLL_H
 #define _ASM_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
+
+#undef POLLREMOVE
 
 #endif
 
diff -puN include/asm-generic/Kbuild~consolidate-asm-pollh include/asm-generic/Kbuild
--- a/include/asm-generic/Kbuild~consolidate-asm-pollh
+++ a/include/asm-generic/Kbuild
@@ -4,6 +4,7 @@ header-y += fcntl.h
 header-y += ioctl.h
 header-y += ipc.h
 header-y += mman.h
+header-y += poll.h
 header-y += signal.h
 header-y += statfs.h
 
diff -puN /dev/null include/asm-generic/poll.h
--- /dev/null
+++ a/include/asm-generic/poll.h
@@ -0,0 +1,37 @@
+#ifndef __ASM_GENERIC_POLL_H
+#define __ASM_GENERIC_POLL_H
+
+/* These are specified by iBCS2 */
+#define POLLIN		0x0001
+#define POLLPRI		0x0002
+#define POLLOUT		0x0004
+#define POLLERR		0x0008
+#define POLLHUP		0x0010
+#define POLLNVAL	0x0020
+
+/* The rest seem to be more-or-less nonstandard. Check them! */
+#define POLLRDNORM	0x0040
+#define POLLRDBAND	0x0080
+#ifndef POLLWRNORM
+#define POLLWRNORM	0x0100
+#endif
+#ifndef POLLWRBAND
+#define POLLWRBAND	0x0200
+#endif
+#ifndef POLLMSG
+#define POLLMSG		0x0400
+#endif
+#ifndef POLLREMOVE
+#define POLLREMOVE	0x1000
+#endif
+#ifndef POLLRDHUP
+#define POLLRDHUP       0x2000
+#endif
+
+struct pollfd {
+	int fd;
+	short events;
+	short revents;
+};
+
+#endif	/* __ASM_GENERIC_POLL_H */
diff -puN include/asm-h8300/poll.h~consolidate-asm-pollh include/asm-h8300/poll.h
--- a/include/asm-h8300/poll.h~consolidate-asm-pollh
+++ a/include/asm-h8300/poll.h
@@ -1,23 +1,11 @@
 #ifndef __H8300_POLL_H
 #define __H8300_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
+
+#undef POLLREMOVE
 
 #endif
diff -puN include/asm-i386/poll.h~consolidate-asm-pollh include/asm-i386/poll.h
--- a/include/asm-i386/poll.h~consolidate-asm-pollh
+++ a/include/asm-i386/poll.h
@@ -1,27 +1 @@
-#ifndef __i386_POLL_H
-#define __i386_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-ia64/poll.h~consolidate-asm-pollh include/asm-ia64/poll.h
--- a/include/asm-ia64/poll.h~consolidate-asm-pollh
+++ a/include/asm-ia64/poll.h
@@ -1,32 +1 @@
-#ifndef _ASM_IA64_POLL_H
-#define _ASM_IA64_POLL_H
-
-/*
- * poll(2) bit definitions.  Based on <asm-i386/poll.h>.
- *
- * Modified 1998, 1999, 2002
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
- */
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* _ASM_IA64_POLL_H */
+#include <asm-generic/poll.h>
diff -puN include/asm-m32r/poll.h~consolidate-asm-pollh include/asm-m32r/poll.h
--- a/include/asm-m32r/poll.h~consolidate-asm-pollh
+++ a/include/asm-m32r/poll.h
@@ -1,32 +1 @@
-#ifndef _ASM_M32R_POLL_H
-#define _ASM_M32R_POLL_H
-
-/*
- * poll(2) bit definitions.  Based on <asm-i386/poll.h>.
- *
- * Modified 2004
- *      Hirokazu Takata <takata at linux-m32r.org>
- */
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif  /* _ASM_M32R_POLL_H */
+#include <asm-generic/poll.h>
diff -puN include/asm-m68k/poll.h~consolidate-asm-pollh include/asm-m68k/poll.h
--- a/include/asm-m68k/poll.h~consolidate-asm-pollh
+++ a/include/asm-m68k/poll.h
@@ -1,24 +1,9 @@
 #ifndef __m68k_POLL_H
 #define __m68k_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff -puN include/asm-mips/poll.h~consolidate-asm-pollh include/asm-mips/poll.h
--- a/include/asm-mips/poll.h~consolidate-asm-pollh
+++ a/include/asm-mips/poll.h
@@ -1,28 +1,9 @@
 #ifndef __ASM_POLL_H
 #define __ASM_POLL_H
 
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
 #define POLLWRNORM	POLLOUT
 #define POLLWRBAND	0x0100
 
-/* These seem to be more or less nonstandard ...  */
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* __ASM_POLL_H */
diff -puN include/asm-parisc/poll.h~consolidate-asm-pollh include/asm-parisc/poll.h
--- a/include/asm-parisc/poll.h~consolidate-asm-pollh
+++ a/include/asm-parisc/poll.h
@@ -1,27 +1 @@
-#ifndef __PARISC_POLL_H
-#define __PARISC_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-powerpc/poll.h~consolidate-asm-pollh include/asm-powerpc/poll.h
--- a/include/asm-powerpc/poll.h~consolidate-asm-pollh
+++ a/include/asm-powerpc/poll.h
@@ -1,24 +1 @@
-#ifndef _ASM_POWERPC_POLL_H
-#define _ASM_POWERPC_POLL_H
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif	/* _ASM_POWERPC_POLL_H */
+#include <asm-generic/poll.h>
diff -puN include/asm-s390/poll.h~consolidate-asm-pollh include/asm-s390/poll.h
--- a/include/asm-s390/poll.h~consolidate-asm-pollh
+++ a/include/asm-s390/poll.h
@@ -1,35 +1 @@
-/*
- *  include/asm-s390/poll.h
- *
- *  S390 version
- *
- *  Derived from "include/asm-i386/poll.h"
- */
-
-#ifndef __S390_POLL_H
-#define __S390_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN          0x0001
-#define POLLPRI         0x0002
-#define POLLOUT         0x0004
-#define POLLERR         0x0008
-#define POLLHUP         0x0010
-#define POLLNVAL        0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-sh/poll.h~consolidate-asm-pollh include/asm-sh/poll.h
--- a/include/asm-sh/poll.h~consolidate-asm-pollh
+++ a/include/asm-sh/poll.h
@@ -1,27 +1 @@
-#ifndef __ASM_SH_POLL_H
-#define __ASM_SH_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* __ASM_SH_POLL_H */
+#include <asm-generic/poll.h>
diff -puN include/asm-sh64/poll.h~consolidate-asm-pollh include/asm-sh64/poll.h
--- a/include/asm-sh64/poll.h~consolidate-asm-pollh
+++ a/include/asm-sh64/poll.h
@@ -1,37 +1,8 @@
 #ifndef __ASM_SH64_POLL_H
 #define __ASM_SH64_POLL_H
 
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * include/asm-sh64/poll.h
- *
- * Copyright (C) 2000, 2001  Paolo Alberelli
- *
- */
+#include <asm-generic/poll.h>
 
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#undef POLLREMOVE
 
 #endif /* __ASM_SH64_POLL_H */
diff -puN include/asm-sparc/poll.h~consolidate-asm-pollh include/asm-sparc/poll.h
--- a/include/asm-sparc/poll.h~consolidate-asm-pollh
+++ a/include/asm-sparc/poll.h
@@ -1,24 +1,12 @@
 #ifndef __SPARC_POLL_H
 #define __SPARC_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
 #define POLLMSG		512
 #define POLLREMOVE	1024
 #define POLLRDHUP       2048
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff -puN include/asm-sparc64/poll.h~consolidate-asm-pollh include/asm-sparc64/poll.h
--- a/include/asm-sparc64/poll.h~consolidate-asm-pollh
+++ a/include/asm-sparc64/poll.h
@@ -1,24 +1,12 @@
 #ifndef __SPARC64_POLL_H
 #define __SPARC64_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
 #define POLLMSG		512
 #define POLLREMOVE	1024
 #define POLLRDHUP       2048
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff -puN include/asm-v850/poll.h~consolidate-asm-pollh include/asm-v850/poll.h
--- a/include/asm-v850/poll.h~consolidate-asm-pollh
+++ a/include/asm-v850/poll.h
@@ -1,24 +1,9 @@
 #ifndef __V850_POLL_H__
 #define __V850_POLL_H__
 
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-#define POLLRDNORM	0x0040
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	0x0080
 #define POLLWRBAND	0x0100
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* __V850_POLL_H__ */
diff -puN include/asm-x86_64/poll.h~consolidate-asm-pollh include/asm-x86_64/poll.h
--- a/include/asm-x86_64/poll.h~consolidate-asm-pollh
+++ a/include/asm-x86_64/poll.h
@@ -1,27 +1 @@
-#ifndef __x86_64_POLL_H
-#define __x86_64_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff -puN include/asm-xtensa/poll.h~consolidate-asm-pollh include/asm-xtensa/poll.h
--- a/include/asm-xtensa/poll.h~consolidate-asm-pollh
+++ a/include/asm-xtensa/poll.h
@@ -11,28 +11,10 @@
 #ifndef _XTENSA_POLL_H
 #define _XTENSA_POLL_H
 
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
 #define POLLWRNORM	POLLOUT
 #define POLLWRBAND	0x0100
-
-#define POLLMSG		0x0400
 #define POLLREMOVE	0x0800
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* _XTENSA_POLL_H */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
declare-compat_sys_utimensat.patch
early_pfn_to_nid-needs-to-be-__meminit.patch
consolidate-asm-pollh.patch
