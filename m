From: akpm@linux-foundation.org
Subject: +
 list_lru-prefetch-neighboring-list-entries-before-acquiring-lock.patch
 added to -mm tree
Date: Wed, 29 Nov 2017 13:53:26 -0800
Message-ID: <5a1f2c56.kdpvjSMNbyaHJ1bb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdK2Vx2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 16:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: longman@redhat.com, david@fromorbit.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: prefetch neighboring list entries before acquiring lock
has been added to the -mm tree.  Its filename is
     list_lru-prefetch-neighboring-list-entries-before-acquiring-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list_lru-prefetch-neighboring-list-entries-before-acquiring-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list_lru-prefetch-neighboring-list-entries-before-acquiring-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/list_lru.c: prefetch neighboring list entries before acquiring lock

list_lru_del() removes the given item from the LRU list.  The operation
looks simple, but it involves writing into the cachelines of the two
neighboring list entries in order to get the deletion done.  That can take
a while if the cachelines aren't there yet, thus prolonging the lock hold
time.

To reduce the lock hold time, the cachelines of the two neighboring list
entries are now prefetched before acquiring the list_lru_node's lock.

Using a multi-threaded test program that created a large number of
dentries and then killed them, the execution time was reduced from 38.5s
to 36.6s after applying the patch on a 2-socket 36-core 72-thread x86-64
system.

Link: http://lkml.kernel.org/r/1511965054-6328-1-git-send-email-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/list_lru.c~list_lru-prefetch-neighboring-list-entries-before-acquiring-lock mm/list_lru.c
--- a/mm/list_lru.c~list_lru-prefetch-neighboring-list-entries-before-acquiring-lock
+++ a/mm/list_lru.c
@@ -132,8 +132,16 @@ bool list_lru_del(struct list_lru *lru,
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 
+	/*
+	 * Prefetch the neighboring list entries to reduce lock hold time.
+	 */
+	if (unlikely(list_empty(item)))
+		return false;
+	prefetchw(item->prev);
+	prefetchw(item->next);
+
 	spin_lock(&nlru->lock);
-	if (!list_empty(item)) {
+	if (likely(!list_empty(item))) {
 		l = list_lru_from_kmem(nlru, item);
 		list_del_init(item);
 		l->nr_items--;
_

Patches currently in -mm which might be from longman@redhat.com are

list_lru-prefetch-neighboring-list-entries-before-acquiring-lock.patch

