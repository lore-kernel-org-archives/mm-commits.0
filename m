Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFB9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGSWsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiGSWsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:48:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D504F184
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FFA3B81D9F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024ABC341CA;
        Tue, 19 Jul 2022 22:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658270879;
        bh=kIsQ5++ni1TkbiwyfTn3EKOmEgldzTugyo4kvz+oDnA=;
        h=Date:To:From:Subject:From;
        b=nm4wQh7AYmDad3kcF3Vh75gujvu6f/8/pEdSwC9ao69rEoNhOUz4i3x3MJHG6rCzN
         fVAX6vNe5l59hbOPm3hTdMoVQGm61kCNPBozmPrFU8tDOCtwM8UJa3sBWjByPvkniH
         p0YkGIf9eBc/ZWDEZopw+BltIMmUT2sGUt6NBFfM=
Date:   Tue, 19 Jul 2022 15:47:58 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch removed from -mm tree
Message-Id: <20220719224759.024ABC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: add /dev/userfaultfd for fine grained access control
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: add /dev/userfaultfd for fine grained access control
Date: Wed, 1 Jun 2022 14:09:47 -0700

Historically, it has been shown that intercepting kernel faults with
userfaultfd (thereby forcing the kernel to wait for an arbitrary amount of
time) can be exploited, or at least can make some kinds of exploits
easier.  So, in 37cd0575b8 "userfaultfd: add UFFD_USER_MODE_ONLY" we
changed things so, in order for kernel faults to be handled by
userfaultfd, either the process needs CAP_SYS_PTRACE, or this sysctl must
be configured so that any unprivileged user can do it.

In a typical implementation of a hypervisor with live migration (take
QEMU/KVM as one such example), we do indeed need to be able to handle
kernel faults.  But, both options above are less than ideal:

- Toggling the sysctl increases attack surface by allowing any
  unprivileged user to do it.

- Granting the live migration process CAP_SYS_PTRACE gives it this
  ability, but *also* the ability to "observe and control the
  execution of another process [...], and examine and change [its]
  memory and registers" (from ptrace(2)). This isn't something we need
  or want to be able to do, so granting this permission violates the
  "principle of least privilege".

This is all a long winded way to say: we want a more fine-grained way to
grant access to userfaultfd, without granting other additional permissions
at the same time.

To achieve this, add a /dev/userfaultfd misc device.  This device provides
an alternative to the userfaultfd(2) syscall for the creation of new
userfaultfds.  The idea is, any userfaultfds created this way will be able
to handle kernel faults, without the caller having any special
capabilities.  Access to this mechanism is instead restricted using e.g. 
standard filesystem permissions.

Link: https://lkml.kernel.org/r/20220601210951.3916598-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   76 +++++++++++++++++++++++------
 include/uapi/linux/userfaultfd.h |    4 +
 2 files changed, 66 insertions(+), 14 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control
+++ a/fs/userfaultfd.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/hugetlb.h>
 #include <linux/swapops.h>
+#include <linux/miscdevice.h>
 
 int sysctl_unprivileged_userfaultfd __read_mostly;
 
@@ -415,13 +416,8 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	if (ctx->features & UFFD_FEATURE_SIGBUS)
 		goto out;
-	if ((vmf->flags & FAULT_FLAG_USER) == 0 &&
-	    ctx->flags & UFFD_USER_MODE_ONLY) {
-		printk_once(KERN_WARNING "uffd: Set unprivileged_userfaultfd "
-			"sysctl knob to 1 if kernel faults must be handled "
-			"without obtaining CAP_SYS_PTRACE capability\n");
+	if (!(vmf->flags & FAULT_FLAG_USER) && (ctx->flags & UFFD_USER_MODE_ONLY))
 		goto out;
-	}
 
 	/*
 	 * If it's already released don't get it. This avoids to loop
@@ -2076,19 +2072,33 @@ static void init_once_userfaultfd_ctx(vo
 	seqcount_spinlock_init(&ctx->refile_seq, &ctx->fault_pending_wqh.lock);
 }
 
-SYSCALL_DEFINE1(userfaultfd, int, flags)
+static inline bool userfaultfd_allowed(bool is_syscall, int flags)
+{
+	bool kernel_faults = !(flags & UFFD_USER_MODE_ONLY);
+	bool allow_unprivileged = sysctl_unprivileged_userfaultfd;
+
+	/* userfaultfd(2) access is controlled by sysctl + capability. */
+	if (is_syscall && kernel_faults) {
+		if (!allow_unprivileged && !capable(CAP_SYS_PTRACE))
+			return false;
+	}
+
+	/*
+	 * For /dev/userfaultfd, access is to be controlled using e.g.
+	 * permissions on the device node. We assume this is correctly
+	 * configured by userspace, so we simply allow access here.
+	 */
+
+	return true;
+}
+
+static int new_userfaultfd(bool is_syscall, int flags)
 {
 	struct userfaultfd_ctx *ctx;
 	int fd;
 
-	if (!sysctl_unprivileged_userfaultfd &&
-	    (flags & UFFD_USER_MODE_ONLY) == 0 &&
-	    !capable(CAP_SYS_PTRACE)) {
-		printk_once(KERN_WARNING "uffd: Set unprivileged_userfaultfd "
-			"sysctl knob to 1 if kernel faults must be handled "
-			"without obtaining CAP_SYS_PTRACE capability\n");
+	if (!userfaultfd_allowed(is_syscall, flags))
 		return -EPERM;
-	}
 
 	BUG_ON(!current->mm);
 
@@ -2107,6 +2117,10 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	refcount_set(&ctx->refcount, 1);
 	ctx->flags = flags;
 	ctx->features = 0;
+	/*
+	 * If UFFD_USER_MODE_ONLY is not set, then userfaultfd_allowed() above
+	 * decided that kernel faults were allowed and should be handled.
+	 */
 	ctx->released = false;
 	atomic_set(&ctx->mmap_changing, 0);
 	ctx->mm = current->mm;
@@ -2122,8 +2136,42 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	return fd;
 }
 
+SYSCALL_DEFINE1(userfaultfd, int, flags)
+{
+	return new_userfaultfd(true, flags);
+}
+
+static int userfaultfd_dev_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static long userfaultfd_dev_ioctl(struct file *file, unsigned int cmd, unsigned long flags)
+{
+	if (cmd != USERFAULTFD_IOC_NEW)
+		return -EINVAL;
+
+	return new_userfaultfd(false, flags);
+}
+
+static const struct file_operations userfaultfd_dev_fops = {
+	.open = userfaultfd_dev_open,
+	.unlocked_ioctl = userfaultfd_dev_ioctl,
+	.compat_ioctl = userfaultfd_dev_ioctl,
+	.owner = THIS_MODULE,
+	.llseek = noop_llseek,
+};
+
+static struct miscdevice userfaultfd_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "userfaultfd",
+	.fops = &userfaultfd_dev_fops
+};
+
 static int __init userfaultfd_init(void)
 {
+	WARN_ON(misc_register(&userfaultfd_misc));
+
 	userfaultfd_ctx_cachep = kmem_cache_create("userfaultfd_ctx_cache",
 						sizeof(struct userfaultfd_ctx),
 						0,
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control
+++ a/include/uapi/linux/userfaultfd.h
@@ -12,6 +12,10 @@
 
 #include <linux/types.h>
 
+/* ioctls for /dev/userfaultfd */
+#define USERFAULTFD_IOC 0xAA
+#define USERFAULTFD_IOC_NEW _IO(USERFAULTFD_IOC, 0x00)
+
 /*
  * If the UFFDIO_API is upgraded someday, the UFFDIO_UNREGISTER and
  * UFFDIO_WAKE ioctls should be defined as _IOW and not as _IOR.  In
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

