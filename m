From: akpm@linux-foundation.org
Subject: [merged]
 initramfs-finish-fput-before-accessing-any-binary-from-initramfs.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:50:39 -0800
Message-ID: <58b5e29f.ntc2TpbtbQUcTnYU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdB1Uve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lokeshvutla@ti.com, m-karicheri2@ti.com, nm@ti.com, nsekhar@ti.com, t-kristo@ti.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: finish fput() before accessing any binary from initramfs
has been removed from the -mm tree.  Its filename was
     initramfs-finish-fput-before-accessing-any-binary-from-initramfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: initramfs: finish fput() before accessing any binary from initramfs

commit 4a9d4b024a31 ("switch fput to task_work_add") implements a
schedule_work() for completing fput(), but did not guarantee calling
__fput() after unpacking initramfs. Because of this, there is a
possibility that during boot a driver can see ETXTBSY when it tries
to load a binary from initramfs as fput() is still pending on that
binary. This patch makes sure that fput() is completed after unpacking
initramfs and removes the call to flush_delayed_fput() in kernel_init()
which happens very late after unpacking initramfs.

Link: http://lkml.kernel.org/r/20170201140540.22051-1-lokeshvutla@ti.com
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Reported-by: Murali Karicheri <m-karicheri2@ti.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 ++
 init/main.c      |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN init/initramfs.c~initramfs-finish-fput-before-accessing-any-binary-from-initramfs init/initramfs.c
--- a/init/initramfs.c~initramfs-finish-fput-before-accessing-any-binary-from-initramfs
+++ a/init/initramfs.c
@@ -18,6 +18,7 @@
 #include <linux/dirent.h>
 #include <linux/syscalls.h>
 #include <linux/utime.h>
+#include <linux/file.h>
 
 static ssize_t __init xwrite(int fd, const char *p, size_t count)
 {
@@ -647,6 +648,7 @@ static int __init populate_rootfs(void)
 			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
 		free_initrd();
 #endif
+		flush_delayed_fput();
 		/*
 		 * Try loading default modules from initramfs.  This gives
 		 * us a chance to load before device_initcalls.
diff -puN init/main.c~initramfs-finish-fput-before-accessing-any-binary-from-initramfs init/main.c
--- a/init/main.c~initramfs-finish-fput-before-accessing-any-binary-from-initramfs
+++ a/init/main.c
@@ -71,7 +71,6 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
-#include <linux/file.h>
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
@@ -960,8 +959,6 @@ static int __ref kernel_init(void *unuse
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
-	flush_delayed_fput();
