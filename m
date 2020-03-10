From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch added to -mm
 tree
Date: Mon, 09 Mar 2020 19:29:47 -0700
Message-ID: <20200310022947.yZNgWbkEQ%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbgCJC3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 22:29:49 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/page_alloc.c: use free_area_empty() instead of open-coding
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/page_alloc.c: use free_area_empty() instead of open-coding

Use free_area_empty() API to replace list_empty() for better code
readability.

Link: http://lkml.kernel.org/r/1583674354-7713-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-free_area_empty-instead-of-open-coding
+++ a/mm/page_alloc.c
@@ -3473,8 +3473,7 @@ bool __zone_watermark_ok(struct zone *z,
 			return true;
 		}
 #endif
-		if (alloc_harder &&
-			!list_empty(&area->free_list[MIGRATE_HIGHATOMIC]))
+		if (alloc_harder && !free_area_empty(area, MIGRATE_HIGHATOMIC))
 			return true;
 	}
 	return false;
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
mm-sparsemem-use-wrapped-macros-instead-of-open-coding.patch
mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
