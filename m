From: akpm@linux-foundation.org
Subject: - tty-add-the-new-termios2-ioctls-to-the-compatible.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:10 -0800
Message-ID: <200712010024.lB10OANK032047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166AbXLAA1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty: add the new termios2 ioctls to the compatible list.
has been removed from the -mm tree.  Its filename was
     tty-add-the-new-termios2-ioctls-to-the-compatible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1954,6 +1954,12 @@ ULONG_IOCTL(TIOCSCTTY)
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

origin.patch
git-s390.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
