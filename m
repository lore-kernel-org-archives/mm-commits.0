From: akpm@linux-foundation.org
Subject: + mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch added to
 -mm tree
Date: Wed, 12 Aug 2015 17:04:41 -0700
Message-ID: <55cbdf19.BblCqoHYawfYFMWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbHMAEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 20:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: mark cma_bitmap_maxno() inline in header
has been added to the -mm tree.  Its filename is
     mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-cma-mark-cma_bitmap_maxno-inline-in-header.patch
linux-next.patch

