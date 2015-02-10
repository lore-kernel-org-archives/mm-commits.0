From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dont-use-compound_head-in-virt_to_head_page-v3.patch removed from -mm
 tree
Date: Tue, 10 Feb 2015 14:01:16 -0800
Message-ID: <54da7fac.t3nw4sZ+tQfF9/Y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbBJWBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 17:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't use compound_head() in virt_to_head_page()
has been removed from the -mm tree.  Its filename was
     mm-dont-use-compound_head-in-virt_to_head_page-v3.patch

This patch was dropped because it was folded into mm-dont-use-compound_head-in-virt_to_head_page.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: don't use compound_head() in virt_to_head_page()

Change from v2: Add some code comments

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN include/linux/mm.h~mm-dont-use-compound_head-in-virt_to_head_page-v3 include/linux/mm.h
--- a/include/linux/mm.h~mm-dont-use-compound_head-in-virt_to_head_page-v3
+++ a/include/linux/mm.h
@@ -446,6 +446,12 @@ static inline struct page *compound_head
 	return tail;
 }
 
+/*
+ * Since either compound page could be dismantled asynchronously in THP
+ * or we access asynchronously arbitrary positioned struct page, there
+ * would be tail flag race. To handle this race, we should call
+ * smp_rmb() before checking tail flag. compound_head_by_tail() did it.
+ */
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -453,6 +459,11 @@ static inline struct page *compound_head
 	return page;
 }
 
+/*
+ * If we access compound page synchronously such as access to
+ * allocated page, there is no need to handle tail flag race, so we can
+ * check tail flag directly without any synchronization primitive.
+ */
 static inline struct page *compound_head_fast(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -539,6 +550,12 @@ static inline struct page *virt_to_head_
 {
 	struct page *page = virt_to_page(x);
 
+	/*
+	 * We don't need to worry about synchronization of tail flag
+	 * when we call virt_to_head_page() since it is only called for
+	 * already allocated page and this page won't be freed until
+	 * this virt_to_head_page() is finished. So use _fast variant.
+	 */
 	return compound_head_fast(page);
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-slab_common-use-kmem_cache_free.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch

