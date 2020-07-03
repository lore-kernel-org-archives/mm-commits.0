From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/5] mm/page_alloc: fix documentation error
Date: Fri, 03 Jul 2020 15:15:30 -0700
Message-ID: <20200703221530.U5dPQF8aa%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgGCWPc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 18:15:32 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, fdangelo@redhat.com, jsavitz@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

From: Joel Savitz <jsavitz@redhat.com>
Subject: mm/page_alloc: fix documentation error

When I increased the upper bound of the min_free_kbytes value in
ee8eb9a5fe863 ("mm/page_alloc: increase default min_free_kbytes bound") I
forgot to tweak the above comment to reflect the new value.  This patch
fixes that mistake.

Link: http://lkml.kernel.org/r/20200624221236.29560-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Fabrizio D'Angelo <fdangelo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-documentation-error
+++ a/mm/page_alloc.c
@@ -7832,7 +7832,7 @@ void setup_per_zone_wmarks(void)
  * Initialise min_free_kbytes.
  *
  * For small machines we want it small (128k min).  For large machines
- * we want it large (64MB max).  But it is not linear, because network
+ * we want it large (256MB max).  But it is not linear, because network
  * bandwidth does not increase linearly with machine size.  We use
  *
  *	min_free_kbytes = 4 * sqrt(lowmem_kbytes), for better accuracy:
_
