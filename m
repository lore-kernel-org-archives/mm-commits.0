From: akpm@linux-foundation.org
Subject: + memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch added to -mm tree
Date: Tue, 08 Mar 2011 16:36:16 -0800
Message-ID: <201103090036.p290aGcI004123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756362Ab1CIAgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 19:36:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: page_cgroup array is never stored on reserved pages
has been added to the -mm tree.  Its filename is
     memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch

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
Subject: memcg: page_cgroup array is never stored on reserved pages
From: Michal Hocko <mhocko@suse.cz>

KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
PageReserved because we never store the array on reserved pages (neither
alloc_pages_exact nor vmalloc use those pages).

So we can replace the check by a BUG_ON.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_cgroup.c~memcg-page_cgroup-array-is-never-stored-on-reserved-pages mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-page_cgroup-array-is-never-stored-on-reserved-pages
+++ a/mm/page_cgroup.c
@@ -152,11 +152,11 @@ static void free_page_cgroup(void *addr)
 		vfree(addr);
 	} else {
 		struct page *page = virt_to_page(addr);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			size_t table_size =
-				sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-			free_pages_exact(addr, table_size);
-		}
+		size_t table_size =
+			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+
+		BUG_ON(PageReserved(page));
+		free_pages_exact(addr, table_size);
 	}
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

memsw-remove-noswapaccount-kernel-parameter.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch

