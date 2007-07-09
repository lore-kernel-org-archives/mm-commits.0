From: akpm@linux-foundation.org
Subject: - introduce-o_cloexec-parisc-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:51:33 -0700
Message-ID: <200707092151.l69LpXvf014337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbXGIVxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@parisc-linux.org, drepper@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Introduce O_CLOEXEC (parisc fix)
has been removed from the -mm tree.  Its filename was
     introduce-o_cloexec-parisc-fix.patch

This patch was dropped because it was folded into introduce-o_cloexec-take-2.patch

------------------------------------------------------
Subject: Introduce O_CLOEXEC (parisc fix)
From: Kyle McMartin <kyle@parisc-linux.org>

Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/fcntl.h |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff -puN include/asm-parisc/fcntl.h~introduce-o_cloexec-parisc-fix include/asm-parisc/fcntl.h
--- a/include/asm-parisc/fcntl.h~introduce-o_cloexec-parisc-fix
+++ a/include/asm-parisc/fcntl.h
@@ -3,21 +3,22 @@
 
 /* open/fcntl - O_SYNC is only implemented on blocks devices and on files
    located on an ext2 file system */
-#define O_APPEND	00000010
-#define O_BLKSEEK	00000100 /* HPUX only */
-#define O_CREAT		00000400 /* not fcntl */
-#define O_EXCL		00002000 /* not fcntl */
-#define O_LARGEFILE	00004000
-#define O_SYNC		00100000
-#define O_NONBLOCK	00200004 /* HPUX has separate NDELAY & NONBLOCK */
-#define O_NOCTTY	00400000 /* not fcntl */
-#define O_DSYNC		01000000 /* HPUX only */
-#define O_RSYNC		02000000 /* HPUX only */
-#define O_NOATIME	04000000
-
-#define O_DIRECTORY	00010000 /* must be a directory */
-#define O_NOFOLLOW	00000200 /* don't follow links */
-#define O_INVISIBLE	04000000 /* invisible I/O, for DMAPI/XDSM */
+#define O_APPEND	000000010
+#define O_BLKSEEK	000000100 /* HPUX only */
+#define O_CREAT		000000400 /* not fcntl */
+#define O_EXCL		000002000 /* not fcntl */
+#define O_LARGEFILE	000004000
+#define O_SYNC		000100000
+#define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
+#define O_NOCTTY	000400000 /* not fcntl */
+#define O_DSYNC		001000000 /* HPUX only */
+#define O_RSYNC		002000000 /* HPUX only */
+#define O_NOATIME	004000000
+#define O_CLOEXEC	010000000 /* set close_on_exec */
+
+#define O_DIRECTORY	000010000 /* must be a directory */
+#define O_NOFOLLOW	000000200 /* don't follow links */
+#define O_INVISIBLE	004000000 /* invisible I/O, for DMAPI/XDSM */
 
 #define F_GETLK64	8
 #define F_SETLK64	9
_

Patches currently in -mm which might be from kyle@parisc-linux.org are

dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
introduce-o_cloexec-take-2.patch
introduce-o_cloexec-parisc-fix.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
