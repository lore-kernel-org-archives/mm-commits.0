From: akpm@linux-foundation.org
Subject: - sparc-support-for-new-termios.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:12 -0700
Message-ID: <200710190340.l9J3eC6t012688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965558AbXJSDlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sparc support for new termios
has been removed from the -mm tree.  Its filename was
     sparc-support-for-new-termios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc support for new termios
From: Dave Miller <davem@davemloft.net>

[akpm@linux-foundation.org: coding-style tweaks]
Signed-off-by: David Miller <davem@davemloft.net>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc/ioctls.h     |    4 ++
 include/asm-sparc/termbits.h   |   15 +++++++++
 include/asm-sparc/termios.h    |   48 +++++++++++++++++++++++++++++--
 include/asm-sparc64/ioctls.h   |    4 ++
 include/asm-sparc64/termbits.h |   17 +++++++++-
 include/asm-sparc64/termios.h  |   42 +++++++++++++++++++++++++++
 6 files changed, 125 insertions(+), 5 deletions(-)

diff -puN include/asm-sparc/ioctls.h~sparc-support-for-new-termios include/asm-sparc/ioctls.h
--- a/include/asm-sparc/ioctls.h~sparc-support-for-new-termios
+++ a/include/asm-sparc/ioctls.h
@@ -15,6 +15,10 @@
 #define TCSETS		_IOW('T', 9, struct termios)
 #define TCSETSW		_IOW('T', 10, struct termios)
 #define TCSETSF		_IOW('T', 11, struct termios)
+#define TCGETS2		_IOR('T', 12, struct termios2)
+#define TCSETS2		_IOW('T', 13, struct termios2)
+#define TCSETSW2	_IOW('T', 14, struct termios2)
+#define TCSETSF2	_IOW('T', 15, struct termios2)
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff -puN include/asm-sparc/termbits.h~sparc-support-for-new-termios include/asm-sparc/termbits.h
--- a/include/asm-sparc/termbits.h~sparc-support-for-new-termios
+++ a/include/asm-sparc/termbits.h
@@ -31,6 +31,18 @@ struct termios {
 #endif
 };
 
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* padding to match ktermios */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -160,6 +172,7 @@ struct ktermios {
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
 /* We'll never see these speeds with the Zilogs, but for completeness... */
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -189,6 +202,8 @@ struct ktermios {
 #define CMSPAR	  0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff -puN include/asm-sparc/termios.h~sparc-support-for-new-termios include/asm-sparc/termios.h
--- a/include/asm-sparc/termios.h~sparc-support-for-new-termios
+++ a/include/asm-sparc/termios.h
@@ -108,13 +108,55 @@ struct winsize {
 
 #define user_termios_to_kernel_termios(k, u) \
 ({ \
+	int err; \
+	err  = get_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= get_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= get_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= get_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= get_user((k)->c_line,  &(u)->c_line); \
+	err |= copy_from_user((k)->c_cc, (u)->c_cc, NCCS); \
+	if ((k)->c_lflag & ICANON) { \
+		err |= get_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= get_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} else { \
+		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} \
+	err |= get_user((k)->c_ispeed,  &(u)->c_ispeed); \
+	err |= get_user((k)->c_ospeed,  &(u)->c_ospeed); \
+	err; \
+})
+
+#define kernel_termios_to_user_termios(u, k) \
+({ \
+	int err; \
+	err  = put_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= put_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= put_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= put_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= put_user((k)->c_line, &(u)->c_line); \
+	err |= copy_to_user((u)->c_cc, (k)->c_cc, NCCS); \
+	if (!((k)->c_lflag & ICANON)) { \
+		err |= put_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= put_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} else { \
+		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} \
+	err |= put_user((k)->c_ispeed, &(u)->c_ispeed); \
+	err |= put_user((k)->c_ospeed, &(u)->c_ospeed); \
+	err; \
+})
+
+#define user_termios_to_kernel_termios_1(k, u) \
+({ \
 	get_user((k)->c_iflag, &(u)->c_iflag); \
 	get_user((k)->c_oflag, &(u)->c_oflag); \
 	get_user((k)->c_cflag, &(u)->c_cflag); \
 	get_user((k)->c_lflag, &(u)->c_lflag); \
 	get_user((k)->c_line,  &(u)->c_line); \
 	copy_from_user((k)->c_cc, (u)->c_cc, NCCS); \
-	if((k)->c_lflag & ICANON) { \
+	if ((k)->c_lflag & ICANON) { \
 		get_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
 		get_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
 	} else { \
@@ -124,7 +166,7 @@ struct winsize {
 	0; \
 })
 
-#define kernel_termios_to_user_termios(u, k) \
+#define kernel_termios_to_user_termios_1(u, k) \
 ({ \
 	put_user((k)->c_iflag, &(u)->c_iflag); \
 	put_user((k)->c_oflag, &(u)->c_oflag); \
@@ -132,7 +174,7 @@ struct winsize {
 	put_user((k)->c_lflag, &(u)->c_lflag); \
 	put_user((k)->c_line, &(u)->c_line); \
 	copy_to_user((u)->c_cc, (k)->c_cc, NCCS); \
-	if(!((k)->c_lflag & ICANON)) { \
+	if (!((k)->c_lflag & ICANON)) { \
 		put_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
 		put_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
 	} else { \
diff -puN include/asm-sparc64/ioctls.h~sparc-support-for-new-termios include/asm-sparc64/ioctls.h
--- a/include/asm-sparc64/ioctls.h~sparc-support-for-new-termios
+++ a/include/asm-sparc64/ioctls.h
@@ -16,6 +16,10 @@
 #define TCSETS		_IOW('T', 9, struct termios)
 #define TCSETSW		_IOW('T', 10, struct termios)
 #define TCSETSF		_IOW('T', 11, struct termios)
+#define TCGETS2		_IOR('T', 12, struct termios2)
+#define TCSETS2		_IOW('T', 13, struct termios2)
+#define TCSETSW2	_IOW('T', 14, struct termios2)
+#define TCSETSF2	_IOW('T', 15, struct termios2)
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff -puN include/asm-sparc64/termbits.h~sparc-support-for-new-termios include/asm-sparc64/termbits.h
--- a/include/asm-sparc64/termbits.h~sparc-support-for-new-termios
+++ a/include/asm-sparc64/termbits.h
@@ -5,8 +5,6 @@
 
 typedef unsigned char   cc_t;
 typedef unsigned int    speed_t;
-
-/* XXX is this right for sparc64?  it was an unsigned long... XXX */
 typedef unsigned int    tcflag_t;
 
 #define NCC 8
@@ -33,6 +31,18 @@ struct termios {
 #endif
 };
 
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* padding to match ktermios */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -161,6 +171,7 @@ struct ktermios {
 #define HUPCL	  0x00000400
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -190,6 +201,8 @@ struct ktermios {
 #define CMSPAR    0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff -puN include/asm-sparc64/termios.h~sparc-support-for-new-termios include/asm-sparc64/termios.h
--- a/include/asm-sparc64/termios.h~sparc-support-for-new-termios
+++ a/include/asm-sparc64/termios.h
@@ -123,6 +123,8 @@ struct winsize {
 		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
 		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
 	} \
+	err |= get_user((k)->c_ispeed,  &(u)->c_ispeed); \
+	err |= get_user((k)->c_ospeed,  &(u)->c_ospeed); \
 	err; \
 })
 
@@ -142,6 +144,46 @@ struct winsize {
 		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
 		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
 	} \
+	err |= put_user((k)->c_ispeed, &(u)->c_ispeed); \
+	err |= put_user((k)->c_ospeed, &(u)->c_ospeed); \
+	err; \
+})
+
+#define user_termios_to_kernel_termios_1(k, u) \
+({ \
+	int err; \
+	err  = get_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= get_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= get_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= get_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= get_user((k)->c_line,  &(u)->c_line); \
+	err |= copy_from_user((k)->c_cc, (u)->c_cc, NCCS); \
+	if((k)->c_lflag & ICANON) { \
+		err |= get_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= get_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} else { \
+		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} \
+	err; \
+})
+
+#define kernel_termios_to_user_termios_1(u, k) \
+({ \
+	int err; \
+	err  = put_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= put_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= put_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= put_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= put_user((k)->c_line, &(u)->c_line); \
+	err |= copy_to_user((u)->c_cc, (k)->c_cc, NCCS); \
+	if(!((k)->c_lflag & ICANON)) { \
+		err |= put_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= put_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} else { \
+		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} \
 	err; \
 })
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
zd1201-avoid-null-ptr-access-of-skb-dev.patch
ip-justification-for-local-port-range-robustness.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-scsi-misc.patch
git-wireless.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
