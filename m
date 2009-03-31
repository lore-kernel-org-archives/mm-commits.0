From: akpm@linux-foundation.org
Subject: [merged] slqb-use-correct-name-for-rcu-callback.patch removed from -mm tree
Date: Tue, 31 Mar 2009 11:55:58 -0700
Message-ID: <200903311855.n2VItwHG031650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZCaS6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 14:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, npiggin@suse.de, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slqb: use correct name for rcu callback
has been removed from the -mm tree.  Its filename was
     slqb-use-correct-name-for-rcu-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slqb: use correct name for rcu callback
From: Lai Jiangshan <laijs@cn.fujitsu.com>

struct slqb_page defines struct rcu_head rcu_head for rcu,
the rcu callback should use it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slqb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slqb.c~slqb-use-correct-name-for-rcu-callback mm/slqb.c
--- a/mm/slqb.c~slqb-use-correct-name-for-rcu-callback
+++ a/mm/slqb.c
@@ -1022,7 +1022,7 @@ static void rcu_free_slab(struct rcu_hea
 {
 	struct slqb_page *page;
 
-	page = container_of((struct list_head *)h, struct slqb_page, lru);
+	page = container_of(h, struct slqb_page, rcu_head);
 	__free_slab(page->list->cache, page);
 }
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch
kallsyms-tracing-output-more-proper-symbol-name.patch
workqueue-avoid-recursion-in-run_workqueue.patch
cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch

