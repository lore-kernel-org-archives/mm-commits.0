From: akpm@linux-foundation.org
Subject: [merged]
 mm-balloon-enqueue-zero-page-to-balloon-device.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:24:51 -0700
Message-ID: <20170711192451.Kqn8srmmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933703AbdGKTYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, gi-oh.kim@profitbricks.com, khlebnikov@yandex-team.ru, minchan@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz, zhenwei.pi@youruncloud.com


The patch titled
     Subject: mm/balloon_compaction.c: enqueue zero page to balloon device
has been removed from the -mm tree.  Its filename was
     mm-balloon-enqueue-zero-page-to-balloon-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhenwei.pi" <zhenwei.pi@youruncloud.com>
Subject: mm/balloon_compaction.c: enqueue zero page to balloon device

presently pages in the balloon device have random value, and these pages
will be scanned by ksmd on the host.  They usually cannot be merged. 
Enqueue zero pages will resolve this problem.

Link: http://lkml.kernel.org/r/1498698637-26389-1-git-send-email-zhenwei.pi@youruncloud.com
Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/balloon_compaction.c~mm-balloon-enqueue-zero-page-to-balloon-device mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon-enqueue-zero-page-to-balloon-device
+++ a/mm/balloon_compaction.c
@@ -24,7 +24,7 @@ struct page *balloon_page_enqueue(struct
 {
 	unsigned long flags;
 	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-					__GFP_NOMEMALLOC | __GFP_NORETRY);
+				__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_ZERO);
 	if (!page)
 		return NULL;
 
_

Patches currently in -mm which might be from zhenwei.pi@youruncloud.com are


