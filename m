From: akpm@osdl.org
Subject: + m68k-trivial-build-fixes.patch added to -mm tree
Date: Thu, 14 Dec 2006 17:45:01 -0800
Message-ID: <200612150145.kBF1j2w6003306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50158 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964966AbWLOBpK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 20:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     m68k trivial build fixes
has been added to the -mm tree.  Its filename is
     m68k-trivial-build-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k trivial build fixes
From: Al Viro <viro@ftp.linux.org.uk>

amikbd: missing declaration
sun3_NCR5380: more work_struct mess
sun3_NCR5380: cast is not an lvalue

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/keyboard/amikbd.c |    2 +-
 drivers/scsi/sun3_NCR5380.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/keyboard/amikbd.c~m68k-trivial-build-fixes drivers/input/keyboard/amikbd.c
--- a/drivers/input/keyboard/amikbd.c~m68k-trivial-build-fixes
+++ a/drivers/input/keyboard/amikbd.c
@@ -187,7 +187,7 @@ static irqreturn_t amikbd_interrupt(int 
 
 static int __init amikbd_init(void)
 {
-	int i, j;
+	int i, j, err;
 
 	if (!AMIGAHW_PRESENT(AMI_KEYBOARD))
 		return -ENODEV;
diff -puN drivers/scsi/sun3_NCR5380.c~m68k-trivial-build-fixes drivers/scsi/sun3_NCR5380.c
--- a/drivers/scsi/sun3_NCR5380.c~m68k-trivial-build-fixes
+++ a/drivers/scsi/sun3_NCR5380.c
@@ -266,7 +266,7 @@ static struct scsi_host_template *the_te
 	(struct NCR5380_hostdata *)(in)->hostdata
 #define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
 
-#define	NEXT(cmd)	((struct scsi_cmnd *)((cmd)->host_scribble))
+#define	NEXT(cmd)	(*(struct scsi_cmnd **)&((cmd)->host_scribble))
 #define	NEXTADDR(cmd)	((struct scsi_cmnd **)&((cmd)->host_scribble))
 
 #define	HOSTNO		instance->host_no
@@ -650,7 +650,7 @@ __inline__ void NCR5380_print_phase(stru
 #include <linux/interrupt.h>
 
 static volatile int main_running = 0;
-static DECLARE_WORK(NCR5380_tqueue, (void (*)(void*))NCR5380_main, NULL);
+static DECLARE_WORK(NCR5380_tqueue, NCR5380_main);
 
 static __inline__ void queue_main(void)
 {
@@ -1031,7 +1031,7 @@ static int NCR5380_queue_command(struct 
  *  reenable them.  This prevents reentrancy and kernel stack overflow.
  */ 	
     
-static void NCR5380_main (void *bl)
+static void NCR5380_main (struct work_struct *bl)
 {
     struct scsi_cmnd *tmp, *prev;
     struct Scsi_Host *instance = first_instance;
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
m68k-trivial-build-fixes.patch
slab-leaks3-default-y.patch

