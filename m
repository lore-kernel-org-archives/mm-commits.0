From: akpm@linux-foundation.org
Subject: [merged] memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:16 -0700
Message-ID: <201103250725.p2P7PATl026002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933936Ab1CYHZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: page_cgroup array is never stored on reserved pages
has been removed from the -mm tree.  Its filename was
     memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -153,11 +153,11 @@ static void free_page_cgroup(void *addr)
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
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch

