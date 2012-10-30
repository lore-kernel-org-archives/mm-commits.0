From: akpm@linux-foundation.org
Subject: + mm-do-not-call-frontswap_init-during-swapoff.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:04:47 -0700
Message-ID: <20121030210447.D34C320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:47353 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964775Ab2J3VEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:04:51 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so48800lah.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:04:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, konrad.wilk@oracle.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm: do not call frontswap_init() during swapoff
has been added to the -mm tree.  Its filename is
     mm-do-not-call-frontswap_init-during-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
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

linux-next.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch

