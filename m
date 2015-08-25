From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch added to -mm tree
Date: Tue, 25 Aug 2015 14:11:10 -0700
Message-ID: <55dcd9ee.lqFXykDiA6dBZvxy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbHYVLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 17:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix comments in zone_spanned_pages_in_node() and zone_spanned_pages_in_node()
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch

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
Subject: memory-hotplug: fix comments in zone_spanned_pages_in_node() and zone_spanned_pages_in_node()

When hot adding a node from add_memory(), we will add memblock first, so
the node is not empty.  But when called from cpu_up(), the node should be
empty.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node
+++ a/mm/page_alloc.c
@@ -5085,7 +5085,7 @@ static unsigned long __meminit zone_span
 {
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* When hotadd a new node, the node should be empty */
+	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
@@ -5152,7 +5152,7 @@ static unsigned long __meminit zone_abse
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* When hotadd a new node, the node should be empty */
+	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch

