Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D19C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C6961100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhIHDBM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347322AbhIHDBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8365A61131;
        Wed,  8 Sep 2021 03:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070000;
        bh=nd4u4fDypysX9G3pFooySHBX8QI4OQwJmeR0QYSJjE0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oEAlYFh5ZvuOsBQG0oei0AgHkltvLTQdfN2ZcmYTDkkDPy1zSpSsJSjAJfzlabdwr
         J9f4fbrb00dsmoR2rDuXrHPHVK2qxK2t7A3Q7PLxKlGkC6uRttikBFgqE4LvH8NfMz
         zJ52n8DKNCr1DULdvaxxln+0twmZFtsojaEgq9ss=
Date:   Tue, 07 Sep 2021 20:00:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 127/147] fs/epoll: use a per-cpu counter for
 user's watches count
Message-ID: <20210908030000.0jfb4cnXC%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: fs/epoll: use a per-cpu counter for user's watches count

This counter tracks the number of watches a user has, to compare against
the 'max_user_watches' limit. This causes a scalability bottleneck on
SPECjbb2015 on large systems as there is only one user. Changing to a
per-cpu counter increases throughput of the benchmark by about 30% on a
16-socket, > 1000 thread system.

[rdunlap@infradead.org: fix build errors in kernel/user.c when CONFIG_EPOLL=n]
[npiggin@gmail.com: move ifdefs into wrapper functions, slightly improve panic message]
  Link: https://lkml.kernel.org/r/1628051945.fens3r99ox.astroid@bobo.none
[akpm@linux-foundation.org: tweak user_epoll_alloc(), per Guenter]
  Link: https://lkml.kernel.org/r/20210804191421.GA1900577@roeck-us.net
Link: https://lkml.kernel.org/r/20210802032013.2751916-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Anton Blanchard <anton@ozlabs.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c             |   18 ++++++++++--------
 include/linux/sched/user.h |    3 ++-
 kernel/user.c              |   25 +++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 9 deletions(-)

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
@@ -129,6 +129,22 @@ static struct user_struct *uid_hash_find
 	return NULL;
 }
 
+static int user_epoll_alloc(struct user_struct *up)
+{
+#ifdef CONFIG_EPOLL
+	return percpu_counter_init(&up->epoll_watches, 0, GFP_KERNEL);
+#else
+	return 0;
+#endif
+}
+
+static void user_epoll_free(struct user_struct *up)
+{
+#ifdef CONFIG_EPOLL
+	percpu_counter_destroy(&up->epoll_watches);
+#endif
+}
+
 /* IRQs are disabled and uidhash_lock is held upon function entry.
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
@@ -138,6 +154,7 @@ static void free_user(struct user_struct
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
+	user_epoll_free(up);
 	kmem_cache_free(uid_cachep, up);
 }
 
@@ -185,6 +202,10 @@ struct user_struct *alloc_uid(kuid_t uid
 
 		new->uid = uid;
 		refcount_set(&new->__count, 1);
+		if (user_epoll_alloc(new)) {
+			kmem_cache_free(uid_cachep, new);
+			return NULL;
+		}
 		ratelimit_state_init(&new->ratelimit, HZ, 100);
 		ratelimit_set_flags(&new->ratelimit, RATELIMIT_MSG_ON_RELEASE);
 
@@ -195,6 +216,7 @@ struct user_struct *alloc_uid(kuid_t uid
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			user_epoll_free(new);
 			kmem_cache_free(uid_cachep, new);
 		} else {
 			uid_hash_insert(new, hashent);
@@ -216,6 +238,9 @@ static int __init uid_cache_init(void)
 	for(n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(uidhash_table + n);
 
+	if (user_epoll_alloc(&root_user))
+		panic("root_user epoll percpu counter alloc failed");
+
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
 	uid_hash_insert(&root_user, uidhashentry(GLOBAL_ROOT_UID));
_
