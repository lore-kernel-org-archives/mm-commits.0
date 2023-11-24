Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA026C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbjKXTYO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbjKXTYL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:24:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17731BD2
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:24:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4DDC433CA;
        Fri, 24 Nov 2023 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700853857;
        bh=fiGuR9HbExzcS8qmHzwZYurDHlzoM6HMK14Suwf0LDQ=;
        h=Date:To:From:Subject:From;
        b=wtLWvdPLKot6Bkn85E3PBu8a3EZvNTEnflIcYaqQNPzC7RVavXlzfpxqcxDuiZzQf
         QV2h1YnQf94GncmUZf0Ldz0rqFm/q5VC5Tz/qCUCwymPbWmBQUnv1YR3Y01x7Hzkzk
         53a3ThdUDN6gldUQ2zQSZ5zf/rjXqKfgWSqqGPJw=
Date:   Fri, 24 Nov 2023 11:24:16 -0800
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch added to mm-unstable branch
Message-Id: <20231124192417.6F4DDC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: Update kernel documentation to follow the requirements
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch

