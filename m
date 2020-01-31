From: akpm@linux-foundation.org
Subject: [merged]
 mm-clean-up-obsolete-check-on-space-in-page-flags.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:19:27 -0800
Message-ID: <20200131231927.fmHAJoQQP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXT2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, david@redhat.com, mm-commits@vger.kernel.org, yuzhao@google.com


The patch titled
     Subject: include/linux/mm.h: clean up obsolete check on space in page->flags
has been removed from the -mm tree.  Its filename was
     mm-clean-up-obsolete-check-on-space-in-page-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
