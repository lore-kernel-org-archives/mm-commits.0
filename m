From: akpm@linux-foundation.org
Subject: [patch 01/15] hwpoison, memcg: forcibly uncharge LRU pages
Date: Fri, 12 May 2017 15:46:26 -0700
Message-ID: <20170512224626.E1GCYeTyp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756700AbdELWq1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, ldufour@linux.vnet.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: hwpoison, memcg: forcibly uncharge LRU pages

Laurent Dufour has noticed that hwpoinsoned pages are kept charged.  In
his particular case he has hit a bad_page("page still charged to cgroup")
when onlining a hwpoison page.  While this looks like something that
shouldn't happen in the first place because onlining hwpages and returning
them to the page allocator makes only little sense it shows a real
problem.

hwpoison pages do not get freed usually so we do not uncharge them (at
least not since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")). 
Each charge pins memcg (since e8ea14cc6ead ("mm: memcontrol: take a css
reference for each charged page")) as well and so the mem_cgroup and the
associated state will never go away.  Fix this leak by forcibly uncharging
a LRU hwpoisoned page in delete_from_lru_cache().  We also have to tweak
uncharge_list because it cannot rely on zero ref count for these pages.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")
Link: http://lkml.kernel.org/r/20170502185507.GB19165@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Tested-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c     |    2 +-
 mm/memory-failure.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~hwpoison-memcg-forcibly-uncharge-lru-pages mm/memcontrol.c
--- a/mm/memcontrol.c~hwpoison-memcg-forcibly-uncharge-lru-pages
+++ a/mm/memcontrol.c
@@ -5528,7 +5528,7 @@ static void uncharge_list(struct list_he
 		next = page->lru.next;
 
 		VM_BUG_ON_PAGE(PageLRU(page), page);
-		VM_BUG_ON_PAGE(page_count(page), page);
+		VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
 
 		if (!page->mem_cgroup)
 			continue;
diff -puN mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages
+++ a/mm/memory-failure.c
@@ -539,6 +539,13 @@ static int delete_from_lru_cache(struct
 		 */
 		ClearPageActive(p);
 		ClearPageUnevictable(p);
+
+		/*
+		 * Poisoned page might never drop its ref count to 0 so we have
+		 * to uncharge it manually from its memcg.
+		 */
+		mem_cgroup_uncharge(p);
+
 		/*
 		 * drop the page count elevated by isolate_lru_page()
 		 */
_
