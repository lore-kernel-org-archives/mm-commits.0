From: akpm@linux-foundation.org
Subject: + tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:51:56 -0700
Message-ID: <201006012151.o51LpunJ021022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab0FAVx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, ak@linux.intel.com, hughd@google.com


The patch titled
     tmpfs: quick token library to allow scalable retrieval of tokens from token jar
has been added to the -mm tree.  Its filename is
     tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: quick token library to allow scalable retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>

We created a token jar library implementing per cpu cache of tokens to
avoid lock contentions whenever we retrieve or return a token to a token
jar.  Using this library with tmpfs, we find Aim7 fserver throughput
improved 270% on a 4 socket, 32 cores NHM-EX system.

In current implementation of tmpfs, whenever we get a new page, stat_lock
in shmem_sb_info needs to be acquired.  This causes a lot of lock
contentions when multiple threads are using tmpfs simultaneously, which
makes system with large number of cpus scale poorly.  Almost 75% of cpu
time was spent contending on stat_lock when we ran Aim7 fserver load with
128 threads on a 4 socket, 32 cores NHM-EX system.

The first patch in the series implements the quick token jar.  The second
patch update the shmem code of tmpfs to use this library to improve tmpfs
performance.



This patch:

Creates a quick token (qtoken) library to maintain local caches of tokens.
 This avoids lock contention when a token is retrieved or returned to the
token jar to improve scalability performance on system with many cpus.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/qtoken.h |   41 +++
 lib/Makefile           |    2 
 lib/qtoken.c           |  447 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 489 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/qtoken.h
--- /dev/null
+++ a/include/linux/qtoken.h
@@ -0,0 +1,41 @@
+/*
+ * qtoken.h: Structure and function prototypes to implement quick token
+ * retrieval from a jar of tokens with per cpu cache.
+ *
+ * Copyright (C) 2010 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ */
+
+#ifndef _QTOKEN_H
+#define _QTOKEN_H
+
+#define QTOKEN_CACHE_HIGH 2
+#define QTOKEN_POOL_HIGH (2 * QTOKEN_CACHE_HIGH)
+
+struct qtoken {
+	unsigned long pool;   /* pool of free tokens */
+	unsigned long total;  /* total num of tokens */
+#ifdef CONFIG_SMP
+	unsigned long init_cache_sz; /* initial cache size */
+	spinlock_t    lock;	/* lock on token jar */
+	atomic_long_t __percpu *cache; /* per cpu cache of tokens */
+#endif
+};
+
+extern void qtoken_return(struct qtoken *token_jar, unsigned long tokens);
+extern int qtoken_get(struct qtoken *token_jar, unsigned long tokens,
+			unsigned long reserve);
+extern int qtoken_init(struct qtoken *token_jar, unsigned long total_tokens,
+			unsigned long init_cache_sz);
+extern void qtoken_free(struct qtoken *token_jar);
+extern unsigned long qtoken_avail(struct qtoken *token_jar);
+extern int qtoken_resize(struct qtoken *token_jar, unsigned long new_size);
+extern unsigned long qtoken_total(struct qtoken *token_jar);
+
+#endif /* _QTOKEN_H */
diff -puN lib/Makefile~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar lib/Makefile
--- a/lib/Makefile~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o flex_array.o qtoken.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/qtoken.c
--- /dev/null
+++ a/lib/qtoken.c
@@ -0,0 +1,447 @@
+/*
+ * qtoken.c: Library of functions to implement quick token
+ * retrieval from a jar of tokens with per cpu cache.
+ *
+ * Copyright (C) 2010 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpumask.h>
+#include <linux/qtoken.h>
+
+/*
+ * This library is useful when we have a large number of threads
+ * running concurrently on many cpus trying to access tokens in a token jar
+ * at the same time.
+ *
+ * The token jar is implemented with per cpu cache of tokens.
+ * This library allows tokens to be obtained from or returned quickly to
+ * the local cpu cache without any lock acquisition most of the time.
+ * We only need to lock and modify tokens in the common pool for the
+ * following cases:
+ *
+ * 1) Not enough tokens are in our local cache and we need to get tokens
+ * from the common pool
+ * 2) We have too many tokens in local cache and need to return
+ * some tokens to the common pool
+ * 3) We want to resize the token jar and need to freeze the free tokens
+ *
+ * The local token cache is disabled by setting it to -1 and tokens
+ * reaped into the common pool when we find the common pool low in tokens.
+ * The token jar should be initialized with a cache size large enough
+ * to avoid touching the common pool's tokens frequently.
+ *
+ * It is possible to implement the token jar with just a single
+ * atomic variable for all free tokens.  However, this approach is
+ * not used here to prevent excessive cache line bouncing which causes poor
+ * performance when token jar is accessed by large number of simultaneous
+ * threads.
+ */
+
+#ifdef CONFIG_SMP
+/**
+ * qtoken_return - return tokens to token jar
+ *
+ * @token_jar: pointer to token jar
+ * @tokens: the number of tokens to return to token jar
+ *
+ * @tokens are returned to the cache in current cpu, unless
+ * the cache is disabled (i.e. value -1).  For this case,
+ * @tokens are returned to common pool.
+ * If the number of tokens in current cpu's cache exceed
+ * a a highmark, we will return the extra tokens into the
+ * common pool.
+ */
+void qtoken_return(struct qtoken *token_jar, unsigned long tokens)
+{
+	long cnt;
+	unsigned long flags;
+	int	 cpu;
+	atomic_long_t *cache;
+
+	cpu = get_cpu();
+	cache = per_cpu_ptr(token_jar->cache, cpu);
+	cnt = atomic_long_read(cache);
+	if (cnt >= 0) {
+		if ((cnt + tokens) <= QTOKEN_CACHE_HIGH * token_jar->init_cache_sz) {
+			if (!atomic_long_add_unless(cache, tokens, -1)) {
+				spin_lock_irqsave(&token_jar->lock, flags);
+				token_jar->pool += tokens;
+				spin_unlock_irqrestore(&token_jar->lock, flags);
+			}
+		} else {
+			spin_lock_irqsave(&token_jar->lock, flags);
+			if (atomic_long_add_unless(cache, token_jar->init_cache_sz - cnt, -1)) {
+				int extra;
+
+				extra = cnt + tokens - token_jar->init_cache_sz;
+
+				token_jar->pool += extra;
+			} else
+				token_jar->pool += tokens;
+			spin_unlock_irqrestore(&token_jar->lock, flags);
+		}
+	} else {
+		spin_lock_irqsave(&token_jar->lock, flags);
+		token_jar->pool += tokens;
+		spin_unlock_irqrestore(&token_jar->lock, flags);
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(qtoken_return);
+
+/**
+ * qtoken_reap cache: Move tokens from cache into common pool in token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ * The tokens in each cpu's cache are reaped and and placed in
+ * common pool.  The cache of each cpu is disabled (set to -1).
+ */
+static void qtoken_reap_cache(struct qtoken *token_jar)
+{
+	long cnt;
+	int i;
+
+	for_each_possible_cpu(i) {
+		atomic_long_t	*cache;
+
+		cache = per_cpu_ptr(token_jar->cache, i);
+		cnt = atomic_long_xchg(cache, -1);
+		if (cnt > 0)
+			token_jar->pool += cnt;
+	}
+}
+
+/**
+ * qtoken_from pool: Get tokens from common pool in token jar
+ *
+ * @token_jar: pointer to struct qtoken
+ * @tokens: the number of tokens to acquire from token jar
+ * @reserve: number of tokens to reserve in token jar after getting tokens
+ *
+ * Get @tokens from the token jar's common pool but keep @reserve tokens.
+ * We will fail the operation if we cannot keep @reserve tokens in token jar.
+ *
+ * Return 0 if operations succeeds and -ENOSPC if operation fails.
+ */
+static int qtoken_from_pool(struct qtoken *token_jar, unsigned long tokens,
+				unsigned long reserve)
+{
+	int	allocated = -ENOSPC;
+
+	/* We should have acquired lock of token pool before coming here */
+	if (token_jar->pool < (reserve + tokens))
+		qtoken_reap_cache(token_jar);
+	if (token_jar->pool >= (reserve + tokens)) {
+		token_jar->pool -= tokens;
+		allocated = 0;
+	}
+	return allocated;
+}
+
+/**
+ * qtoken_get: Get tokens from token jar
+ *
+ * @token_jar: pointer to struct qtoken
+ * @tokens: the number of tokens to acquire from token jar
+ * @reserve: number of tokens to reserve in token jar after getting tokens
+ *
+ * Get @tokens from the token jar but leave @reserve tokens in jar.
+ * Some application may come back quickly to get the reserved tokens
+ * and they do not want the get operation to succeed if it cannot succeed
+ * later.  We fail the operation if we cannot keep @reserve tokens in token jar.
+ *
+ * Return 0 if operation succeeds, non zero error code if operation fails
+ */
+int qtoken_get(struct qtoken *token_jar, unsigned long token, unsigned long reserve)
+{
+	int	allocated = -ENOSPC;
+	int	from_cache = 0;
+	int	cpu;
+	long	cnt;
+	unsigned long flags;
+	atomic_long_t *cache;
+
+	cpu = get_cpu();
+	cache = per_cpu_ptr(token_jar->cache, cpu);
+	cnt = atomic_long_read(cache);
+	if ((cnt > 0) && (cnt > token)) {
+		/* check cache's reserve first to avoid reading pool var */
+		if (cnt >= (token + reserve))
+			from_cache = 1;
+		else if ((cnt + token_jar->pool) >= (token + reserve))
+			from_cache = 1;
+	}
+	if (from_cache) {
+		if (atomic_long_add_unless(cache, -(long)token, -1))
+			allocated = 0;
+		else {
+			/* cache disabled, get token from pool */
+			spin_lock_irqsave(&token_jar->lock, flags);
+			allocated = qtoken_from_pool(token_jar, token, reserve);
+			spin_unlock_irqrestore(&token_jar->lock, flags);
+		}
+	} else {
+		unsigned long pool_high_mark;
+
+		spin_lock_irqsave(&token_jar->lock, flags);
+		pool_high_mark = QTOKEN_POOL_HIGH * token_jar->init_cache_sz
+							* num_online_cpus();
+		if (token_jar->pool > pool_high_mark + token) {
+			/* plenty of tokens, replenish cache */
+			token_jar->pool -= token + token_jar->init_cache_sz;
+			allocated = 0;
+			cnt = atomic_long_read(cache);
+			if (cnt < 0)
+				cnt = token_jar->init_cache_sz;
+			else
+				cnt += token_jar->init_cache_sz;
+			atomic_long_set(cache, cnt);
+		} else
+			allocated = qtoken_from_pool(token_jar, token, reserve);
+		spin_unlock_irqrestore(&token_jar->lock, flags);
+	}
+	put_cpu();
+	return allocated;
+}
+EXPORT_SYMBOL(qtoken_get);
+
+/**
+ * qtoken_init: Init token jar
+ *
+ * @token_jar: pointer to token jar
+ * @total_tokens: the total number of tokens that the token jar holds
+ * @cache_size: the initial size of per cpu cache of tokens
+ *
+ * Initialize the token jar structure, and allocate per cpu cache of
+ * tokens in the token jar.
+ *
+ * Returns 0 if initialization successful and non-zero error code otherwise.
+ */
+int qtoken_init(struct qtoken *token_jar, unsigned long total_tokens, unsigned long cache_size)
+{
+	int	i;
+
+	token_jar->cache = alloc_percpu(atomic_long_t);
+	if (!token_jar->cache)
+		return -ENOMEM;
+	spin_lock_init(&token_jar->lock);
+	for_each_possible_cpu(i) {
+		atomic_long_t	*cache;
+
+		cache = per_cpu_ptr(token_jar->cache, i);
+		atomic_long_set(cache, -1);
+	}
+	token_jar->init_cache_sz = cache_size;
+	token_jar->total = token_jar->pool = total_tokens;
+	return 0;
+}
+EXPORT_SYMBOL(qtoken_init);
+
+/**
+ * qtoken_free: Free token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ * Free memory for per cpu cache used in token jar and
+ * clear the token counts.
+ */
+void qtoken_free(struct qtoken *token_jar)
+{
+	if (token_jar->cache)
+		free_percpu(token_jar->cache);
+	token_jar->pool = 0;
+	token_jar->total = 0;
+}
+EXPORT_SYMBOL(qtoken_free);
+
+/**
+ * qtoken_avail: Calculates token available in token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ * Get a count of all free tokens in the token jar.
+ */
+unsigned long qtoken_avail(struct qtoken *token_jar)
+{
+	int	i;
+	long	cnt;
+	unsigned long cnt_total;
+	unsigned long flags;
+
+	spin_lock_irqsave(&token_jar->lock, flags);
+	cnt_total = token_jar->pool;
+	for_each_possible_cpu(i) {
+		atomic_long_t	*cache;
+
+		cache = per_cpu_ptr(token_jar->cache, i);
+		cnt = atomic_long_read(cache);
+		if (cnt > 0)
+			cnt_total += cnt;
+	}
+	spin_unlock_irqrestore(&token_jar->lock, flags);
+	return cnt_total;
+}
+EXPORT_SYMBOL(qtoken_avail);
+
+/**
+ * qtoken_resize: Resize the total number of tokens in token jar
+ *
+ * @token_jar: pointer to token jar
+ * @new_size: new total number of tokens in token jar
+ * Returns 0 if token jar resize successful, non zero error code otherwise
+ *
+ * We will resize the token jar and return 0 if the new total number of tokens
+ * is greater than the existing tokens in use.  Otherwise, we will fail the
+ * operation and return an error code.
+ */
+int qtoken_resize(struct qtoken *token_jar, unsigned long new_size)
+{
+	unsigned long in_use;
+	unsigned long flags;
+
+	spin_lock_irqsave(&token_jar->lock, flags);
+	qtoken_reap_cache(token_jar);
+	in_use = token_jar->total - token_jar->pool;
+	if (in_use > new_size)
+		return -EBUSY;
+	token_jar->pool = new_size - in_use;
+	token_jar->total = new_size;
+	spin_unlock_irqrestore(&token_jar->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(qtoken_resize);
+
+#else /* !CONFIG_SMP */
+
+/**
+ * qtoken_return - return tokens to token jar
+ *
+ * @token_jar: pointer to token jar
+ * @tokens: the number of tokens to return to token jar
+ */
+void qtoken_return(struct qtoken *token_jar, unsigned long tokens)
+{
+	token_jar->pool += tokens;
+}
+EXPORT_SYMBOL(qtoken_return);
+
+/**
+ * qtoken_get: Get tokens from token jar
+ *
+ * @token_jar: pointer to struct qtoken
+ * @tokens: the number of tokens to acquire from token jar
+ * @reserve: number of tokens to reserve in token jar after getting tokens
+ *
+ * Get @tokens from the token jar's but leave @reserve tokens in jar.
+ * Some application may come back quickly to get the reserved tokens
+ * and they do not want the get operation to succeed if it cannot succeed
+ * later.  We fail the operation if we cannot keep @reserve tokens in token jar.
+ *
+ * Return 0 if operation succeeds, non zero error code if operation fails
+ */
+int qtoken_get(struct qtoken *token_jar, unsigned long token, unsigned long reserve)
+{
+	int	allocated = -ENOSPC;
+
+	if (token_jar->pool >= (reserve + token)) {
+		token_jar->pool -= token;
+		allocated = 0;
+	}
+
+	return allocated;
+}
+EXPORT_SYMBOL(qtoken_get);
+
+/**
+ * qtoken_init: Init token jar
+ *
+ * @token_jar: pointer to token jar
+ * @total_tokens: the total number of tokens that the token jar holds
+ * @cache_size: the initial size of per cpu cache of tokens
+ *
+ * Initialize the token jar structure, and allocate per cpu cache of
+ * tokens for the token jar.
+ *
+ * Returns 0 if initialization is successful and non-zero error code otherwise.
+ */
+int qtoken_init(struct qtoken *token_jar, unsigned long total_tokens, unsigned long cache_size)
+{
+	token_jar->total = token_jar->pool = total_tokens;
+	return 0;
+}
+EXPORT_SYMBOL(qtoken_init);
+
+/**
+ * qtoken_free: Free token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ * Clear the token counts.
+ */
+void qtoken_free(struct qtoken *token_jar)
+{
+	token_jar->pool = 0;
+	token_jar->total = 0;
+}
+EXPORT_SYMBOL(qtoken_free);
+
+/**
+ * qtoken_avail: Calculate the tokens available in token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ */
+unsigned long qtoken_avail(struct qtoken *token_jar)
+{
+	return token_jar->pool;
+}
+EXPORT_SYMBOL(qtoken_avail);
+
+/**
+ * qtoken_resize: Resize the total number of tokens in token jar
+ *
+ * @token_jar: pointer to token jar
+ * @new_size: new total number of tokens in token jar
+ * Returns 0 if token jar resize successful, non zero error code otherwise
+ *
+ * We will resize the token jar if the new total number of tokens is greater
+ * than the existing tokens in use.  Otherwise, we will fail the operation.
+ */
+int qtoken_resize(struct qtoken *token_jar, unsigned long new_size)
+{
+	unsigned long in_use;
+
+	in_use = token_jar->total - token_jar->pool;
+	if (in_use > new_size)
+		return -EBUSY;
+	token_jar->pool = new_size - in_use;
+	token_jar->total = new_size;
+	return 0;
+}
+EXPORT_SYMBOL(qtoken_resize);
+
+#endif /* CONFIG_SMP */
+
+/**
+ * qtoken_total: Return the total number of tokens configured for token jar
+ *
+ * @token_jar: pointer to token jar
+ *
+ * Returns total number of tokens configured for token jar
+ */
+unsigned long qtoken_total(struct qtoken *token_jar)
+{
+	return token_jar->total;
+}
+EXPORT_SYMBOL(qtoken_total);
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks.patch

