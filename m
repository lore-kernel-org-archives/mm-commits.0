From: akpm@linux-foundation.org
Subject: +
 mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:47:51 -0800
Message-ID: <52a8f9a7.sb9bN96crp0R3ymS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3LKXrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com

Subject: + mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:47:51 -0800


The patch titled
     Subject: mm/migrate.c: fix setting of cpupid on page migration twice against normal page
has been added to the -mm tree.  Its filename is
     mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/migrate.c: fix setting of cpupid on page migration twice against normal page

7851a45cd3 ("mm: numa: Copy cpupid on page migration") copies over the
cpupid at page migration time.  it is unnecessary to set it again in
alloc_misplaced_dst_page().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page mm/migrate.c
--- a/mm/migrate.c~mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page
+++ a/mm/migrate.c
@@ -1563,8 +1563,6 @@ static struct page *alloc_misplaced_dst_
 					  __GFP_NOMEMALLOC | __GFP_NORETRY |
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
-	if (newpage)
-		page_cpupid_xchg_last(newpage, page_cpupid_last(page));
 
 	return newpage;
 }
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

