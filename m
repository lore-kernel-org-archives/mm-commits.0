From: akpm@linux-foundation.org
Subject: + mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
 added to -mm tree
Date: Mon, 12 Aug 2013 12:41:36 -0700
Message-ID: <52093a70.kX8oZy1qXw05P3YL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3HLTlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 15:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cody@linux.vnet.ibm.com, qiuxishi@huawei.com

Subject: + mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch added to -mm tree
To: qiuxishi@huawei.com,cody@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 12:41:36 -0700


The patch titled
     Subject: mm: use zone_is_initialized() instead of if(zone->wait_table)
has been added to the -mm tree.  Its filename is
     mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch

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
Subject: mm: use zone_is_initialized() instead of if(zone->wait_table)

Use "zone_is_initialized()" instead of "if (zone->wait_table)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-use-zone_is_initialized-instead-of-ifzone-wait_table mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-zone_is_initialized-instead-of-ifzone-wait_table
+++ a/mm/memory_hotplug.c
@@ -194,7 +194,7 @@ void register_page_bootmem_info_node(str
 
 	zone = &pgdat->node_zones[0];
 	for (; zone < pgdat->node_zones + MAX_NR_ZONES - 1; zone++) {
-		if (zone->wait_table) {
+		if (zone_is_initialized(zone)) {
 			nr_pages = zone->wait_table_hash_nr_entries
 				* sizeof(wait_queue_head_t);
 			nr_pages = PAGE_ALIGN(nr_pages) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
kexec-remove-unnecessary-return.patch

