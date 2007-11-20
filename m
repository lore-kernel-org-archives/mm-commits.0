From: akpm@linux-foundation.org
Subject: + tty-add-the-new-termios2-ioctls-to-the-compatible.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:02:09 -0800
Message-ID: <200711200702.lAK7291f019148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbXKTHC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:02:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: add the new termios2 ioctls to the compatible list.
has been added to the -mm tree.  Its filename is
     tty-add-the-new-termios2-ioctls-to-the-compatible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: add the new termios2 ioctls to the compatible list.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Make them depend on TCGETS2.  If that one is implemented the rest should be
there as well.

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/compat_ioctl.c~tty-add-the-new-termios2-ioctls-to-the-compatible fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~tty-add-the-new-termios2-ioctls-to-the-compatible
+++ a/fs/compat_ioctl.c
@@ -1953,6 +1953,12 @@ ULONG_IOCTL(TIOCSCTTY)
 COMPATIBLE_IOCTL(TIOCGPTN)
 COMPATIBLE_IOCTL(TIOCSPTLCK)
 COMPATIBLE_IOCTL(TIOCSERGETLSR)
+#ifdef TCGETS2
+COMPATIBLE_IOCTL(TCGETS2)
+COMPATIBLE_IOCTL(TCSETS2)
+COMPATIBLE_IOCTL(TCSETSW2)
+COMPATIBLE_IOCTL(TCSETSF2)
+#endif
 /* Little f */
 COMPATIBLE_IOCTL(FIOCLEX)
 COMPATIBLE_IOCTL(FIONCLEX)
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
