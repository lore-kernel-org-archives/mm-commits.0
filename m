From: akpm@linux-foundation.org
Subject: [merged] idr-make-idr_get_next-good-for-rcu_read_lock.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:40 -0700
Message-ID: <20120322201940.77D18A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2CVUTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:41 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: make idr_get_next() good for rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     idr-make-idr_get_next-good-for-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: idr: make idr_get_next() good for rcu_read_lock()

Make one small adjustment to idr_get_next(): take the height from the top
layer (stable under RCU) instead of from the root (unprotected by RCU), as
idr_find() does: so that it can be used with RCU locking.  Copied comment
on RCU locking from idr_find().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/idr.c~idr-make-idr_get_next-good-for-rcu_read_lock lib/idr.c
--- a/lib/idr.c~idr-make-idr_get_next-good-for-rcu_read_lock
+++ a/lib/idr.c
@@ -595,8 +595,10 @@ EXPORT_SYMBOL(idr_for_each);
  * Returns pointer to registered object with id, which is next number to
  * given id. After being looked up, *@nextidp will be updated for the next
  * iteration.
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
-
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
 	struct idr_layer *p, *pa[MAX_LEVEL];
@@ -605,11 +607,11 @@ void *idr_get_next(struct idr *idp, int 
 	int n, max;
 
 	/* find first ent */
-	n = idp->layers * IDR_BITS;
-	max = 1 << n;
 	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
+	n = (p->layer + 1) * IDR_BITS;
+	max = 1 << n;
 
 	while (id < max) {
 		while (n > 0 && p) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

