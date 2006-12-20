From: akpm@osdl.org
Subject: + consolidate-line-discipline-number-definitions-v2.patch added to -mm tree
Date: Wed, 20 Dec 2006 15:51:30 -0800
Message-ID: <200612202351.kBKNpUgw010178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161024AbWLTXvp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 18:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, linux-arch@vger.kernel.org


The patch titled
     consolidate line discipline number definitions
has been added to the -mm tree.  Its filename is
     consolidate-line-discipline-number-definitions-v2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: consolidate line discipline number definitions
From: Tilman Schmidt <tilman@imap.cc>

The line discipline numbers N_* are currently defined for each architecture
individually, but (except for a seeming mistake) identically, in
asm/termios.h.  There is no obvious reason why these numbers should be
architecture specific, nor any apparent relationship with the termios
structure.  The total number of these, NR_LDISCS, is defined in linux/tty.h
anyway.  So I propose the following patch which moves the definitions of
the individual line disciplines to linux/tty.h too.

Three of these numbers (N_MASC, N_PROFIBUS_FDL, and N_SMSBLOCK) are unused
in the current kernel, but the patch still keeps the complete set in case
there are plans to use them yet.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-alpha/termios.h   |   18 ------------------
 include/asm-arm/termios.h     |   18 ------------------
 include/asm-arm26/termios.h   |   18 ------------------
 include/asm-avr32/termios.h   |   18 ------------------
 include/asm-cris/termios.h    |   18 ------------------
 include/asm-frv/termios.h     |   18 ------------------
 include/asm-h8300/termios.h   |   18 ------------------
 include/asm-i386/termios.h    |   18 ------------------
 include/asm-ia64/termios.h    |   18 ------------------
 include/asm-m32r/termios.h    |   18 ------------------
 include/asm-m68k/termios.h    |   18 ------------------
 include/asm-mips/termios.h    |   18 ------------------
 include/asm-parisc/termios.h  |   18 ------------------
 include/asm-powerpc/termios.h |   18 ------------------
 include/asm-s390/termios.h    |   18 ------------------
 include/asm-sh/termios.h      |   18 ------------------
 include/asm-sh64/termios.h    |   18 ------------------
 include/asm-sparc/termios.h   |   18 ------------------
 include/asm-sparc64/termios.h |   18 ------------------
 include/asm-v850/termios.h    |   18 ------------------
 include/asm-x86_64/termios.h  |   18 ------------------
 include/asm-xtensa/termios.h  |   19 -------------------
 include/linux/tty.h           |   22 +++++++++++++++++++++-
 23 files changed, 21 insertions(+), 398 deletions(-)

diff -puN include/asm-alpha/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-alpha/termios.h
--- a/include/asm-alpha/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-alpha/termios.h
@@ -66,24 +66,6 @@ struct termio {
 #define _VEOL2	6
 #define _VSWTC	7
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 /*	eof=^D		eol=\0		eol2=\0		erase=del
 	werase=^W	kill=^U		reprint=^R	sxtc=\0
diff -puN include/asm-arm/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-arm/termios.h
--- a/include/asm-arm/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-arm/termios.h
@@ -49,24 +49,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*
diff -puN include/asm-arm26/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-arm26/termios.h
--- a/include/asm-arm26/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-arm26/termios.h
@@ -49,24 +49,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*
diff -puN include/asm-avr32/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-avr32/termios.h
--- a/include/asm-avr32/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-avr32/termios.h
@@ -46,24 +46,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 /*	intr=^C		quit=^\		erase=del	kill=^U
 	eof=^D		vtime=\0	vmin=\1		sxtc=\0
diff -puN include/asm-cris/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-cris/termios.h
--- a/include/asm-cris/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-cris/termios.h
@@ -40,24 +40,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_BT		15	/* bluetooth */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-frv/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-frv/termios.h
--- a/include/asm-frv/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-frv/termios.h
@@ -51,24 +51,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #include <asm-generic/termios.h>
 
 #endif /* _ASM_TERMIOS_H */
diff -puN include/asm-h8300/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-h8300/termios.h
--- a/include/asm-h8300/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-h8300/termios.h
@@ -49,24 +49,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*
diff -puN include/asm-i386/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-i386/termios.h
--- a/include/asm-i386/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-i386/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 #include <linux/module.h>
 
diff -puN include/asm-ia64/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-ia64/termios.h
--- a/include/asm-ia64/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-ia64/termios.h
@@ -46,24 +46,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS msgs */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 # ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-m32r/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-m32r/termios.h
--- a/include/asm-m32r/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-m32r/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 #include <linux/module.h>
 
diff -puN include/asm-m68k/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-m68k/termios.h
--- a/include/asm-m68k/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-m68k/termios.h
@@ -49,24 +49,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*
diff -puN include/asm-mips/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-mips/termios.h
--- a/include/asm-mips/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-mips/termios.h
@@ -87,24 +87,6 @@ struct termio {
 #define TIOCM_OUT2	0x4000
 #define TIOCM_LOOP	0x8000
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6		/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved fo Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15	/* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 #include <linux/string.h>
diff -puN include/asm-parisc/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-parisc/termios.h
--- a/include/asm-parisc/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-parisc/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-powerpc/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-powerpc/termios.h
--- a/include/asm-powerpc/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-powerpc/termios.h
@@ -71,24 +71,6 @@ struct termio {
 #define _VEOL2	8
 #define _VSWTC	9
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://www.cs.uit.no/~dagb/irda/irda.html */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 /*                   ^C  ^\ del  ^U  ^D   1   0   0   0   0  ^W  ^R  ^Z  ^Q  ^S  ^V  ^U  */
 #define INIT_C_CC "\003\034\177\025\004\001\000\000\000\000\027\022\032\021\023\026\025" 
diff -puN include/asm-s390/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-s390/termios.h
--- a/include/asm-s390/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-s390/termios.h
@@ -47,24 +47,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-sh/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-sh/termios.h
--- a/include/asm-sh/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-sh/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-sh64/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-sh64/termios.h
--- a/include/asm-sh64/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-sh64/termios.h
@@ -50,24 +50,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://www.cs.uit.no/~dagb/irda/irda.html */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15	/* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-sparc/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-sparc/termios.h
--- a/include/asm-sparc/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-sparc/termios.h
@@ -45,24 +45,6 @@ struct winsize {
 	unsigned short ws_ypixel;
 };
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 #include <linux/module.h>
 
diff -puN include/asm-sparc64/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-sparc64/termios.h
--- a/include/asm-sparc64/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-sparc64/termios.h
@@ -45,24 +45,6 @@ struct winsize {
 	unsigned short ws_ypixel;
 };
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 #include <linux/module.h>
 
diff -puN include/asm-v850/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-v850/termios.h
--- a/include/asm-v850/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-v850/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-x86_64/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-x86_64/termios.h
--- a/include/asm-x86_64/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-x86_64/termios.h
@@ -39,24 +39,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* line disciplines */
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14	/* synchronous PPP */
-#define N_HCI		15  /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/asm-xtensa/termios.h~consolidate-line-discipline-number-definitions-v2 include/asm-xtensa/termios.h
--- a/include/asm-xtensa/termios.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/asm-xtensa/termios.h
@@ -52,25 +52,6 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-/* Line disciplines */
-
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6	/* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11	/* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data cards about SMS messages */
-#define N_HDLC		13	/* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15      /* Bluetooth HCI UART */
-
 #ifdef __KERNEL__
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
diff -puN include/linux/tty.h~consolidate-line-discipline-number-definitions-v2 include/linux/tty.h
--- a/include/linux/tty.h~consolidate-line-discipline-number-definitions-v2
+++ a/include/linux/tty.h
@@ -24,7 +24,27 @@
 #define NR_PTYS	CONFIG_LEGACY_PTY_COUNT   /* Number of legacy ptys */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		16
+#define NR_LDISCS		17
+
+/* line disciplines */
+#define N_TTY		0
+#define N_SLIP		1
+#define N_MOUSE		2
+#define N_PPP		3
+#define N_STRIP		4
+#define N_AX25		5
+#define N_X25		6	/* X.25 async */
+#define N_6PACK		7
+#define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
+#define N_R3964		9	/* Reserved for Simatic R3964 module */
+#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
+#define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
+#define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data */
+				/* cards about SMS messages */
+#define N_HDLC		13	/* synchronous HDLC */
+#define N_SYNC_PPP	14	/* synchronous PPP */
+#define N_HCI		15	/* Bluetooth HCI UART */
+#define N_GIGASET_M101	16	/* Siemens Gigaset M101 serial DECT adapter */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
_

Patches currently in -mm which might be from tilman@imap.cc are

consolidate-line-discipline-number-definitions-v2.patch

