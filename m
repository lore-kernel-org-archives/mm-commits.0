From: akpm@linux-foundation.org
Subject: + introduce-o_cloexec-parisc-fix.patch added to -mm tree
Date: Fri, 01 Jun 2007 12:54:24 -0700
Message-ID: <200706011954.l51JsOYO017439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762367AbXFATzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 15:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@parisc-linux.org, drepper@redhat.com, mingo@elte.hu


The patch titled
     Introduce O_CLOEXEC (parisc fix)
has been added to the -mm tree.  Its filename is
     introduce-o_cloexec-parisc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-parisc.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
introduce-o_cloexec-parisc-fix.patch
