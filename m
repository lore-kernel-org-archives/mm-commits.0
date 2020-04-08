From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:59:23 -0700
Message-ID: <20200408015923.ofOOZK8Ao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: use __pfn_to_section() instead of open-coding
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
