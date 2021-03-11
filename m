Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DDCC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B22764F85
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhCKWYQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhCKWX4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:23:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E591F64D9A;
        Thu, 11 Mar 2021 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615501436;
        bh=OL3DcR1UIxz2ocotjROgrjii9PTmKYTlHZE4GoOcfG4=;
        h=Date:From:To:Subject:From;
        b=yOmJFboGk/gF/uquH91GCk5sH86J7ev8VGDcOiXzeMIZgiSAJl0MmWTNgcu+4JiTZ
         jR9waxkrK4zej7IBK731LRWbte8y7+tvG6bEXbomCp4BVKuXqMizzoaN0fog3MnTQM
         XWqTQhf7nVm8IumTbTle9Fy2TW6vP/cK5i6zhi30=
Date:   Thu, 11 Mar 2021 14:23:55 -0800
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  + kernel-asyncc-remove-async_unregister_domain.patch
 added to -mm tree
Message-ID: <20210311222355.nf_j5odP5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: remove async_unregister_domain()
has been added to the -mm tree.  Its filename is
     kernel-asyncc-remove-async_unregister_domain.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-asyncc-remove-async_unregister_domain.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-asyncc-remove-async_unregister_domain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/async.c: remove async_unregister_domain()

No callers in the tree.

Link: https://lkml.kernel.org/r/20210309151723.1907838-2-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/async.h |    1 -
 kernel/async.c        |   18 ------------------
 2 files changed, 19 deletions(-)

--- a/include/linux/async.h~kernel-asyncc-remove-async_unregister_domain
+++ a/include/linux/async.h
@@ -112,7 +112,6 @@ async_schedule_dev_domain(async_func_t f
 	return async_schedule_node_domain(func, dev, dev_to_node(dev), domain);
 }
 
-void async_unregister_domain(struct async_domain *domain);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct async_domain *domain);
 extern void async_synchronize_cookie(async_cookie_t cookie);
--- a/kernel/async.c~kernel-asyncc-remove-async_unregister_domain
+++ a/kernel/async.c
@@ -246,24 +246,6 @@ void async_synchronize_full(void)
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 /**
- * async_unregister_domain - ensure no more anonymous waiters on this domain
- * @domain: idle domain to flush out of any async_synchronize_full instances
- *
- * async_synchronize_{cookie|full}_domain() are not flushed since callers
- * of these routines should know the lifetime of @domain
- *
- * Prefer ASYNC_DOMAIN_EXCLUSIVE() declarations over flushing
- */
-void async_unregister_domain(struct async_domain *domain)
-{
-	spin_lock_irq(&async_lock);
-	WARN_ON(!domain->registered || !list_empty(&domain->pending));
-	domain->registered = 0;
-	spin_unlock_irq(&async_lock);
-}
-EXPORT_SYMBOL_GPL(async_unregister_domain);
-
-/**
  * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
  * @domain: the domain to synchronize
  *
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

kernel-asyncc-fix-pr_debug-statement.patch
kernel-credc-make-init_groups-static.patch
kernel-asyncc-stop-guarding-pr_debug-statements.patch
kernel-asyncc-remove-async_unregister_domain.patch

