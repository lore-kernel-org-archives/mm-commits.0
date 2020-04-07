From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 071/166] mm/memory_hotplug.c: use
 __pfn_to_section() instead of open-coding
Date: Mon, 06 Apr 2020 20:07:48 -0700
Message-ID: <20200407030748.ZaB1ymPTz%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:50 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
