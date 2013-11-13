From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:03 -0800
Message-ID: <5283e32b.EfzLbh6CTfj0plif%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3KMUiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, qiuxishi@huawei.com

Subject: [merged] mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch removed from -mm tree
To: qiuxishi@huawei.com,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:03 -0800


The patch titled
     Subject: mm/memory_hotplug.c: use pfn_to_nid() instead of page_to_nid(pfn_to_page())
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/memory_hotplug.c: use pfn_to_nid() instead of page_to_nid(pfn_to_page())

Use "pfn_to_nid(pfn)" instead of "page_to_nid(pfn_to_page(pfn))".

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page
+++ a/mm/memory_hotplug.c
@@ -934,7 +934,7 @@ int __ref online_pages(unsigned long pfn
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_online(nr_pages, zone, &arg);
 
-	nid = page_to_nid(pfn_to_page(pfn));
+	nid = pfn_to_nid(pfn);
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch
linux-next.patch

