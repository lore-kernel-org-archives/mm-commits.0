Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9453B6
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AFnv9rdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D62FC433C8;
	Mon, 11 Dec 2023 00:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256128;
	bh=grEOpr6tC5FykUQ4FprnAN76qkUaryWal4yF02/XDpY=;
	h=Date:To:From:Subject:From;
	b=AFnv9rdzH9Ehp2OfvdYyuphjM6GyIoTjDYnay7SczPq/A0EFxZ/OlZbf8ATSNPI8U
	 OT7Aa/BfthnXD8C6g7pobxbAdZo/xUkXjfftVpVs+0rHORKTZ64Zr0n+oCsEujjAiI
	 gVBfAzrepY47sHGeUeYsohmYy994v3dhkhXx7VeU=
Date: Sun, 10 Dec 2023 16:55:26 -0800
To: mm-commits@vger.kernel.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch removed from -mm tree
Message-Id: <20231211005528.5D62FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: Update kernel documentation to follow the requirements
has been removed from the -mm tree.  Its filename was
     mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: list_lru: Update kernel documentation to follow the requirements
Date: Thu, 23 Nov 2023 19:23:17 +0200

kernel-doc is not happy about documentation in list_lru.h:

list_lru.h:90: warning: Function parameter or member 'lru' not described in 'list_lru_add'
list_lru.h:90: warning: Excess function parameter 'list_lru' description in 'list_lru_add'
list_lru.h:90: warning: No description found for return value of 'list_lru_add'
list_lru.h:103: warning: Function parameter or member 'lru' not described in 'list_lru_del'
list_lru.h:103: warning: Excess function parameter 'list_lru' description in 'list_lru_del'
list_lru.h:103: warning: No description found for return value of 'list_lru_del'
list_lru.h:116: warning: No description found for return value of 'list_lru_count_one'
list_lru.h:168: warning: No description found for return value of 'list_lru_walk_one'
list_lru.h:185: warning: No description found for return value of 'list_lru_walk_one_irq'

Fix the documentation accordingly.

While at it, fix the references to the parameters in functions
inside the long descriptions, on which the above script is not
complaining (yet?).

Link: https://lkml.kernel.org/r/20231123172320.2434780-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-update-kernel-documentation-to-follow-the-requirements
+++ a/include/linux/list_lru.h
@@ -73,7 +73,7 @@ void memcg_reparent_list_lrus(struct mem
 
 /**
  * list_lru_add: add an element to the lru list's tail
- * @list_lru: the lru pointer
+ * @lru: the lru pointer
  * @item: the item to be added.
  *
  * If the element is already part of a list, this function returns doing
@@ -83,22 +83,22 @@ void memcg_reparent_list_lrus(struct mem
  * the caller organize itself in a way that elements can be in more than
  * one type of list, it is up to the caller to fully remove the item from
  * the previous list (with list_lru_del() for instance) before moving it
- * to @list_lru
+ * to @lru.
  *
- * Return value: true if the list was updated, false otherwise
+ * Return: true if the list was updated, false otherwise
  */
 bool list_lru_add(struct list_lru *lru, struct list_head *item);
 
 /**
  * list_lru_del: delete an element to the lru list
- * @list_lru: the lru pointer
+ * @lru: the lru pointer
  * @item: the item to be deleted.
  *
- * This function works analogously as list_lru_add in terms of list
+ * This function works analogously as list_lru_add() in terms of list
  * manipulation. The comments about an element already pertaining to
- * a list are also valid for list_lru_del.
+ * a list are also valid for list_lru_del().
  *
- * Return value: true if the list was updated, false otherwise
+ * Return: true if the list was updated, false otherwise
  */
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
@@ -108,9 +108,11 @@ bool list_lru_del(struct list_lru *lru,
  * @nid: the node id to count from.
  * @memcg: the cgroup to count from.
  *
- * Always return a non-negative number, 0 for empty lists. There is no
- * guarantee that the list is not updated while the count is being computed.
- * Callers that want such a guarantee need to provide an outer lock.
+ * There is no guarantee that the list is not updated while the count is being
+ * computed. Callers that want such a guarantee need to provide an outer lock.
+ *
+ * Return: 0 for empty lists, otherwise the number of objects
+ * currently held by @lru.
  */
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg);
@@ -141,7 +143,7 @@ typedef enum lru_status (*list_lru_walk_
 		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
 
 /**
- * list_lru_walk_one: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_one: walk a @lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
@@ -150,24 +152,24 @@ typedef enum lru_status (*list_lru_walk_
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
  *
- * This function will scan all elements in a particular list_lru, calling the
+ * This function will scan all elements in a particular @lru, calling the
  * @isolate callback for each of those items, along with the current list
  * spinlock and a caller-provided opaque. The @isolate callback can choose to
  * drop the lock internally, but *must* return with the lock held. The callback
- * will return an enum lru_status telling the list_lru infrastructure what to
+ * will return an enum lru_status telling the @lru infrastructure what to
  * do with the object being scanned.
  *
- * Please note that nr_to_walk does not mean how many objects will be freed,
+ * Please note that @nr_to_walk does not mean how many objects will be freed,
  * just how many objects will be scanned.
  *
- * Return value: the number of objects effectively removed from the LRU.
+ * Return: the number of objects effectively removed from the LRU.
  */
 unsigned long list_lru_walk_one(struct list_lru *lru,
 				int nid, struct mem_cgroup *memcg,
 				list_lru_walk_cb isolate, void *cb_arg,
 				unsigned long *nr_to_walk);
 /**
- * list_lru_walk_one_irq: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_one_irq: walk a @lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
@@ -176,7 +178,7 @@ unsigned long list_lru_walk_one(struct l
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
  *
- * Same as @list_lru_walk_one except that the spinlock is acquired with
+ * Same as list_lru_walk_one() except that the spinlock is acquired with
  * spin_lock_irq().
  */
 unsigned long list_lru_walk_one_irq(struct list_lru *lru,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


