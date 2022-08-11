Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9E8C00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiHKAmp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiHKAmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D68844C6
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1357C61126
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8F8C433C1;
        Thu, 11 Aug 2022 00:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660178561;
        bh=1I+f9QWc6LzVBMRUz5sWBMoPslD77CpFojjhR3L5CRM=;
        h=Date:To:From:Subject:From;
        b=v868JZmqJDEmXYfFTkhs/LS6G4JH/JNFJbvODGW5S6XDYYrqMjLnGjH8nRaAcFXOV
         fmGjZTBNYvUa7QGHdMlnGyZstqE/birCbFff1Z11ETZlruF7k0Wqt4ymUJPCorfwdk
         O/ZlCc+qPZqKDTk3z53CSCu0RmpVdVTcs/fDOGpU=
Date:   Wed, 10 Aug 2022 17:42:40 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch added to mm-unstable branch
Message-Id: <20220811004241.5C8F8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: add /dev/userfaultfd for fine grained access control
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: add /dev/userfaultfd for fine grained access control
Date: Mon, 8 Aug 2022 10:56:11 -0700

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

Link: https://lkml.kernel.org/r/20220808175614.3885028-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   73 ++++++++++++++++++++++-------
 include/uapi/linux/userfaultfd.h |    4 +
 2 files changed, 61 insertions(+), 16 deletions(-)

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
@@ -2052,20 +2048,11 @@ static void init_once_userfaultfd_ctx(vo
 	seqcount_spinlock_init(&ctx->refile_seq, &ctx->fault_pending_wqh.lock);
 }
 
-SYSCALL_DEFINE1(userfaultfd, int, flags)
+static int new_userfaultfd(int flags)
 {
 	struct userfaultfd_ctx *ctx;
 	int fd;
 
-	if (!sysctl_unprivileged_userfaultfd &&
-	    (flags & UFFD_USER_MODE_ONLY) == 0 &&
-	    !capable(CAP_SYS_PTRACE)) {
-		printk_once(KERN_WARNING "uffd: Set unprivileged_userfaultfd "
-			"sysctl knob to 1 if kernel faults must be handled "
-			"without obtaining CAP_SYS_PTRACE capability\n");
-		return -EPERM;
-	}
-
 	BUG_ON(!current->mm);
 
 	/* Check the UFFD_* constants for consistency.  */
@@ -2098,8 +2085,62 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	return fd;
 }
 
+static inline bool userfaultfd_syscall_allowed(int flags)
+{
+	/* Userspace-only page faults are always allowed */
+	if (flags & UFFD_USER_MODE_ONLY)
+		return true;
+
+	/*
+	 * The user is requesting a userfaultfd which can handle kernel faults.
+	 * Privileged users are always allowed to do this.
+	 */
+	if (capable(CAP_SYS_PTRACE))
+		return true;
+
+	/* Otherwise, access to kernel fault handling is sysctl controlled. */
+	return sysctl_unprivileged_userfaultfd;
+}
+
+SYSCALL_DEFINE1(userfaultfd, int, flags)
+{
+	if (!userfaultfd_syscall_allowed(flags))
+		return -EPERM;
+
+	return new_userfaultfd(flags);
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
+	return new_userfaultfd(flags);
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

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

