From: akpm@osdl.org
Subject: + floppy-fix-jiffies-dependency.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:08:34 -0800
Message-ID: <200701250608.l0P68YH3007656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48971 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXAYGIx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sferriol@imag.fr


The patch titled
     floppy: fix jiffies dependency
has been added to the -mm tree.  Its filename is
     floppy-fix-jiffies-dependency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: floppy: fix jiffies dependency
From: Sylvain Ferriol <sferriol@imag.fr>

=====
BUG 1
=====

bug_1 symptom:
--------------
sometimes after changing disk floppy, the mount command returns:
$ mount -t ext2 /dev/fd0 /mnt
mount: Mounting /dev/fd0 on/mnt failed: Invalid argument

and the kernel floppy driver log is:
kernel: floppy0: disk absent or changed during operation

bug_1 description:
------------------
last_checked is the date (in jiffies) of the last disk check

the mount process calls floppy_open which :
- set last_checked to 0
- calls check_floppy_change

check_floppy_change checks disk only when last_checked + checkfreq >
current_time(jiffies)
it uses time_after jiffies macro: if(time_after(jiffies, (last_checked+checkfreq))
but by setting last_checked to an absolute value (0) in floppy_open, check disk
is done depending on the value of current time.
and if jiffies = 0xffffffff, there is no check and the mount fails

bug_1 solution:
---------------
a better way to force disk check in floppy_open is to set last_checked = jiffies
- checkfreq - 1


=====
BUG 2
=====

bug_2 symptom:
--------------
if we activate debug (modprobe floppy floppy=debug), bug_1 does not appear.

bug_2 decription:
-----------------

debug activates the following print:
DPRINT("disk change line=%x\n", fd_inb(FD_DIR) & 0x80);

as fd_inb returns that floppy has changed, the next call:
if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
	returns always false
	and it never detects if floppy has changed during operation => bug1 not detected
	
bug 2 solution:
---------------
char dir = 0;           /* digital input register */
/* MUST be called only once for checking disk change */
dir = fd_inb(FD_DIR);
DPRINT("disk change line=%x\n", dir & 0x80);
if ((dir ^ UDP->flags) & 0x80) {
		

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/floppy.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~floppy-fix-jiffies-dependency drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-fix-jiffies-dependency
+++ a/drivers/block/floppy.c
@@ -733,6 +733,8 @@ static void reschedule_timeout(int drive
 static int disk_change(int drive)
 {
 	int fdc = FDC(drive);
+	char dir = 0;		/* digital input register */
+
 #ifdef FLOPPY_SANITY_CHECK
 	if (time_before(jiffies, UDRS->select_date + UDP->select_delay))
 		DPRINT("WARNING disk change called early\n");
@@ -744,17 +746,20 @@ static int disk_change(int drive)
 	}
 #endif
 
+	/* MUST be called only once for checking disk change */
+	dir = fd_inb(FD_DIR);
+
 #ifdef DCL_DEBUG
 	if (UDP->flags & FD_DEBUG) {
 		DPRINT("checking disk change line for drive %d\n", drive);
 		DPRINT("jiffies=%lu\n", jiffies);
-		DPRINT("disk change line=%x\n", fd_inb(FD_DIR) & 0x80);
+		DPRINT("disk change line=%x\n", dir & 0x80);
 		DPRINT("flags=%lx\n", UDRS->flags);
 	}
 #endif
 	if (UDP->flags & FD_BROKEN_DCL)
 		return UTESTF(FD_DISK_CHANGED);
-	if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
+	if ((dir ^ UDP->flags) & 0x80) {
 		USETF(FD_VERIFY);	/* verify write protection */
 		if (UDRS->maxblock) {
 			/* mark it changed */
@@ -3762,7 +3767,9 @@ static int floppy_open(struct inode *ino
 
 	if (!(filp->f_flags & O_NDELAY)) {
 		if (filp->f_mode & 3) {
-			UDRS->last_checked = 0;
+			/* Force check disk by putting the date of the last check
+			 * far enough in the past */
+			UDRS->last_checked = jiffies - UDP->checkfreq - 1;
 			check_disk_change(inode->i_bdev);
 			if (UTESTF(FD_DISK_CHANGED))
 				goto out;
_

Patches currently in -mm which might be from sferriol@imag.fr are
