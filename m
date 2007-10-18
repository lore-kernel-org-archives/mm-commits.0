From: akpm@linux-foundation.org
Subject: - floppy-remove-register-keyword-use-from-floppy-driver.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:16 -0700
Message-ID: <200710180703.l9I73G6Q031418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760416AbXJRHPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     floppy: remove register keyword use from floppy driver
has been removed from the -mm tree.  Its filename was
     floppy-remove-register-keyword-use-from-floppy-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: floppy: remove register keyword use from floppy driver
From: Jesper Juhl <jesper.juhl@gmail.com>

The floppy drive is slow.  These days I see absolutely no good reason why the
floppy driver should try to gain a tiny bit of speed by telling gcc to
optimize access to some variables via the register keyword.  Better to just
leave gcc free to do whatever optimizations it deduces to be sane and not
hamper it by telling it that some variables in the floppy driver are special
and need to be fast (they don't).

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~floppy-remove-register-keyword-use-from-floppy-driver drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-remove-register-keyword-use-from-floppy-driver
+++ a/drivers/block/floppy.c
@@ -783,7 +783,10 @@ static inline int is_selected(int dor, i
 
 static int set_dor(int fdc, char mask, char data)
 {
-	register unsigned char drive, unit, newdor, olddor;
+	unsigned char unit;
+	unsigned char drive;
+	unsigned char newdor;
+	unsigned char olddor;
 
 	if (FDCS->address == -1)
 		return -1;
@@ -937,7 +940,7 @@ static void motor_off_callback(unsigned 
 static void floppy_off(unsigned int drive)
 {
 	unsigned long volatile delta;
-	register int fdc = FDC(drive);
+	int fdc = FDC(drive);
 
 	if (!(FDCS->dor & (0x10 << UNIT(drive))))
 		return;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
