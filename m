From: akpm@linux-foundation.org
Subject: [merged] fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:48 -0700
Message-ID: <20120406184848.B0F9AA0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34634 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2DFSst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:49 -0400
Received: by ggnd2 with SMTP id d2so298977ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, david@fromorbit.com, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed
has been removed from the -mm tree.  Its filename was
     fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed

This allocation can be as large as 64k.  As David points out, "falling
back to vmalloc here is much better solution than failing to retreive the
attribute - it will work no matter how fragmented memory gets.  That means
we don't get incomplete backups occurring after days or months of uptime
and successful backups".

Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed
+++ a/fs/xattr.c
@@ -19,8 +19,9 @@
 #include <linux/export.h>
 #include <linux/fsnotify.h>
 #include <linux/audit.h>
-#include <asm/uaccess.h>
+#include <linux/vmalloc.h>
 
+#include <asm/uaccess.h>
 
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
@@ -492,13 +493,18 @@ listxattr(struct dentry *d, char __user 
 {
 	ssize_t error;
 	char *klist = NULL;
+	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
 
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
 		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
-		if (!klist)
-			return -ENOMEM;
+		if (!klist) {
+			vlist = vmalloc(size);
+			if (!vlist)
+				return -ENOMEM;
+			klist = vlist;
+		}
 	}
 
 	error = vfs_listxattr(d, klist, size);
@@ -510,7 +516,10 @@ listxattr(struct dentry *d, char __user 
 		   than XATTR_LIST_MAX bytes. Not possible. */
 		error = -E2BIG;
 	}
-	kfree(klist);
+	if (vlist)
+		vfree(vlist);
+	else
+		kfree(klist);
 	return error;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

