Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEF5C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319A62242A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cj/9irUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKTXeO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgKTXeO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:34:14 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250AF2240B;
        Fri, 20 Nov 2020 23:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605915253;
        bh=VFaa5L/5EMNXYKZX4a7dsPDPKJzHulwfVxOpEtjBAZk=;
        h=Date:From:To:Subject:From;
        b=cj/9irUTB7T5hgPKZ8nVbtFImcgwKxLKj76xwBCMIXEextIVYg6U/aVb5+hv063D4
         Gv4f/ipUIWWClp5jeT1IGOLcYaQB73OLdp3+qI6t7vXo00I3JuIxVOpTS7DXybdYzO
         jReq4hbrzx2i8/2C/wbcd4MnA7+lN1JDdeUMB/CE=
Date:   Fri, 20 Nov 2020 15:34:10 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bigeasy@linutronix.de, calin@google.com,
        corbet@lwn.net, dancol@dancol.org, dancol@google.com,
        ebiggers@kernel.org, hannes@cmpxchg.org, jeffv@google.com,
        jglisse@redhat.com, joel@joelfernandes.org, kaleshsingh@google.com,
        keescook@chromium.org, lokeshgidra@google.com, mcgrof@kernel.org,
        mchehab+huawei@kernel.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, nigupta@nvidia.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, shli@fb.com,
        stephen.smalley.work@gmail.com, surenb@google.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  + add-uffd_user_mode_only.patch added to -mm tree
Message-ID: <20201120233410.BqymSHr-l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: add UFFD_USER_MODE_ONLY
has been added to the -mm tree.  Its filename is
     add-uffd_user_mode_only.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-uffd_user_mode_only.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-uffd_user_mode_only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from lokeshgidra@google.com are

add-uffd_user_mode_only.patch
add-user-mode-only-option-to-unprivileged_userfaultfd-sysctl-knob.patch

