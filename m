From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:28 -0400
Message-ID: <201003150654.o2F6s1Pq016036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759712Ab0COGyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove CLEARSTRUCT macro, use memset
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove CLEARSTRUCT macro, use memset
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-clearstruct-macro-use-memset drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-clearstruct-macro-use-memset
+++ a/drivers/block/floppy.c
@@ -314,8 +314,6 @@ static int initialising = 1;
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
 
-#define CLEARSTRUCT(x)	memset((x), 0, sizeof(*(x)))
-
 /* read/write */
 #define COMMAND		(raw_cmd->cmd[0])
 #define DR_SELECT	(raw_cmd->cmd[1])
@@ -3509,7 +3507,7 @@ static int fd_ioctl(struct block_device 
 		return -EINVAL;
 
 	/* copyin */
-	CLEARSTRUCT(&inparam);
+	memset(&inparam, 0, sizeof(inparam));
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 	    ECALL(fd_copyin((void __user *)param, &inparam, size))
 
@@ -3598,7 +3596,7 @@ static int fd_ioctl(struct block_device 
 			OUT(FDGETFDCSTAT, UFDCS);
 
 		case FDWERRORCLR:
-			CLEARSTRUCT(UDRWE);
+			memset(UDRWE, 0, sizeof(*UDRWE));
 			return 0;
 			OUT(FDWERRORGET, UDRWE);
 
@@ -4260,7 +4258,7 @@ static int __init floppy_init(void)
 
 	for (i = 0; i < N_FDC; i++) {
 		fdc = i;
-		CLEARSTRUCT(FDCS);
+		memset(FDCS, 0, sizeof(*FDCS));
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
@@ -4293,8 +4291,8 @@ static int __init floppy_init(void)
 
 	/* initialise drive state */
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		CLEARSTRUCT(UDRS);
-		CLEARSTRUCT(UDRWE);
+		memset(UDRS, 0, sizeof(*UDRS));
+		memset(UDRWE, 0, sizeof(*UDRWE));
 		USETF(FD_DISK_NEWCHANGE);
 		USETF(FD_DISK_CHANGED);
 		USETF(FD_VERIFY);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

