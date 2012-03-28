From: akpm@linux-foundation.org
Subject: + fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch added to -mm tree
Date: Wed, 28 Mar 2012 16:47:29 -0700
Message-ID: <20120328234729.D9902A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44683 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958Ab2C1Xrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 19:47:32 -0400
Received: by yenq2 with SMTP id q2so205639yen.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 16:47:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@codemonkey.org.uk, david@fromorbit.com, rientjes@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed
has been added to the -mm tree.  Its filename is
     fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/xattr.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed
+++ a/fs/xattr.c
@@ -492,13 +492,18 @@ listxattr(struct dentry *d, char __user 
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
@@ -510,7 +515,10 @@ listxattr(struct dentry *d, char __user 
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
Subject: Subject: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
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

