From: akpm@linux-foundation.org
Subject: + floppy-remove-register-keyword-use-from-floppy-driver.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:07:36 -0700
Message-ID: <200707190507.l6J57aMN014909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbXGSFHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     floppy: remove register keyword use from floppy driver
has been added to the -mm tree.  Its filename is
     floppy-remove-register-keyword-use-from-floppy-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-mtd.patch
remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
