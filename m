From: akpm@linux-foundation.org
Subject: [merged]
 mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:49 -0800
Message-ID: <548d0d15.u15ReFQbaIN04gep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaLNEHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: use alloc_pages_exact() rather than its own implementation
has been removed from the -mm tree.  Its filename was
     mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/nommu: use alloc_pages_exact() rather than its own implementation

do_mmap_private() in nommu.c try to allocate physically contiguous pages
with arbitrary size in some cases and we now have good abstract function
to do exactly same thing, alloc_pages_exact().  So, change to use it.

There is no functional change.  This is the preparation step for support
page owner feature accurately.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff -puN mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation mm/nommu.c
--- a/mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation
+++ a/mm/nommu.c
@@ -1149,8 +1149,7 @@ static int do_mmap_private(struct vm_are
 			   unsigned long len,
 			   unsigned long capabilities)
 {
-	struct page *pages;
-	unsigned long total, point, n;
+	unsigned long total, point;
 	void *base;
 	int ret, order;
 
@@ -1182,33 +1181,23 @@ static int do_mmap_private(struct vm_are
 	order = get_order(len);
 	kdebug("alloc order %d for %lx", order, len);
 
-	pages = alloc_pages(GFP_KERNEL, order);
-	if (!pages)
-		goto enomem;
-
 	total = 1 << order;
-	atomic_long_add(total, &mmap_pages_allocated);
-
 	point = len >> PAGE_SHIFT;
 
-	/* we allocated a power-of-2 sized page set, so we may want to trim off
-	 * the excess */
+	/* we don't want to allocate a power-of-2 sized page set */
 	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages) {
-		while (total > point) {
-			order = ilog2(total - point);
-			n = 1 << order;
-			kdebug("shave %lu/%lu @%lu", n, total - point, total);
-			atomic_long_sub(n, &mmap_pages_allocated);
-			total -= n;
-			set_page_refcounted(pages + total);
-			__free_pages(pages + total, order);
-		}
+		total = point;
+		kdebug("try to alloc exact %lu pages", total);
+		base = alloc_pages_exact(len, GFP_KERNEL);
+	} else {
+		base = (void *)__get_free_pages(GFP_KERNEL, order);
 	}
 
-	for (point = 1; point < total; point++)
-		set_page_refcounted(&pages[point]);
+	if (!base)
+		goto enomem;
+
+	atomic_long_add(total, &mmap_pages_allocated);
 
-	base = page_address(pages);
 	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 	region->vm_start = (unsigned long) base;
 	region->vm_end   = region->vm_start + len;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

