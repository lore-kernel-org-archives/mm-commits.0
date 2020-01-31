From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 075/118] include/linux/mm.h: clean up obsolete
 check on space in page->flags
Date: Thu, 30 Jan 2020 22:15:10 -0800
Message-ID: <20200131061510.AX4sUc5J4%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGPL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:15:11 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yuzhao@google.com

From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/mm.h: clean up obsolete check on space in page->flags

The check was intended to make sure we don't overrun page flags.  But it's
obsolete because it doesn't include LAST_CPUPID_WIDTH nor KASAN_TAG_WIDTH.

Just remove check since we already have it covered in
linux/page-flags-layout.h (near the end of the file).

Link: http://lkml.kernel.org/r/20191208183508.89177-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/mm.h~mm-clean-up-obsolete-check-on-space-in-page-flags
+++ a/include/linux/mm.h
@@ -916,10 +916,6 @@ vm_fault_t finish_mkwrite_fault(struct v
 
 #define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
 
-#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
-#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
-#endif
