From: akpm@linux-foundation.org
Subject: + tty-s390-support-for-termios2.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:02:13 -0800
Message-ID: <200711200702.lAK72DvU019154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756440AbXKTHCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, alan@lxorguk.ukuu.org.uk, schwidefsky@de.ibm.com


The patch titled
     tty: s390 support for termios2.
has been added to the -mm tree.  Its filename is
     tty-s390-support-for-termios2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: s390 support for termios2.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Backend for s390.

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/ioctls.h   |    4 ++++
 include/asm-s390/termbits.h |    5 ++++-
 include/asm-s390/termios.h  |    3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff -puN include/asm-s390/ioctls.h~tty-s390-support-for-termios2 include/asm-s390/ioctls.h
--- a/include/asm-s390/ioctls.h~tty-s390-support-for-termios2
+++ a/include/asm-s390/ioctls.h
@@ -54,6 +54,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-s390/termbits.h~tty-s390-support-for-termios2 include/asm-s390/termbits.h
--- a/include/asm-s390/termbits.h~tty-s390-support-for-termios2
+++ a/include/asm-s390/termbits.h
@@ -148,6 +148,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define  BOTHER  0010000
 #define  B57600  0010001
 #define  B115200 0010002
 #define  B230400 0010003
@@ -163,10 +164,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -puN include/asm-s390/termios.h~tty-s390-support-for-termios2 include/asm-s390/termios.h
--- a/include/asm-s390/termios.h~tty-s390-support-for-termios2
+++ a/include/asm-s390/termios.h
@@ -57,6 +57,9 @@ struct termio {
 */
 #define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
 
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+
 #include <asm-generic/termios.h>
 
 #endif	/* __KERNEL__ */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

git-s390.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
