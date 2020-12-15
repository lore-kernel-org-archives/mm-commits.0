Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9C4C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A155F22512
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgLODOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgLODOH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:07 -0500
Date:   Mon, 14 Dec 2020 19:13:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002031;
        bh=qrmZlhImrAhAU+wjugYfzvyyeXQJLuD1k6iwTDibcX4=;
        h=From:To:Subject:In-Reply-To:From;
        b=MRoCcgr8o5DLOjC+HWLZygkVTyP1oYTPqJRTD0Q9Mo/LpRN1D5NAhLgVLLExbUpM3
         Z7UOf6VK2JPBs2+/KVs4lge7J9UPn40+I8QksI4CRE6KanB8T/ANzwAGj+4FXXO7PN
         +Xme+bUMWiv2Rfi8/5xrjR94pJ4gazzGDVc/HwIc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        bigeasy@linutronix.de, calin@google.com, corbet@lwn.net,
        dancol@dancol.org, dancol@google.com, ebiggers@kernel.org,
        hannes@cmpxchg.org, jeffv@google.com, jglisse@redhat.com,
        joel@joelfernandes.org, kaleshsingh@google.com,
        keescook@chromium.org, linux-mm@kvack.org, lokeshgidra@google.com,
        mcgrof@kernel.org, mchehab+huawei@kernel.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        nigupta@nvidia.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        shli@fb.com, stephen.smalley.work@gmail.com, surenb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [patch 179/200] userfaultfd: add UFFD_USER_MODE_ONLY
Message-ID: <20201215031349.NXimL388W%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: add UFFD_USER_MODE_ONLY

Patch series "Control over userfaultfd kernel-fault handling", v6.

This patch series is split from [1].  The other series enables SELinux
support for userfaultfd file descriptors so that its creation and movement
can be controlled.

It has been demonstrated on various occasions that suspending kernel code
execution for an arbitrary amount of time at any access to userspace
memory (copy_from_user()/copy_to_user()/...) can be exploited to change
the intended behavior of the kernel.  For instance, handling page faults
in kernel-mode using userfaultfd has been exploited in [2, 3].  Likewise,
FUSE, which is similar to userfaultfd in this respect, has been exploited
in [4, 5] for similar outcome.

This small patch series adds a new flag to userfaultfd(2) that allows
callers to give up the ability to handle kernel-mode faults with the
resulting UFFD file object.  It then adds a 'user-mode only' option to the
unprivileged_userfaultfd sysctl knob to require unprivileged callers to
use this new flag.

The purpose of this new interface is to decrease the chance of an
unprivileged userfaultfd user taking advantage of userfaultfd to enhance
security vulnerabilities by lengthening the race window in kernel code.

[1] https://lore.kernel.org/lkml/20200211225547.235083-1-dancol@google.com/
[2] https://duasynt.com/blog/linux-kernel-heap-spray
[3] https://duasynt.com/blog/cve-2016-6187-heap-off-by-one-exploit
[4] https://googleprojectzero.blogspot.com/2016/06/exploiting-recursion-in-linux-kernel_20.html
[5] https://bugs.chromium.org/p/project-zero/issues/detail?id=808


This patch (of 2):

userfaultfd handles page faults from both user and kernel code.  Add a new
UFFD_USER_MODE_ONLY flag for userfaultfd(2) that makes the resulting
userfaultfd object refuse to handle faults from kernel mode, treating
these faults as if SIGBUS were always raised, causing the kernel code to
fail with EFAULT.

A future patch adds a knob allowing administrators to give some processes
the ability to create userfaultfd file objects only if they pass
UFFD_USER_MODE_ONLY, reducing the likelihood that these processes will
exploit userfaultfd's ability to delay kernel page faults to open timing
windows for future exploits.

Link: https://lkml.kernel.org/r/20201120030411.2690816-1-lokeshgidra@google.com
Link: https://lkml.kernel.org/r/20201120030411.2690816-2-lokeshgidra@google.com
Signed-off-by: Daniel Colascione <dancol@google.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <calin@google.com>
Cc: Daniel Colascione <dancol@dancol.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shaohua Li <shli@fb.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   10 +++++++++-
 include/uapi/linux/userfaultfd.h |    9 +++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~add-uffd_user_mode_only
+++ a/fs/userfaultfd.c
@@ -405,6 +405,13 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	if (ctx->features & UFFD_FEATURE_SIGBUS)
 		goto out;
+	if ((vmf->flags & FAULT_FLAG_USER) == 0 &&
+	    ctx->flags & UFFD_USER_MODE_ONLY) {
+		printk_once(KERN_WARNING "uffd: Set unprivileged_userfaultfd "
+			"sysctl knob to 1 if kernel faults must be handled "
+			"without obtaining CAP_SYS_PTRACE capability\n");
+		goto out;
+	}
 
 	/*
 	 * If it's already released don't get it. This avoids to loop
@@ -1965,10 +1972,11 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	BUG_ON(!current->mm);
 
 	/* Check the UFFD_* constants for consistency.  */
+	BUILD_BUG_ON(UFFD_USER_MODE_ONLY & UFFD_SHARED_FCNTL_FLAGS);
 	BUILD_BUG_ON(UFFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(UFFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~UFFD_SHARED_FCNTL_FLAGS)
+	if (flags & ~(UFFD_SHARED_FCNTL_FLAGS | UFFD_USER_MODE_ONLY))
 		return -EINVAL;
 
 	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
--- a/include/uapi/linux/userfaultfd.h~add-uffd_user_mode_only
+++ a/include/uapi/linux/userfaultfd.h
@@ -257,4 +257,13 @@ struct uffdio_writeprotect {
 	__u64 mode;
 };
 
+/*
+ * Flags for the userfaultfd(2) system call itself.
+ */
+
+/*
+ * Create a userfaultfd that can handle page faults only in user mode.
+ */
+#define UFFD_USER_MODE_ONLY 1
+
 #endif /* _LINUX_USERFAULTFD_H */
_
