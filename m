From: akpm@osdl.org
Subject: - tty-preparatory-structures-for-termios-revamp.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:16 -0800
Message-ID: <200612082008.kB8K8Gxv002594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946171AbWLHUIg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: preparatory structures for termios revamp
has been removed from the -mm tree.  Its filename was
     tty-preparatory-structures-for-termios-revamp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: preparatory structures for termios revamp
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

In order to sort out our struct termios and add proper speed control we need
to separate the kernel and user termios structures.  Glibc is fine but the
other libraries rely on the kernel exported struct termios and we need to
extend this without breaking the ABI/API

To do so we add a struct ktermios which is the kernel view of a termios
structure and overlaps the struct termios with extra fields on the end for
now.  (That limitation will go away in later patches).  Some platforms (eg
alpha) planned ahead and thus use the same struct for both, others did not.

This just adds the structures but does not use them, it seems a sensible
splitting point for bisect if there are compile failures (not that I expect
them)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/strip.c   |    2 +-
 include/asm-alpha/termbits.h   |   13 +++++++++++++
 include/asm-arm/termbits.h     |   12 ++++++++++++
 include/asm-arm26/termbits.h   |   12 ++++++++++++
 include/asm-avr32/termbits.h   |   11 +++++++++++
 include/asm-cris/termbits.h    |   11 +++++++++++
 include/asm-frv/termbits.h     |   11 +++++++++++
 include/asm-h8300/termbits.h   |   11 +++++++++++
 include/asm-i386/termbits.h    |   11 +++++++++++
 include/asm-ia64/termbits.h    |   11 +++++++++++
 include/asm-m32r/termbits.h    |   11 +++++++++++
 include/asm-m68k/termbits.h    |   11 +++++++++++
 include/asm-mips/termbits.h    |   11 +++++++++++
 include/asm-parisc/termbits.h  |   11 +++++++++++
 include/asm-powerpc/termbits.h |   13 +++++++++++++
 include/asm-s390/termbits.h    |   11 +++++++++++
 include/asm-sh/termbits.h      |   11 +++++++++++
 include/asm-sparc/termbits.h   |   12 ++++++++++++
 include/asm-sparc64/termbits.h |   12 ++++++++++++
 include/asm-v850/termbits.h    |   11 +++++++++++
 include/asm-x86_64/termbits.h  |   11 +++++++++++
 21 files changed, 229 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/strip.c~tty-preparatory-structures-for-termios-revamp drivers/net/wireless/strip.c
--- a/drivers/net/wireless/strip.c~tty-preparatory-structures-for-termios-revamp
+++ a/drivers/net/wireless/strip.c
@@ -798,7 +798,7 @@ static unsigned int get_baud(struct tty_
  */
 static void set_baud(struct tty_struct *tty, unsigned int baudcode)
 {
-	struct termios old_termios = *(tty->termios);
+	struct ktermios old_termios = *(tty->termios);
 	tty->termios->c_cflag &= ~CBAUD;	/* Clear the old baud setting */
 	tty->termios->c_cflag |= baudcode;	/* Set the new baud setting */
 	tty->driver->set_termios(tty, &old_termios);
diff -puN include/asm-alpha/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-alpha/termbits.h
--- a/include/asm-alpha/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-alpha/termbits.h
@@ -25,6 +25,19 @@ struct termios {
 	speed_t c_ospeed;		/* output speed */
 };
 
+/* Alpha has matching termios and ktermios */
+
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t c_line;			/* line discipline (== c_cc[19]) */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VEOF 0
 #define VEOL 1
diff -puN include/asm-arm/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-arm/termbits.h
--- a/include/asm-arm/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-arm/termbits.h
@@ -15,6 +15,18 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-arm26/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-arm26/termbits.h
--- a/include/asm-arm26/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-arm26/termbits.h
@@ -15,6 +15,18 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-avr32/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-avr32/termbits.h
--- a/include/asm-avr32/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-avr32/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-cris/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-cris/termbits.h
--- a/include/asm-cris/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-cris/termbits.h
@@ -19,6 +19,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-frv/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-frv/termbits.h
--- a/include/asm-frv/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-frv/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-h8300/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-h8300/termbits.h
--- a/include/asm-h8300/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-h8300/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-i386/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-i386/termbits.h
--- a/include/asm-i386/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-i386/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-ia64/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-ia64/termbits.h
--- a/include/asm-ia64/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-ia64/termbits.h
@@ -26,6 +26,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-m32r/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-m32r/termbits.h
--- a/include/asm-m32r/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-m32r/termbits.h
@@ -19,6 +19,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-m68k/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-m68k/termbits.h
--- a/include/asm-m68k/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-m68k/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-mips/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-mips/termbits.h
--- a/include/asm-mips/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-mips/termbits.h
@@ -30,6 +30,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR		 0		/* Interrupt character [ISIG].  */
 #define VQUIT		 1		/* Quit character [ISIG].  */
diff -puN include/asm-parisc/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-parisc/termbits.h
--- a/include/asm-parisc/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-parisc/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-powerpc/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-powerpc/termbits.h
--- a/include/asm-powerpc/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-powerpc/termbits.h
@@ -30,6 +30,19 @@ struct termios {
 	speed_t c_ospeed;		/* output speed */
 };
 
+/* For PowerPC the termios and ktermios are the same */
+
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 	         0
 #define VQUIT 	         1
diff -puN include/asm-s390/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-s390/termbits.h
--- a/include/asm-s390/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-s390/termbits.h
@@ -25,6 +25,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-sh/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-sh/termbits.h
--- a/include/asm-sh/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-sh/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-sparc/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-sparc/termbits.h
--- a/include/asm-sparc/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-sparc/termbits.h
@@ -31,6 +31,18 @@ struct termios {
 #endif
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* We need them to hold vmin/vtime */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR    0
 #define VQUIT    1
diff -puN include/asm-sparc64/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-sparc64/termbits.h
--- a/include/asm-sparc64/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-sparc64/termbits.h
@@ -33,6 +33,18 @@ struct termios {
 #endif
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* We need them to hold vmin/vtime */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR    0
 #define VQUIT    1
diff -puN include/asm-v850/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-v850/termbits.h
--- a/include/asm-v850/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-v850/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
diff -puN include/asm-x86_64/termbits.h~tty-preparatory-structures-for-termios-revamp include/asm-x86_64/termbits.h
--- a/include/asm-x86_64/termbits.h~tty-preparatory-structures-for-termios-revamp
+++ a/include/asm-x86_64/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-preparatory-structures-for-termios-revamp.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch
tty-switch-to-ktermios-nozomi-fix.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
ide-complete-switch-to-pci_get.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch

