Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7BFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7054B6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWz0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E8861402;
        Sat,  8 May 2021 22:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514464;
        bh=55atUX1yb0D4r19NtjxYfHjjQEgSNDDfz1HLxHE8zK8=;
        h=Date:From:To:Subject:From;
        b=bZMfxtJ/QepoG/i3YdT2ywoD9+iiRbkT/IenmTaLFED1INkJ+iNa+rzXAxfkw8lDA
         hYzBP5/24esDy/x6pc00ZjFyYeqQlXRU/vSENkO/MUKdWJiF7564BeuG80KWt8R29i
         XPsCf69CcdBKRjqsxjFvcIVKTkCrQXpUsGHwrGrI=
Date:   Sat, 08 May 2021 15:54:24 -0700
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 kernel-asyncc-remove-async_unregister_domain.patch removed from -mm tree
Message-ID: <20210508225424.mL2DCRoTW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: remove async_unregister_domain()
has been removed from the -mm tree.  Its filename was
     kernel-asyncc-remove-async_unregister_domain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


