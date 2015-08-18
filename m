From: akpm@linux-foundation.org
Subject: [merged] mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch
 removed from -mm tree
Date: Tue, 18 Aug 2015 12:42:37 -0700
Message-ID: <55d38aad.j2p7WXsOmzizV517%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbbHRTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: mark cma_bitmap_maxno() inline in header
has been removed from the -mm tree.  Its filename was
     mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory Fong <gregory.0xf0@gmail.com>
Subject: mm: cma: mark cma_bitmap_maxno() inline in header

cma_bitmap_maxno() was marked as static and not static inline, which can
cause warnings about this function not being used if this file is included
in a file that does not call that function, and violates the conventions
used elsewhere.  The two options are to move the function implementation
back to mm/cma.c or make it inline here, and it's simple enough for the
latter to make sense.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma.h~mm-cma-mark-cma_bitmap_maxno-inline-in-header mm/cma.h
--- a/mm/cma.h~mm-cma-mark-cma_bitmap_maxno-inline-in-header
+++ a/mm/cma.h
@@ -16,7 +16,7 @@ struct cma {
 extern struct cma cma_areas[MAX_CMA_AREAS];
 extern unsigned cma_area_count;
 
-static unsigned long cma_bitmap_maxno(struct cma *cma)
+static inline unsigned long cma_bitmap_maxno(struct cma *cma)
 {
 	return cma->count >> cma->order_per_bit;
 }
_

Patches currently in -mm which might be from gregory.0xf0@gmail.com are

linux-next.patch

