From: akpm@linux-foundation.org
Subject: +
 memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch added
 to -mm tree
Date: Wed, 19 Aug 2015 16:52:34 -0700
Message-ID: <55d516c2.mHWAqFCiTVnTInPS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbHSXwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Aug 2015 19:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuchangcheng@inspur.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory hot-add: memory can not been added to movable zone
has been added to the -mm tree.  Its filename is
     memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changsheng Liu <liuchangcheng@inspur.com>
Subject: mm: memory hot-add: memory can not been added to movable zone

When memory is hot added, should_add_memory_movable() always returns 0
because the movable zone is empty, so the memory that was hot added will
add to the normal zone even if we want to remove the memory.

So we change should_add_memory_movable(): if the user config
CONFIG_MOVABLE_NODE it will return 1 when the movable zone is empty.

Signed-off-by: Changsheng Liu <liuchangcheng@inspur.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone
+++ a/mm/memory_hotplug.c
@@ -1181,9 +1181,13 @@ static int should_add_memory_movable(int
 	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
 
-	if (zone_is_empty(movable_zone))
+	if (zone_is_empty(movable_zone)) {
+	#ifdef CONFIG_MOVABLE_NODE
+		return 1;
+	#else
 		return 0;
