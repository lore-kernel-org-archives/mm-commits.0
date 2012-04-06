From: akpm@linux-foundation.org
Subject: [merged] fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:50 -0700
Message-ID: <20120406184850.94AA7A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:57413 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab2DFSsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:53 -0400
Received: by laai8 with SMTP id i8so128152laa.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, david@fromorbit.com, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c:setxattr(): improve handling of allocation failures
has been removed from the -mm tree.  Its filename was
     fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/xattr.c:setxattr(): improve handling of allocation failures

This allocation can be as large as 64k.

- Add __GFP_NOWARN so the a falied kmalloc() is silent

- Fall back to vmalloc() if the kmalloc() failed

Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures
+++ a/fs/xattr.c
@@ -321,6 +321,7 @@ setxattr(struct dentry *d, const char __
 {
 	int error;
 	void *kvalue = NULL;
+	void *vvalue = NULL;	/* If non-NULL, we used vmalloc() */
 	char kname[XATTR_NAME_MAX + 1];
 
 	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
@@ -335,13 +336,25 @@ setxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = memdup_user(value, size);
-		if (IS_ERR(kvalue))
-			return PTR_ERR(kvalue);
+		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!kvalue) {
+			vvalue = vmalloc(size);
+			if (!vvalue)
+				return -ENOMEM;
+			kvalue = vvalue;
+		}
+		if (copy_from_user(kvalue, value, size)) {
+			error = -EFAULT;
+			goto out;
+		}
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
-	kfree(kvalue);
+out:
+	if (vvalue)
+		vfree(vvalue);
+	else
+		kfree(kvalue);
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

