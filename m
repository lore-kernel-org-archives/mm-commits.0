Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E99C07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C21613C2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGIVe6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhGIVe6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:34:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E48613C9;
        Fri,  9 Jul 2021 21:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866334;
        bh=y3IFixjLJnHBwvz8ziivW10PDcdQZi1sLwsmVCra/uo=;
        h=Date:From:To:Subject:From;
        b=SZsuVZYu60Qppo1sDjkA/2LWNgQHFO447DEDSx90l0M+Bu6ubv/+HEuXM4aXM0jQE
         WDspIoQupyTlJqFw5hfRfqLmVoenYALbgIfzs/7glSzC9usZ5OnUg//NveHMr3syJO
         jnK/QVN2b5NPHKVKBag+dxJzQGU7Ap0UEiz1jcMk=
Date:   Fri, 09 Jul 2021 14:32:13 -0700
From:   akpm@linux-foundation.org
To:     cl@gentwo.de, dennis@kernel.org, joe@perches.com,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, tj@kernel.org
Subject:  [merged] lib-fix-spelling-mistakes-in-header-files.patch
 removed from -mm tree
Message-ID: <20210709213213.PVW6s9MrG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: fix spelling mistakes in header files
has been removed from the -mm tree.  Its filename was
     lib-fix-spelling-mistakes-in-header-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib: fix spelling mistakes in header files

Fix some spelling mistakes in comments found by "codespell":
Hoever ==> However
poiter ==> pointer
representaion ==> representation
uppon ==> upon
independend ==> independent
aquired ==> acquired
mis-match ==> mismatch
scrach ==> scratch
struture ==> structure
Analagous ==> Analogous
interation ==> iteration

And some were discovered manually by Joe Perches and Christoph Lameter:
stroed ==> stored
arch independent ==> an architecture independent
A example structure for ==> Example structure for

Link: https://lkml.kernel.org/r/20210609150027.14805-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Christoph Lameter <cl@gentwo.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootconfig.h      |    4 ++--
 include/linux/cpumask.h         |    2 +-
 include/linux/debugobjects.h    |    2 +-
 include/linux/lru_cache.h       |    8 ++++----
 include/linux/nodemask.h        |    6 +++---
 include/linux/percpu-refcount.h |    2 +-
 include/linux/scatterlist.h     |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

--- a/include/linux/bootconfig.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/bootconfig.h
@@ -214,10 +214,10 @@ static inline struct xbc_node * __init x
  * @value: Iterated value of array entry.
  *
  * Iterate array entries of given @key under @node. Each array entry node
- * is stroed to @anode and @value. If the @node doesn't have @key node,
+ * is stored to @anode and @value. If the @node doesn't have @key node,
  * it does nothing.
  * Note that even if the found key node has only one value (not array)
- * this executes block once. Hoever, if the found key node has no value
+ * this executes block once. However, if the found key node has no value
  * (key-only node), this does nothing. So don't use this for testing the
  * key-value pair existence.
  */
--- a/include/linux/cpumask.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/cpumask.h
@@ -259,7 +259,7 @@ extern int cpumask_next_wrap(int n, cons
 /**
  * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
  * @cpu: the (optionally unsigned) integer iterator
- * @mask: the cpumask poiter
+ * @mask: the cpumask pointer
  * @start: the start location
  *
  * The implementation does not assume any bit in @mask is set (including @start).
--- a/include/linux/debugobjects.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/debugobjects.h
@@ -18,7 +18,7 @@ enum debug_obj_state {
 struct debug_obj_descr;
 
 /**
- * struct debug_obj - representaion of an tracked object
+ * struct debug_obj - representation of an tracked object
  * @node:	hlist node to link the object into the tracker list
  * @state:	tracked object state
  * @astate:	current active state
--- a/include/linux/lru_cache.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/lru_cache.h
@@ -32,7 +32,7 @@ This header file (and its .c file; kerne
   Because of this later property, it is called "lru_cache".
   As it actually Tracks Objects in an Active SeT, we could also call it
   toast (incidentally that is what may happen to the data on the
-  backend storage uppon next resync, if we don't get it right).
+  backend storage upon next resync, if we don't get it right).
 
 What for?
 
@@ -152,7 +152,7 @@ struct lc_element {
 	 * for paranoia, and for "lc_element_to_index" */
 	unsigned lc_index;
 	/* if we want to track a larger set of objects,
-	 * it needs to become arch independend u64 */
+	 * it needs to become an architecture independent u64 */
 	unsigned lc_number;
 	/* special label when on free list */
 #define LC_FREE (~0U)
@@ -263,7 +263,7 @@ extern void lc_seq_dump_details(struct s
  *
  * Allows (expects) the set to be "dirty".  Note that the reference counts and
  * order on the active and lru lists may still change.  Used to serialize
- * changing transactions.  Returns true if we aquired the lock.
+ * changing transactions.  Returns true if we acquired the lock.
  */
 static inline int lc_try_lock_for_transaction(struct lru_cache *lc)
 {
@@ -275,7 +275,7 @@ static inline int lc_try_lock_for_transa
  * @lc: the lru cache to operate on
  *
  * Note that the reference counts and order on the active and lru lists may
- * still change.  Only works on a "clean" set.  Returns true if we aquired the
+ * still change.  Only works on a "clean" set.  Returns true if we acquired the
  * lock, which means there are no pending changes, and any further attempt to
  * change the set will not succeed until the next lc_unlock().
  */
--- a/include/linux/nodemask.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/nodemask.h
@@ -119,7 +119,7 @@ static inline const unsigned long *__nod
  * The inline keyword gives the compiler room to decide to inline, or
  * not inline a function as it sees best.  However, as these functions
  * are called in both __init and non-__init functions, if they are not
- * inlined we will end up with a section mis-match error (of the type of
+ * inlined we will end up with a section mismatch error (of the type of
  * freeable items not being freed).  So we must use __always_inline here
  * to fix the problem.  If other functions in the future also end up in
  * this situation they will also need to be annotated as __always_inline
@@ -515,7 +515,7 @@ static inline int node_random(const node
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
 /*
- * For nodemask scrach area.
+ * For nodemask scratch area.
  * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
  * name.
  */
@@ -528,7 +528,7 @@ static inline int node_random(const node
 #define NODEMASK_FREE(m)			do {} while (0)
 #endif
 
-/* A example struture for using NODEMASK_ALLOC, used in mempolicy. */
+/* Example structure for using NODEMASK_ALLOC, used in mempolicy. */
 struct nodemask_scratch {
 	nodemask_t	mask1;
 	nodemask_t	mask2;
--- a/include/linux/percpu-refcount.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/percpu-refcount.h
@@ -213,7 +213,7 @@ static inline void percpu_ref_get_many(s
  * percpu_ref_get - increment a percpu refcount
  * @ref: percpu_ref to get
  *
- * Analagous to atomic_long_inc().
+ * Analogous to atomic_long_inc().
  *
  * This function is safe to call as long as @ref is between init and exit.
  */
--- a/include/linux/scatterlist.h~lib-fix-spelling-mistakes-in-header-files
+++ a/include/linux/scatterlist.h
@@ -474,7 +474,7 @@ sg_page_iter_dma_address(struct sg_dma_p
  * Iterates over sg entries mapping page-by-page.  On each successful
  * iteration, @miter->page points to the mapped page and
  * @miter->length bytes of data can be accessed at @miter->addr.  As
- * long as an interation is enclosed between start and stop, the user
+ * long as an iteration is enclosed between start and stop, the user
  * is free to choose control structure and when to stop.
  *
  * @miter->consumed is set to @miter->length on each iteration.  It
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


