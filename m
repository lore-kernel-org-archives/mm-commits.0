From: akpm@linux-foundation.org
Subject: + mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 15:26:45 -0700
Message-ID: <59e683a5.EsXc638m3pN9WNrd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935130AbdJQW0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mpe@ellerman.id.au, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop migrate type checks from has_unmovable_pages
has been added to the -mm tree.  Its filename is
     mm-drop-migrate-type-checks-from-has_unmovable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-migrate-type-checks-from-has_unmovable_pages.patch

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
Subject: mm: drop migrate type checks from has_unmovable_pages

Michael has noticed that the memory offline tries to migrate kernel code
pages when doing

 echo 0 > /sys/devices/system/memory/memory0/online

The current implementation will fail the operation after several failed
page migration attempts but we shouldn't even attempt to migrate that
memory and fail right away because this memory is clearly not migrateable.
This will become a real problem when we drop the retry loop counter resp.
timeout.

The real problem is in has_unmovable_pages in fact.  We should fail if
there are any non migrateable pages in the area.  In orther to guarantee
that remove the migrate type checks because MIGRATE_MOVABLE is not
guaranteed to contain only migrateable pages.  It is merely a heuristic. 
Similarly MIGRATE_CMA does guarantee that the page allocator doesn't
allocate any non-migrateable pages from the block but CMA allocations
themselves are unlikely to migrateable.  Therefore remove both checks.

Link: http://lkml.kernel.org/r/20171013120013.698-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -7360,9 +7360,6 @@ bool has_unmovable_pages(struct zone *zo
 	 */
 	if (zone_idx(zone) == ZONE_MOVABLE)
 		return false;
-	mt = get_pageblock_migratetype(page);
-	if (mt == MIGRATE_MOVABLE || is_migrate_cma(mt))
-		return false;
 
 	pfn = page_to_pfn(page);
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-arch-remove-empty_bad_page.patch

