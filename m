Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD097C43219
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D8A60555
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbhIHC51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347371AbhIHC50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C9061130;
        Wed,  8 Sep 2021 02:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069779;
        bh=pg1m6oXEJJP9D6Ond+erSteMiOSPq8e8NARDoJ297xo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KZLNpwBqfW2nMTeYTngZQ4qHaSZcrR/17uSegXqAgc/rfQODKGROFOhnjxa0+p7rt
         85j4dq0BTAjbzdd95Rk7Koc/lgnw7rQDbv1ldyxO5WmgZoN5KoK4HIXXV0baur8FOw
         2wtJjrycGS1yDWqVcgbs5x1QuKHgEdbjWUZBUMCQ=
Date:   Tue, 07 Sep 2021 19:56:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        jordy@jordyzomer.github.io, jordy@pwning.systems,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 060/147] mm/secretmem: use refcount_t instead of
 atomic_t
Message-ID: <20210908025618.bTvTJiPSV%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
