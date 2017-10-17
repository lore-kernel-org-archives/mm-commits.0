From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 15:26:48 -0700
Message-ID: <59e683a8.AszZxlrN6qNeKDrz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764612AbdJQW0v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mpe@ellerman.id.au, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fail has_unmovable_pages when seeing reserved pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch

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
@@ -7370,6 +7370,9 @@ bool has_unmovable_pages(struct zone *zo
 
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
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-arch-remove-empty_bad_page.patch

