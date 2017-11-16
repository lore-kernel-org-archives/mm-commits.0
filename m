From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:32 -0800
Message-ID: <20171116200032.YLgELsGM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934367AbdKPUAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com


The patch titled
     Subject: mm, page_alloc: fail has_unmovable_pages when seeing reserved pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: fail has_unmovable_pages when seeing reserved pages

Reserved pages should be completely ignored by the core mm because they
have a special meaning for their owners.  has_unmovable_pages doesn't
check those so we rely on other tests (reference count, or PageLRU) to
fail on such pages.  Althought this happens to work it is safer to simply
check for those explicitly and do not rely on the owner of the page to
abuse those fields for special purposes.

Please note that this is more of a further fortification of the code
rahter than a fix of an existing issue.

Link: http://lkml.kernel.org/r/20171013120756.jeopthigbmm3c7bl@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages
+++ a/mm/page_alloc.c
@@ -7383,6 +7383,9 @@ bool has_unmovable_pages(struct zone *zo
 
 		page = pfn_to_page(check);
 
+		if (PageReserved(page))
+			return true;
+
 		/*
 		 * Hugepages are not in LRU lists, but they're movable.
 		 * We need not scan over tail pages bacause we don't
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch

