Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04988C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA07224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgLODOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbgLODOh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:37 -0500
Date:   Mon, 14 Dec 2020 19:13:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002036;
        bh=nkW2/q6Ai/VIeeigz2vg/kGiHU/H4sL1QSI7nxooTZU=;
        h=From:To:Subject:In-Reply-To:From;
        b=uFrZcTuYYZaNLEFClzvy9BonD1rEqNmPMxm0QsAuPeba1e2+Azbu7JNB6XjJ9EAkj
         /h4R+3kaxhwgK/O4POZ0jN35tYMr8z++9eyXA8HeTBx561ESdJ+7ufaSC5vxXRkpau
         8cD2mjqHSZ6zs2NlN8So/FE/P2IS3sHCH2A4KfXQ=
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
Subject:  [patch 180/200] userfaultfd: add user-mode only option to
 unprivileged_userfaultfd sysctl knob
Message-ID: <20201215031354.gUsHJUpKo%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: add user-mode only option to unprivileged_userfaultfd sysctl knob

With this change, when the knob is set to 0, it allows unprivileged users
to call userfaultfd, like when it is set to 1, but with the restriction
that page faults from only user-mode can be handled.  In this mode, an
unprivileged user (without SYS_CAP_PTRACE capability) must pass
UFFD_USER_MODE_ONLY to userfaultd or the API will fail with EPERM.

This enables administrators to reduce the likelihood that an attacker with
access to userfaultfd can delay faulting kernel code to widen timing
windows for other exploits.

The default value of this knob is changed to 0.  This is required for
correct functioning of pipe mutex.  However, this will fail postcopy live
migration, which will be unnoticeable to the VM guests.  To avoid this,
set 'vm.userfault = 1' in /sys/sysctl.conf.

The main reason this change is desirable as in the short term is that the
Android userland will behave as with the sysctl set to zero.  So without
this commit, any Linux binary using userfaultfd to manage its memory would
behave differently if run within the Android userland.  For more details,
refer to Andrea's reply [1].

[1] https://lore.kernel.org/lkml/20200904033438.GI9411@redhat.com/

Link: https://lkml.kernel.org/r/20201120030411.2690816-3-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Daniel Colascione <dancol@dancol.org>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: <calin@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Colascione <dancol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   15 ++++++++++-----
 fs/userfaultfd.c                        |   10 ++++++++--
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~add-user-mode-only-option-to-unprivileged_userfaultfd-sysctl-knob
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -873,12 +873,17 @@ file-backed pages is less than the high
 unprivileged_userfaultfd
 ========================
 
-This flag controls whether unprivileged users can use the userfaultfd
-system calls.  Set this to 1 to allow unprivileged users to use the
-userfaultfd system calls, or set this to 0 to restrict userfaultfd to only
-privileged users (with SYS_CAP_PTRACE capability).
+This flag controls the mode in which unprivileged users can use the
+userfaultfd system calls. Set this to 0 to restrict unprivileged users
+to handle page faults in user mode only. In this case, users without
+SYS_CAP_PTRACE must pass UFFD_USER_MODE_ONLY in order for userfaultfd to
+succeed. Prohibiting use of userfaultfd for handling faults from kernel
+mode may make certain vulnerabilities more difficult to exploit.
 
-The default value is 1.
+Set this to 1 to allow unprivileged users to use the userfaultfd system
+calls without any restrictions.
+
+The default value is 0.
 
 
 user_reserve_kbytes
--- a/fs/userfaultfd.c~add-user-mode-only-option-to-unprivileged_userfaultfd-sysctl-knob
+++ a/fs/userfaultfd.c
@@ -28,7 +28,7 @@
 #include <linux/security.h>
 #include <linux/hugetlb.h>
 
-int sysctl_unprivileged_userfaultfd __read_mostly = 1;
+int sysctl_unprivileged_userfaultfd __read_mostly;
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
@@ -1966,8 +1966,14 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	struct userfaultfd_ctx *ctx;
 	int fd;
 
-	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
+	if (!sysctl_unprivileged_userfaultfd &&
+	    (flags & UFFD_USER_MODE_ONLY) == 0 &&
+	    !capable(CAP_SYS_PTRACE)) {
+		printk_once(KERN_WARNING "uffd: Set unprivileged_userfaultfd "
+			"sysctl knob to 1 if kernel faults must be handled "
+			"without obtaining CAP_SYS_PTRACE capability\n");
 		return -EPERM;
+	}
 
 	BUG_ON(!current->mm);
 
_
