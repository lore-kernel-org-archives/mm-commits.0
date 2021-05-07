Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17DFC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82885613CD
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhEGBGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhEGBGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D59613C8;
        Fri,  7 May 2021 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349543;
        bh=vxqHu1ea6UBg9/33zGOPNKPQ5Dg6gx2AuZl+3QEcX1Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SjjIva9SFc7TLT15z919X5jHdC7wGonX1JY3KRuMGzlGhM/8BWGSs8Yp5L1y6seJY
         8u8gFPvfET833p+SDbC5+1C3prRmrwXpJkZ3NFoq1/M5HeQ9NQl78c4DOReh1r5CVU
         horYw5yiY+Lc6lGZRksB/6SCvaj72UtIsk4uDsvI=
Date:   Thu, 06 May 2021 18:05:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, corbet@lwn.net,
        gregkh@linuxfoundation.org, jeyu@kernel.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com, tiwai@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 70/91] init/initramfs.c: do unpacking
 asynchronously
Message-ID: <20210507010542.Wg91mG_Wr%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: init/initramfs.c: do unpacking asynchronously

Patch series "background initramfs unpacking, and CONFIG_MODPROBE_PATH", v3.

These two patches are independent, but better-together.

The second is a rather trivial patch that simply allows the developer to
change "/sbin/modprobe" to something else - e.g.  the empty string, so
that all request_module() during early boot return -ENOENT early, without
even spawning a usermode helper, needlessly synchronizing with the
initramfs unpacking.

The first patch delegates decompressing the initramfs to a worker thread,
allowing do_initcalls() in main.c to proceed to the device_ and late_
initcalls without waiting for that decompression (and populating of
rootfs) to finish.  Obviously, some of those later calls may rely on the
initramfs being available, so I've added synchronization points in the
firmware loader and usermodehelper paths - there might be other places
that would need this, but so far no one has been able to think of any
places I have missed.

There's not much to win if most of the functionality needed during boot is
only available as modules.  But systems with a custom-made .config and
initramfs can boot faster, partly due to utilizing more than one cpu
earlier, partly by avoiding known-futile modprobe calls (which would still
trigger synchronization with the initramfs unpacking, thus eliminating
most of the first benefit).


This patch (of 2):

Most of the boot process doesn't actually need anything from the
initramfs, until of course PID1 is to be executed.  So instead of doing
the decompressing and populating of the initramfs synchronously in
populate_rootfs() itself, push that off to a worker thread.

This is primarily motivated by an embedded ppc target, where unpacking
even the rather modest sized initramfs takes 0.6 seconds, which is long
enough that the external watchdog becomes unhappy that it doesn't get
attention soon enough.  By doing the initramfs decompression in a worker
thread, we get to do the device_initcalls and hence start petting the
watchdog much sooner.

Normal desktops might benefit as well.  On my mostly stock Ubuntu kernel,
my initramfs is a 26M xz-compressed blob, decompressing to around 126M. 
That takes almost two seconds:

[    0.201454] Trying to unpack rootfs image as initramfs...
[    1.976633] Freeing initrd memory: 29416K

Before this patch, these lines occur consecutively in dmesg.  With this
patch, the timestamps on these two lines is roughly the same as above, but
with 172 lines inbetween - so more than one cpu has been kept busy doing
work that would otherwise only happen after the populate_rootfs()
finished.

Should one of the initcalls done after rootfs_initcall time (i.e., device_
and late_ initcalls) need something from the initramfs (say, a kernel
module or a firmware blob), it will simply wait for the initramfs
unpacking to be done before proceeding, which should in theory make this
completely safe.

But if some driver pokes around in the filesystem directly and not via one
of the official kernel interfaces (i.e.  request_firmware*(),
call_usermodehelper*) that theory may not hold - also, I certainly might
have missed a spot when sprinkling wait_for_initramfs().  So there is an
escape hatch in the form of an initramfs_async= command line parameter.

Link: https://lkml.kernel.org/r/20210313212528.2956377-1-linux@rasmusvillemoes.dk
Link: https://lkml.kernel.org/r/20210313212528.2956377-2-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   12 ++++
 drivers/base/firmware_loader/main.c             |    2 
 include/linux/initrd.h                          |    2 
 init/initramfs.c                                |   38 +++++++++++++-
 init/main.c                                     |    1 
 kernel/umh.c                                    |    2 
 6 files changed, 56 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~init-initramfsc-do-unpacking-asynchronously
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1839,6 +1839,18 @@
 			initcall functions.  Useful for debugging built-in
 			modules and initcalls.
 
+	initramfs_async= [KNL]
+			Format: <bool>
+			Default: 1
+			This parameter controls whether the initramfs
+			image is unpacked asynchronously, concurrently
+			with devices being probed and
+			initialized. This should normally just work,
+			but as a debugging aid, one can get the
+			historical behaviour of the initramfs
+			unpacking being completed before device_ and
+			late_ initcalls.
+
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
 	initrdmem=	[KNL] Specify a physical address and size from which to
--- a/drivers/base/firmware_loader/main.c~init-initramfsc-do-unpacking-asynchronously
+++ a/drivers/base/firmware_loader/main.c
@@ -15,6 +15,7 @@
 #include <linux/kernel_read_file.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/initrd.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
@@ -504,6 +505,7 @@ fw_get_filesystem_firmware(struct device
 	if (!path)
 		return -ENOMEM;
 
+	wait_for_initramfs();
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		size_t file_size = 0;
 		size_t *file_size_ptr = NULL;
--- a/include/linux/initrd.h~init-initramfsc-do-unpacking-asynchronously
+++ a/include/linux/initrd.h
@@ -20,8 +20,10 @@ extern void free_initrd_mem(unsigned lon
 
 #ifdef CONFIG_BLK_DEV_INITRD
 extern void __init reserve_initrd_mem(void);
+extern void wait_for_initramfs(void);
 #else
 static inline void __init reserve_initrd_mem(void) {}
+static inline void wait_for_initramfs(void) {}
 #endif
 
 extern phys_addr_t phys_initrd_start;
--- a/init/initramfs.c~init-initramfsc-do-unpacking-asynchronously
+++ a/init/initramfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/init.h>
+#include <linux/async.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -541,6 +542,14 @@ static int __init keepinitrd_setup(char
 __setup("keepinitrd", keepinitrd_setup);
 #endif
 
+static bool __initdata initramfs_async = true;
+static int __init initramfs_async_setup(char *str)
+{
+	strtobool(str, &initramfs_async);
+	return 1;
+}
+__setup("initramfs_async=", initramfs_async_setup);
+
 extern char __initramfs_start[];
 extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
@@ -658,7 +667,7 @@ static void __init populate_initrd_image
 }
 #endif /* CONFIG_BLK_DEV_RAM */
 
-static int __init populate_rootfs(void)
+static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
 {
 	/* Load the built in initramfs */
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
@@ -693,6 +702,33 @@ done:
 	initrd_end = 0;
 
 	flush_delayed_fput();
+}
+
+static ASYNC_DOMAIN_EXCLUSIVE(initramfs_domain);
+static async_cookie_t initramfs_cookie;
+
+void wait_for_initramfs(void)
+{
+	if (!initramfs_cookie) {
+		/*
+		 * Something before rootfs_initcall wants to access
+		 * the filesystem/initramfs. Probably a bug. Make a
+		 * note, avoid deadlocking the machine, and let the
+		 * caller's access fail as it used to.
+		 */
+		pr_warn_once("wait_for_initramfs() called before rootfs_initcalls\n");
+		return;
+	}
+	async_synchronize_cookie_domain(initramfs_cookie + 1, &initramfs_domain);
+}
+EXPORT_SYMBOL_GPL(wait_for_initramfs);
+
+static int __init populate_rootfs(void)
+{
+	initramfs_cookie = async_schedule_domain(do_populate_rootfs, NULL,
+						 &initramfs_domain);
+	if (!initramfs_async)
+		wait_for_initramfs();
 	return 0;
 }
 rootfs_initcall(populate_rootfs);
--- a/init/main.c~init-initramfsc-do-unpacking-asynchronously
+++ a/init/main.c
@@ -1561,6 +1561,7 @@ static noinline void __init kernel_init_
 
 	kunit_run_all_tests();
 
+	wait_for_initramfs();
 	console_on_rootfs();
 
 	/*
--- a/kernel/umh.c~init-initramfsc-do-unpacking-asynchronously
+++ a/kernel/umh.c
@@ -27,6 +27,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <linux/uaccess.h>
+#include <linux/initrd.h>
 
 #include <trace/events/module.h>
 
@@ -107,6 +108,7 @@ static int call_usermodehelper_exec_asyn
 
 	commit_creds(new);
 
+	wait_for_initramfs();
 	retval = kernel_execve(sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);
_
