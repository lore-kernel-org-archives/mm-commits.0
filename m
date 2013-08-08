From: akpm@linux-foundation.org
Subject: + mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
 added to -mm tree
Date: Thu, 08 Aug 2013 13:41:45 -0700
Message-ID: <52040289.hapNBcC9AZOqjvoQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966345Ab3HHUlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 16:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, dave.hansen@linux.intel.com, qiuxishi@huawei.com

Subject: + mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch added to -mm tree
To: qiuxishi@huawei.com,dave.hansen@linux.intel.com,toshi.kani@hp.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 13:41:45 -0700


The patch titled
     Subject: mm/hotplug: remove unnecessary BUG_ON in __offline_pages()
has been added to the -mm tree.  Its filename is
     mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
kexec-remove-unnecessary-return.patch

