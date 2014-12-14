From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-remove-redundant-call-of-page_to_pfn.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:07:27 -0800
Message-ID: <548d0cff.+rVxDjwHjXgtJuPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaLNEHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, dave@sr71.net, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, wangnan0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove redundant call of page_to_pfn
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-redundant-call-of-page_to_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: memory-hotplug: remove redundant call of page_to_pfn

This is just a small optimization.  The start_pfn can be obtained directly
by phys_index << PFN_SECTION_SHIFT.  So the call of page_to_pfn() is
redundant and remove it.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-remove-redundant-call-of-page_to_pfn drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-remove-redundant-call-of-page_to_pfn
+++ a/drivers/base/memory.c
@@ -228,8 +228,8 @@ memory_block_action(unsigned long phys_i
 	struct page *first_page;
 	int ret;
 
-	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
-	start_pfn = page_to_pfn(first_page);
+	start_pfn = phys_index << PFN_SECTION_SHIFT;
+	first_page = pfn_to_page(start_pfn);
 
 	switch (action) {
 		case MEM_ONLINE:
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

origin.patch

