From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-remove-bug_on-in-uncharge_list.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:03:23 -0700
Message-ID: <5799057b.y4u6wkiaT4Xmy2jY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove BUG_ON in uncharge_list
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-bug_on-in-uncharge_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5580,7 +5580,6 @@ static void uncharge_list(struct list_he
 
 			if (PageTransHuge(page)) {
 				nr_pages <<= compound_order(page);
-				VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 				nr_huge += nr_pages;
 			}
 			if (PageAnon(page))
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are


