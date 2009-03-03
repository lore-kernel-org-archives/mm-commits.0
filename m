From: akpm@linux-foundation.org
Subject: + slqb-use-correct-name-for-rcu-callback.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:09:39 -0800
Message-ID: <200903032109.n23L9dZs003832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbZCCVKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     slqb: use correct name for rcu callback
has been added to the -mm tree.  Its filename is
     slqb-use-correct-name-for-rcu-callback.patch

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

linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
workqueue-avoid-recursion-in-run_workqueue.patch
cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch

