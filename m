From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch added
 to -mm tree
Date: Fri, 20 Mar 2020 20:05:33 -0700
Message-ID: <20200321030533.-dvg5T3wh%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgCUDFe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 23:05:34 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: use __pfn_to_section() instead of open-coding
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch

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
Subject: mm/memory_hotplug.c: use __pfn_to_section() instead of open-coding

Use __pfn_to_section() API instead of open-coding for better code
readability.

Link: http://lkml.kernel.org/r/1584345134-16671-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding
+++ a/mm/memory_hotplug.c
@@ -495,7 +495,7 @@ static void __remove_section(unsigned lo
 			     unsigned long map_offset,
 			     struct vmem_altmap *altmap)
 {
-	struct mem_section *ms = __nr_to_section(pfn_to_section_nr(pfn));
+	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch
mm-page_alloc-simplify-page_is_buddy-for-better-code-readability.patch
mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
