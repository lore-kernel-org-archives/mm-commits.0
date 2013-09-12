From: akpm@linux-foundation.org
Subject: [merged]
 mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:39 -0700
Message-ID: <5232196b.30ncKNknAr+m7Ufo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3ILTnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, dave.hansen@linux.intel.com, qiuxishi@huawei.com

Subject: [merged] mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch removed from -mm tree
To: qiuxishi@huawei.com,dave.hansen@linux.intel.com,toshi.kani@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:39 -0700


The patch titled
     Subject: mm/hotplug: remove unnecessary BUG_ON in __offline_pages()
has been removed from the -mm tree.  Its filename was
     mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/hotplug: remove unnecessary BUG_ON in __offline_pages()

I think we can remove "BUG_ON(start_pfn >= end_pfn)" in __offline_pages(),
because in memory_block_action() "nr_pages = PAGES_PER_SECTION * sections_per_block"
is always greater than 0.

memory_block_action()
	offline_pages()
		__offline_pages()
			BUG_ON(start_pfn >= end_pfn)

In v2.6.32, If info->length==0, this way may hit this BUG_ON().
acpi_memory_disable_device()
	remove_memory(info->start_addr, info->length)
			offline_pages()

A later Fujitsu patch renamed this function and the BUG_ON() is
unnecessary.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages
+++ a/mm/memory_hotplug.c
@@ -1472,7 +1472,6 @@ static int __ref __offline_pages(unsigne
 	struct zone *zone;
 	struct memory_notify arg;
 
-	BUG_ON(start_pfn >= end_pfn);
 	/* at least, alignment against pageblock is necessary */
 	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
 		return -EINVAL;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

