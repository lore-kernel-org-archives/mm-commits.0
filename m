From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:36 -0800
Message-ID: <201001270037.o0R0baL2032539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab0A0Arh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:47:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove CLEARSTRUCT macro, use memset
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

