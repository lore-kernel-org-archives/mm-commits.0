From: akpm@linux-foundation.org
Subject: - uml-aio-locking-and-tidying.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:43 -0800
Message-ID: <200702112249.l1BMnhqM015784@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbXBKWtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: AIO locking and tidying
has been removed from the -mm tree.  Its filename was
     uml-aio-locking-and-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: AIO locking and tidying
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking of data that's set up once at boot time.

Also fixed a couple of bogus printks.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/aio.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/um/os-Linux/aio.c~uml-aio-locking-and-tidying arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-aio-locking-and-tidying
+++ a/arch/um/os-Linux/aio.c
@@ -24,9 +24,6 @@ struct aio_thread_req {
 	struct aio_context *aio;
 };
 
-static int aio_req_fd_r = -1;
-static int aio_req_fd_w = -1;
-
 #if defined(HAVE_AIO_ABI)
 #include <linux/aio_abi.h>
 
@@ -111,6 +108,7 @@ static int do_aio(aio_context_t ctx, enu
 	return err;
 }
 
+/* Initialized in an initcall and unchanged thereafter */
 static aio_context_t ctx = 0;
 
 static int aio_thread(void *arg)
@@ -137,7 +135,7 @@ static int aio_thread(void *arg)
 			err = os_write_file(reply_fd, &reply, sizeof(reply));
 			if(err != sizeof(reply))
 				printk("aio_thread - write failed, fd = %d, "
-				       "err = %d\n", aio_req_fd_r, -err);
+				       "err = %d\n", reply_fd, -err);
 		}
 	}
 	return 0;
@@ -182,6 +180,11 @@ out:
 	return err;
 }
 
+/* These are initialized in initcalls and not changed */
+static int aio_req_fd_r = -1;
+static int aio_req_fd_w = -1;
+static int aio_pid = -1;
+
 static int not_aio_thread(void *arg)
 {
 	struct aio_thread_req req;
@@ -208,14 +211,12 @@ static int not_aio_thread(void *arg)
 		err = os_write_file(req.aio->reply_fd, &reply, sizeof(reply));
 		if(err != sizeof(reply))
 			printk("not_aio_thread - write failed, fd = %d, "
-			       "err = %d\n", aio_req_fd_r, -err);
+			       "err = %d\n", req.aio->reply_fd, -err);
 	}
 
 	return 0;
 }
 
-static int aio_pid = -1;
-
 static int init_aio_24(void)
 {
 	unsigned long stack;
@@ -308,6 +309,7 @@ static int submit_aio_26(enum aio_type t
 }
 #endif
 
+/* Initialized in an initcall and unchanged thereafter */
 static int aio_24 = DEFAULT_24_AIO;
 
 static int __init set_aio_24(char *name, int *add)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
