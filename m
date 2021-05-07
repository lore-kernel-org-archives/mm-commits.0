Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B27C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1FBA610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhEGBGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhEGBGi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D35B2613C5;
        Fri,  7 May 2021 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349540;
        bh=cEhmyAenkQrkOPZIgiy/YxM+GjDLTVvyN6NOnKmqvuM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bzJXCHDkQnga7WoSl1PRcS2YIXxxBQqKmosX3RuwvyTh4Eb9CZeJMnxA58MJonQCR
         gEtNSaA+/6HxeMbBmMWiZ2M0RqYTvtaUGtHVMMuAw20NJvSy6jbiGg3QfRRa7FqILO
         LUTrThY7FIgOFD0ux5tIUaru9xj28j8A5+/YJZ3s=
Date:   Thu, 06 May 2021 18:05:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 69/91] kernel/async.c: remove
 async_unregister_domain()
Message-ID: <20210507010539.U4pJNxYWP%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
