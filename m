From: akpm@linux-foundation.org
Subject: [merged]
 mm-init-report-kasan-tag-information-stored-in-page-flags.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:43:21 -0700
Message-ID: <20200602214321.QPX4Segh4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, chunyan.zhang@unisoc.com, dvyukov@google.com, glider@google.com, jing.xia@unisoc.com, mm-commits@vger.kernel.org, orson.zhai@unisoc.com


The patch titled
     Subject: mm/mm_init.c: report kasan-tag information stored in page->flags
has been removed from the -mm tree.  Its filename was
     mm-init-report-kasan-tag-information-stored-in-page-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jing Xia <jing.xia@unisoc.com>
Subject: mm/mm_init.c: report kasan-tag information stored in page->flags

The pageflags_layout_usage shows incorrect message by means of
mminit_loglevel when Kasan runs in the mode of software tag-based enabled
with CONFIG_KASAN_SW_TAGS.  This patch corrects it and reports kasan-tag
information.

Link: http://lkml.kernel.org/r/1586929370-10838-1-git-send-email-jing.xia.mail@gmail.com
Signed-off-by: Jing Xia <jing.xia@unisoc.com>
Cc: Chunyan Zhang <chunyan.zhang@unisoc.com>
Cc: Orson Zhai <orson.zhai@unisoc.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-init-report-kasan-tag-information-stored-in-page-flags
+++ a/mm/mm_init.c
@@ -67,26 +67,30 @@ void __init mminit_verify_pageflags_layo
 	unsigned long or_mask, add_mask;
 
 	shift = 8 * sizeof(unsigned long);
-	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_CPUPID_SHIFT;
+	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH
+		- LAST_CPUPID_SHIFT - KASAN_TAG_WIDTH;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
-		"Section %d Node %d Zone %d Lastcpupid %d Flags %d\n",
+		"Section %d Node %d Zone %d Lastcpupid %d Kasantag %d Flags %d\n",
 		SECTIONS_WIDTH,
 		NODES_WIDTH,
 		ZONES_WIDTH,
 		LAST_CPUPID_WIDTH,
+		KASAN_TAG_WIDTH,
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
-		"Section %d Node %d Zone %d Lastcpupid %d\n",
+		"Section %d Node %d Zone %d Lastcpupid %d Kasantag %d\n",
 		SECTIONS_SHIFT,
 		NODES_SHIFT,
 		ZONES_SHIFT,
-		LAST_CPUPID_SHIFT);
+		LAST_CPUPID_SHIFT,
+		KASAN_TAG_WIDTH);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_pgshifts",
-		"Section %lu Node %lu Zone %lu Lastcpupid %lu\n",
+		"Section %lu Node %lu Zone %lu Lastcpupid %lu Kasantag %lu\n",
 		(unsigned long)SECTIONS_PGSHIFT,
 		(unsigned long)NODES_PGSHIFT,
 		(unsigned long)ZONES_PGSHIFT,
-		(unsigned long)LAST_CPUPID_PGSHIFT);
+		(unsigned long)LAST_CPUPID_PGSHIFT,
+		(unsigned long)KASAN_TAG_PGSHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodezoneid",
 		"Node/Zone ID: %lu -> %lu\n",
 		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT),
_

Patches currently in -mm which might be from jing.xia@unisoc.com are
