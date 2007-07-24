From: akpm@linux-foundation.org
Subject: - uml-fix-aio-compilation-bug.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:29 -0700
Message-ID: <200707242324.l6ONOT1U006277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbXGXXYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, drepper@redhat.com, jdike@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     uml: fix aio compilation bug
has been removed from the -mm tree.  Its filename was
     uml-fix-aio-compilation-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix aio compilation bug
From: Jeff Dike <jdike@addtoit.com>

Restructure do_aio thanks to commments from Ulrich and Al.

Uli started this by seeing that UML's initialization of a struct iocb
initialized fields that it shouldn't.

Al followed up by adding the following cleanups:
	eliminating a variable by just using an anonymous structure in
its place.
	hoisting a duplicated line out of the switch.
	simplifying the error checking at the end.

I added a severity to the printk.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/aio.c |   47 ++++++++++++++-------------------------
 1 files changed, 17 insertions(+), 30 deletions(-)

diff -puN arch/um/os-Linux/aio.c~uml-fix-aio-compilation-bug arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-fix-aio-compilation-bug
+++ a/arch/um/os-Linux/aio.c
@@ -14,6 +14,7 @@
 #include "init.h"
 #include "user.h"
 #include "mode.h"
+#include "kern_constants.h"
 
 struct aio_thread_req {
 	enum aio_type type;
@@ -65,47 +66,33 @@ static long io_getevents(aio_context_t c
 static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 		  int len, unsigned long long offset, struct aio_context *aio)
 {
-	struct iocb iocb, *iocbp = &iocb;
+	struct iocb *iocbp = & ((struct iocb) {
+				    .aio_data       = (unsigned long) aio,
+				    .aio_fildes     = fd,
+				    .aio_buf        = (unsigned long) buf,
+				    .aio_nbytes     = len,
+				    .aio_offset     = offset
+			     });
 	char c;
-	int err;
-
-	iocb = ((struct iocb) { .aio_data 	= (unsigned long) aio,
-				.aio_reqprio	= 0,
-				.aio_fildes	= fd,
-				.aio_buf	= (unsigned long) buf,
-				.aio_nbytes	= len,
-				.aio_offset	= offset,
-				.aio_reserved1	= 0,
-				.aio_reserved2	= 0,
-				.aio_reserved3	= 0 });
 
-	switch(type){
+	switch (type) {
 	case AIO_READ:
-		iocb.aio_lio_opcode = IOCB_CMD_PREAD;
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PREAD;
 		break;
 	case AIO_WRITE:
-		iocb.aio_lio_opcode = IOCB_CMD_PWRITE;
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PWRITE;
 		break;
 	case AIO_MMAP:
-		iocb.aio_lio_opcode = IOCB_CMD_PREAD;
-		iocb.aio_buf = (unsigned long) &c;
-		iocb.aio_nbytes = sizeof(c);
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PREAD;
+		iocbp->aio_buf = (unsigned long) &c;
+		iocbp->aio_nbytes = sizeof(c);
 		break;
 	default:
-		printk("Bogus op in do_aio - %d\n", type);
-		err = -EINVAL;
-		break;
+		printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
+		return -EINVAL;
 	}
 
-	if(err > 0)
-		err = 0;
-	else
-		err = -errno;
-
-	return err;
+	return (io_submit(ctx, 1, &iocbp) > 0) ? 0 : -errno;
 }
 
 /* Initialized in an initcall and unchanged thereafter */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
