From: akpm@linux-foundation.org
Subject: + hwpoison-memcg-forcibly-uncharge-lru-pages.patch added to -mm
 tree
Date: Wed, 10 May 2017 15:25:10 -0700
Message-ID: <59139346.HDdoExnh4tJpRzMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbdEJWZL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bsingharora@gmail.com, ldufour@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison, memcg: forcibly uncharge LRU pages
has been added to the -mm tree.  Its filename is
     hwpoison-memcg-forcibly-uncharge-lru-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-memcg-forcibly-uncharge-lru-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-memcg-forcibly-uncharge-lru-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
+		 * Poisoned page might never drop its ref count to 0 so we have to
+		 * uncharge it manually from its memcg.
+		 */
+		mem_cgroup_uncharge(p);
+
 		/*
 		 * drop the page count elevated by isolate_lru_page()
 		 */
_

Patches currently in -mm which might be from mhocko@suse.com are

hwpoison-memcg-forcibly-uncharge-lru-pages.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly.patch

