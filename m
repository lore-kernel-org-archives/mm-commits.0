From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-call-frontswap_init-during-swapoff.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:23 -0800
Message-ID: <20121212195823.CA40C82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51520 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLUE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:04:27 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so118697ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:04:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, konrad.wilk@oracle.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not call frontswap_init() during swapoff
has been removed from the -mm tree.  Its filename was
     mm-do-not-call-frontswap_init-during-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: mm: do not call frontswap_init() during swapoff

The call to frontswap_init() was added within enable_swap_info(), which
was called not only during sys_swapon, but also to reinsert the swap_info
into the swap_list in case of failure of try_to_unuse() within
sys_swapoff.  This means that frontswap_init() might be called more than
once for the same swap area.

While as far as I could see no frontswap implementation has any problem
with it (and in fact, all the ones I found ignore the parameter passed to
frontswap_init), this could change in the future.

To prevent future problems, move the call to frontswap_init() to outside
the code shared between sys_swapon and sys_swapoff.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-do-not-call-frontswap_init-during-swapoff mm/swapfile.c
--- a/mm/swapfile.c~mm-do-not-call-frontswap_init-during-swapoff
+++ a/mm/swapfile.c
@@ -1471,7 +1471,6 @@ static void _enable_swap_info(struct swa
 		swap_list.head = swap_list.next = p->type;
 	else
 		swap_info[prev]->next = p->type;
-	frontswap_init(p->type);
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
@@ -1480,6 +1479,7 @@ static void enable_swap_info(struct swap
 {
 	spin_lock(&swap_lock);
 	_enable_swap_info(p, prio, swap_map, frontswap_map);
+	frontswap_init(p->type);
 	spin_unlock(&swap_lock);
 }
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch
maintainers-remove-include-linux-ext3.patch

