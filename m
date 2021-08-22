Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB330C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA14B6125F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhHVWR2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 18:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhHVWR2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 18:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940BE6108B;
        Sun, 22 Aug 2021 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629670606;
        bh=Zrgy6awcK1mq05FVDWlMgzHFrFjSijgTljHrljPKRtg=;
        h=Date:From:To:Subject:From;
        b=kgCkZRzwG4jYuJBaxmER9J/vZR/C5Y7oWqj8w2pcZ8tTR7JH+Rf59lEFEunLWNan1
         bp3GjP1djUifnC24nN5vcKIaEZmDcfiaEcsfbqEIbziIKdTCVWQrDbCZ/ItOUBY2Pw
         wuhpu2U6KgSFPyWdboNYiLpZ/lq2dnPJww04JBlc=
Date:   Sun, 22 Aug 2021 15:16:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org, keescook@chromium.org,
        jordy@pwning.systems, James.Bottomley@HansenPartnership.com,
        jordy@jordyzomer.github.io
Subject:  + mm-secretmem-use-refcount_t-instead-of-atomic_t.patch
 added to -mm tree
Message-ID: <20210822221646.ZGbOy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: use refcount_t instead of atomic_t
has been added to the -mm tree.  Its filename is
     mm-secretmem-use-refcount_t-instead-of-atomic_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-use-refcount_t-instead-of-atomic_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-use-refcount_t-instead-of-atomic_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jordy Zomer <jordy@jordyzomer.github.io>
Subject: mm/secretmem: use refcount_t instead of atomic_t

When a secret memory region is active, memfd_secret disables hibernation. 
One of the goals is to keep the secret data from being written to
persistent-storage.

It accomplishes this by maintaining a reference count to
`secretmem_users`.  Once this reference is held your system can not be
hibernated due to the check in `hibernation_available()`.  However,
because `secretmem_users` is of type `atomic_t`, reference counter
overflows are possible.

As you can see there's an `atomic_inc` for each `memfd` that is opened in
the `memfd_secret` syscall.  If a local attacker succeeds to open 2^32
memfd's, the counter will wrap around to 0.  This implies that you may
hibernate again, even though there are still regions of this secret
memory, thereby bypassing the security check.

In an attempt to fix this I have used `refcount_t` instead of `atomic_t`
which prevents reference counter overflows.

Link: https://lkml.kernel.org/r/20210820043339.2151352-1-jordy@pwning.systems
Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Cc: Kees Cook <keescook@chromium.org>,
Cc: Jordy Zomer <jordy@jordyzomer.github.io>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/secretmem.c~mm-secretmem-use-refcount_t-instead-of-atomic_t
+++ a/mm/secretmem.c
@@ -18,6 +18,7 @@
 #include <linux/secretmem.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
+#include <linux/refcount.h>
 
 #include <uapi/linux/magic.h>
 
@@ -40,11 +41,11 @@ module_param_named(enable, secretmem_ena
 MODULE_PARM_DESC(secretmem_enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
-static atomic_t secretmem_users;
+static refcount_t secretmem_users;
 
 bool secretmem_active(void)
 {
-	return !!atomic_read(&secretmem_users);
+	return !!refcount_read(&secretmem_users);
 }
 
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
@@ -103,7 +104,7 @@ static const struct vm_operations_struct
 
 static int secretmem_release(struct inode *inode, struct file *file)
 {
-	atomic_dec(&secretmem_users);
+	refcount_dec(&secretmem_users);
 	return 0;
 }
 
@@ -217,7 +218,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 	file->f_flags |= O_LARGEFILE;
 
 	fd_install(fd, file);
-	atomic_inc(&secretmem_users);
+	refcount_inc(&secretmem_users);
 	return fd;
 
 err_put_fd:
_

Patches currently in -mm which might be from jordy@jordyzomer.github.io are

mm-secretmem-use-refcount_t-instead-of-atomic_t.patch

