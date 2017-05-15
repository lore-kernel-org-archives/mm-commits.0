From: akpm@linux-foundation.org
Subject: + make-initramfs-honor-config_devtmpfs_mount.patch added to -mm
 tree
Date: Mon, 15 May 2017 15:02:12 -0700
Message-ID: <591a2564.i43fC47GcWCNHHMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdEOWCN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 18:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, ebiederm@xmission.com, fabf@skynet.be, jean-paul.saman@nxp.com, keescook@chromium.org, linux@rasmusvillemoes.dk, pmladek@suse.com, prarit@redhat.com, re.emese@gmail.com, viro@zeniv.linux.org.uk, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: make initramfs honor CONFIG_DEVTMPFS_MOUNT
has been added to the -mm tree.  Its filename is
     make-initramfs-honor-config_devtmpfs_mount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-initramfs-honor-config_devtmpfs_mount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-initramfs-honor-config_devtmpfs_mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: initramfs: make initramfs honor CONFIG_DEVTMPFS_MOUNT

Make initramfs honor CONFIG_DEVTMPFS_MOUNT, fixing 2b2af54a5bb6 ("Driver
Core: devtmpfs - kernel-maintained tmpfs-based /dev"), which didn't
bother.  Move /dev/console open after devtmpfs mount, and update help
text.

Commit 456eeabab849 in 2005 made gen_initramfs_list (when run with no
arguments) spit out an 'example' config creating /dev and /dev/console. 
The kernel accidentally(?) included this for many years when you didn't
specify initramfs contents, and of course grew dependencies on this
/dev/console node in the (often hidden) initramfs.  c33df4eaaf41 ("disable
init/initramfs.c") in 2007 explicitly preserved this dependency. 
2bd3a997befc ("init: Open /dev/console from rootfs") in 2010 claimed it
"removes the occasionally problematic assumption that /dev/console exists
from the boot code" but actually just moved it later.

But nobody never tested statically linking an initramfs.  If you point
CONFIG_INITRAMFS_SOURCE at a directory running the build as a normal user
you _don't_ get a /dev/console (because you can't create it without being
root, and can't use the existing one out of /dev unless you create your
own initramfs list file), in which case init runs with stdin/stdout/stderr
closed and you get no output.

Eric's test case for his 2010 commit referenced above was:

  With this patch I was able to throw busybox on my /boot partition
  (which has no /dev directory) and boot into userspace without
  problems.

But it didn't work pointing CONFIG_INITRAMFS_SOURCE at a directory of the
same files.  This provides the "automatically mounting devtmpfs on /dev"
workaround the earlier commit was trying to avoid.

Link: http://lkml.kernel.org/r/21935caf-501d-e97c-5611-5c4af7e0f9ae@landley.net
Signed-off-by: Rob Landley <rob@landley.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jean-Paul Saman <jean-paul.saman@nxp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |   14 ++++----------
 init/main.c          |   15 +++++++++------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff -puN drivers/base/Kconfig~make-initramfs-honor-config_devtmpfs_mount drivers/base/Kconfig
--- a/drivers/base/Kconfig~make-initramfs-honor-config_devtmpfs_mount
+++ a/drivers/base/Kconfig
@@ -48,16 +48,10 @@ config DEVTMPFS_MOUNT
 	bool "Automount devtmpfs at /dev, after the kernel mounted the rootfs"
 	depends on DEVTMPFS
 	help
-	  This will instruct the kernel to automatically mount the
-	  devtmpfs filesystem at /dev, directly after the kernel has
-	  mounted the root filesystem. The behavior can be overridden
-	  with the commandline parameter: devtmpfs.mount=0|1.
-	  This option does not affect initramfs based booting, here
-	  the devtmpfs filesystem always needs to be mounted manually
-	  after the rootfs is mounted.
-	  With this option enabled, it allows to bring up a system in
-	  rescue mode with init=/bin/sh, even when the /dev directory
-	  on the rootfs is completely empty.
+	  Automatically mount devtmpfs at /dev on the root filesystem, which
+	  lets the system to come up in rescue mode with [rd]init=/bin/sh.
+	  Override with devtmpfs.mount=0 on the commandline. Initramfs can
+	  create a /dev dir as needed, other rootfs needs the mount point.
 
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware"
diff -puN init/main.c~make-initramfs-honor-config_devtmpfs_mount init/main.c
--- a/init/main.c~make-initramfs-honor-config_devtmpfs_mount
+++ a/init/main.c
@@ -1038,12 +1038,6 @@ static noinline void __init kernel_init_
 
 	do_basic_setup();
 
-	/* Open the /dev/console on the rootfs, this should never fail */
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		pr_err("Warning: unable to open an initial console.\n");
-
-	(void) sys_dup(0);
-	(void) sys_dup(0);
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
@@ -1055,8 +1049,17 @@ static noinline void __init kernel_init_
 	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
+	} else if (IS_ENABLED(CONFIG_DEVTMPFS_MOUNT)) {
+		sys_mkdir("/dev", 0755);
+		devtmpfs_mount("/dev");
 	}
 
+	/* Open the /dev/console on the rootfs, this should never fail */
+	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+		pr_err("Warning: unable to open an initial console.\n");
+	(void) sys_dup(0);
+	(void) sys_dup(0);
+
 	/*
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the
_

Patches currently in -mm which might be from rob@landley.net are

teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch
clarify-help-text-that-compression-applies-to-ramfs-as-well-as-legacy-ramdisk.patch
make-initramfs-honor-config_devtmpfs_mount.patch

