From: akpm@linux-foundation.org
Subject: + powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch added to -mm tree
Date: Fri, 08 Jun 2007 11:19:44 -0700
Message-ID: <200706081819.l58IJi29007656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968901AbXFHST4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 14:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk


The patch titled
     PowerPC: Enable arbitary speed tty ioctls and split input/output speed
has been added to the -mm tree.  Its filename is
     powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
git-battery.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
jffs2-convert-to-new-aops.patch
char-n_r3964-use-wait_event_interruptible.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
