From: akpm@linux-foundation.org
Subject: + mm-memcontrol-remove-bug_on-in-uncharge_list.patch added to -mm tree
Date: Fri, 10 Jun 2016 15:44:35 -0700
Message-ID: <575b42d3.Hv8EUC3NShRmBJcU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbcFJWog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove BUG_ON in uncharge_list
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-bug_on-in-uncharge_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-bug_on-in-uncharge_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-bug_on-in-uncharge_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li RongQing <roy.qing.li@gmail.com>
Subject: mm: memcontrol: remove BUG_ON in uncharge_list

When calling uncharge_list, if a page is transparent huge we don't need to
BUG_ON about non-transparent huge, since nobody should be able to see the
page at this stage and this page cannot be raced against with a THP split.

This check became unneeded after 0a31bc97c80c ("mm: memcontrol: rewrite
uncharge API").

[mhocko@suse.com: changelog enhancements]
Link: http://lkml.kernel.org/r/1465369248-13865-1-git-send-email-roy.qing.li@gmail.com
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-bug_on-in-uncharge_list mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-bug_on-in-uncharge_list
+++ a/mm/memcontrol.c
@@ -5516,7 +5516,6 @@ static void uncharge_list(struct list_he
 
 			if (PageTransHuge(page)) {
 				nr_pages <<= compound_order(page);
-				VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 				nr_huge += nr_pages;
 			}
 			if (PageAnon(page))
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are

mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch
mm-memcontrol-remove-bug_on-in-uncharge_list.patch

