From: akpm@linux-foundation.org
Subject: + param_sysfs_builtin-memchr-argument-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:11:00 -0700
Message-ID: <200710152311.l9FNB05D030113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbXJOXLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, greg@kroah.com


The patch titled
     param_sysfs_builtin memchr argument fix
has been added to the -mm tree.  Its filename is
     param_sysfs_builtin-memchr-argument-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: param_sysfs_builtin memchr argument fix
From: Dave Young <hidave.darkstar@gmail.com>

If memchr argument is longer than strlen(kp->name), there will be some
weird result.

It will casuse duplicate filenames in sysfs for the "nousb".  kernel
warning messages are as bellow:

sysfs: duplicate filename 'usbcore' can not be created
WARNING: at fs/sysfs/dir.c:416 sysfs_add_one()
 [<c01c4750>] sysfs_add_one+0xa0/0xe0
 [<c01c4ab8>] create_dir+0x48/0xb0
 [<c01c4b69>] sysfs_create_dir+0x29/0x50
 [<c024e0fb>] create_dir+0x1b/0x50
 [<c024e3b6>] kobject_add+0x46/0x150
 [<c024e2da>] kobject_init+0x3a/0x80
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
kobject_add failed for usbcore with -EEXIST, don't try to register things with the same name in the same directory.
 [<c024e466>] kobject_add+0xf6/0x150
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
Module 'usbcore' failed to be added to sysfs, error number -17
The system will be unstable now.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/params.c~param_sysfs_builtin-memchr-argument-fix kernel/params.c
--- a/kernel/params.c~param_sysfs_builtin-memchr-argument-fix
+++ a/kernel/params.c
@@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
zisofs-use-mutex-instead-of-semaphore.patch
param_sysfs_builtin-memchr-argument-fix.patch
