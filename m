From: akpm@linux-foundation.org
Subject: - powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:45 -0700
Message-ID: <200707101948.l6AJmjb8026026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198AbXGJTtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     PowerPC: Enable arbitary speed tty ioctls and split input/output speed
has been removed from the -mm tree.  Its filename was
     powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PowerPC: Enable arbitary speed tty ioctls and split input/output speed
From: David Woodhouse <dwmw2@infradead.org>

Adding the defines/macros activates the existing code in the tty layer and
allows this platform to use the arbitary speed ioctl setting layer

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/termbits.h |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN include/asm-powerpc/termbits.h~powerpc-enable-arbitary-speed-tty-ioctls-and-split include/asm-powerpc/termbits.h
--- a/include/asm-powerpc/termbits.h~powerpc-enable-arbitary-speed-tty-ioctls-and-split
+++ a/include/asm-powerpc/termbits.h
@@ -152,6 +152,10 @@ struct ktermios {
 #define B3000000  00034
 #define B3500000  00035
 #define B4000000  00036
+#define   BOTHER  00037
+
+#define CIBAUD	077600000
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
 
 #define CSIZE	00001400
 #define   CS5	00000000
_

Patches currently in -mm which might be from dwmw2@infradead.org are

git-powerpc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-ubi.patch
git-battery.patch
git-nfs.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
jffs2-convert-to-new-aops.patch
char-n_r3964-use-wait_event_interruptible.patch
kernel-utf-8-handling.patch
introduce-compat_u64-and-compat_s64-types.patch
gitignore-update.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
