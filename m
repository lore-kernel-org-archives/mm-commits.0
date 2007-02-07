From: akpm@linux-foundation.org
Subject: + uml-aio-locking-and-tidying.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:20:57 -0800
Message-ID: <200702072320.l17NKvGG030944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161484AbXBGXVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: AIO locking and tidying
has been added to the -mm tree.  Its filename is
     uml-aio-locking-and-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 insertions(+), 7 deletions(-)

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

x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch
uml-fix-prototypes.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
