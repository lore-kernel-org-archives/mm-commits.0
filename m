Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2086EC4320A
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0262D60FC0
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhHBVJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhHBVJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3B260F4B;
        Mon,  2 Aug 2021 21:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627938568;
        bh=lCiHQySjDImU6wAo9QbLV8XtmX23sClYU/hHwTCHOz0=;
        h=Date:From:To:Subject:From;
        b=zTZDoibu3aWvgX4o1+K+p8L/d/4yLugyb2j8PyYSuGmHybR8L60fnNAIIaixGd9pv
         5MOWgDjtxnhtkLxpzBUq5jIAB+BhpElstAvDxL9ShYAYg9sURdKnpuqPrF1VLCc2NE
         jkAQEJvJC6oQQ0invTBIoj3WD1xRuvMPgS912B0w=
Date:   Mon, 02 Aug 2021 14:09:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        anton@ozlabs.org, npiggin@gmail.com
Subject:  +
 fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch added to -mm
 tree
Message-ID: <20210802210928.P-pQs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/epoll: use a per-cpu counter for user's watches count
has been added to the -mm tree.  Its filename is
     fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: fs/epoll: use a per-cpu counter for user's watches count

This counter tracks the number of watches a user has, to compare against
the 'max_user_watches' limit. This causes a scalability bottleneck on
SPECjbb2015 on large systems as there is only one user. Changing to a
per-cpu counter increases throughput of the benchmark by about 30% on a
16-socket, > 1000 thread system.

Link: https://lkml.kernel.org/r/20210802032013.2751916-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Anton Blanchard <anton@ozlabs.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c             |   18 ++++++++++--------
 include/linux/sched/user.h |    3 ++-
 kernel/user.c              |    9 +++++++++
 3 files changed, 21 insertions(+), 9 deletions(-)

--- a/fs/eventpoll.c~fs-epoll-use-a-per-cpu-counter-for-users-watches-count
+++ a/fs/eventpoll.c
@@ -723,7 +723,7 @@ static int ep_remove(struct eventpoll *e
 	 */
 	call_rcu(&epi->rcu, epi_rcu_free);
 
-	atomic_long_dec(&ep->user->epoll_watches);
+	percpu_counter_dec(&ep->user->epoll_watches);
 
 	return 0;
 }
@@ -1439,7 +1439,6 @@ static int ep_insert(struct eventpoll *e
 {
 	int error, pwake = 0;
 	__poll_t revents;
-	long user_watches;
 	struct epitem *epi;
 	struct ep_pqueue epq;
 	struct eventpoll *tep = NULL;
@@ -1449,11 +1448,15 @@ static int ep_insert(struct eventpoll *e
 
 	lockdep_assert_irqs_enabled();
 
-	user_watches = atomic_long_read(&ep->user->epoll_watches);
-	if (unlikely(user_watches >= max_user_watches))
+	if (unlikely(percpu_counter_compare(&ep->user->epoll_watches,
+					    max_user_watches) >= 0))
 		return -ENOSPC;
-	if (!(epi = kmem_cache_zalloc(epi_cache, GFP_KERNEL)))
+	percpu_counter_inc(&ep->user->epoll_watches);
+
+	if (!(epi = kmem_cache_zalloc(epi_cache, GFP_KERNEL))) {
+		percpu_counter_dec(&ep->user->epoll_watches);
 		return -ENOMEM;
+	}
 
 	/* Item initialization follow here ... */
 	INIT_LIST_HEAD(&epi->rdllink);
@@ -1466,17 +1469,16 @@ static int ep_insert(struct eventpoll *e
 		mutex_lock_nested(&tep->mtx, 1);
 	/* Add the current item to the list of active epoll hook for this file */
 	if (unlikely(attach_epitem(tfile, epi) < 0)) {
-		kmem_cache_free(epi_cache, epi);
 		if (tep)
 			mutex_unlock(&tep->mtx);
+		kmem_cache_free(epi_cache, epi);
+		percpu_counter_dec(&ep->user->epoll_watches);
 		return -ENOMEM;
 	}
 
 	if (full_check && !tep)
 		list_file(tfile);
 
-	atomic_long_inc(&ep->user->epoll_watches);
-
 	/*
 	 * Add the current item to the RB tree. All RB tree operations are
 	 * protected by "mtx", and ep_insert() is called with "mtx" held.
--- a/include/linux/sched/user.h~fs-epoll-use-a-per-cpu-counter-for-users-watches-count
+++ a/include/linux/sched/user.h
@@ -4,6 +4,7 @@
 
 #include <linux/uidgid.h>
 #include <linux/atomic.h>
+#include <linux/percpu_counter.h>
 #include <linux/refcount.h>
 #include <linux/ratelimit.h>
 
@@ -13,7 +14,7 @@
 struct user_struct {
 	refcount_t __count;	/* reference count */
 #ifdef CONFIG_EPOLL
-	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
+	struct percpu_counter epoll_watches; /* The number of file descriptors currently watched */
 #endif
 	unsigned long unix_inflight;	/* How many files in flight in unix sockets */
 	atomic_long_t pipe_bufs;  /* how many pages are allocated in pipe buffers */
--- a/kernel/user.c~fs-epoll-use-a-per-cpu-counter-for-users-watches-count
+++ a/kernel/user.c
@@ -138,6 +138,7 @@ static void free_user(struct user_struct
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
+	percpu_counter_destroy(&up->epoll_watches);
 	kmem_cache_free(uid_cachep, up);
 }
 
@@ -185,6 +186,10 @@ struct user_struct *alloc_uid(kuid_t uid
 
 		new->uid = uid;
 		refcount_set(&new->__count, 1);
+		if (percpu_counter_init(&new->epoll_watches, 0, GFP_KERNEL)) {
+			kmem_cache_free(uid_cachep, new);
+			return NULL;
+		}
 		ratelimit_state_init(&new->ratelimit, HZ, 100);
 		ratelimit_set_flags(&new->ratelimit, RATELIMIT_MSG_ON_RELEASE);
 
@@ -195,6 +200,7 @@ struct user_struct *alloc_uid(kuid_t uid
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			percpu_counter_destroy(&new->epoll_watches);
 			kmem_cache_free(uid_cachep, new);
 		} else {
 			uid_hash_insert(new, hashent);
@@ -216,6 +222,9 @@ static int __init uid_cache_init(void)
 	for(n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(uidhash_table + n);
 
+	if (percpu_counter_init(&root_user.epoll_watches, 0, GFP_KERNEL))
+		panic("percpu cpunter alloc failed");
+
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
 	uid_hash_insert(&root_user, uidhashentry(GLOBAL_ROOT_UID));
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

