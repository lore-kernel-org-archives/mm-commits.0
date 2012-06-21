From: akpm@linux-foundation.org
Subject: [merged] mm-fix-slab-page-_count-corruption-when-using-slub.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:06 -0700
Message-ID: <20120621192507.DB1F5A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:32812 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2FUTZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:09 -0400
Received: by ghbz15 with SMTP id z15so96393ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pshelar@nicira.com, aarcange@redhat.com, abhide@nicira.com, cl@linux.com, penberg@cs.helsinki.fi, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix slab->page _count corruption when using slub
has been removed from the -mm tree.  Its filename was
     mm-fix-slab-page-_count-corruption-when-using-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pravin B Shelar <pshelar@nicira.com>
Subject: mm: fix slab->page _count corruption when using slub

On arches that do not support this_cpu_cmpxchg_double() slab_lock is used
to do atomic cmpxchg() on double word which contains page->_count.  The
page count can be changed from get_page() or put_page() without taking
slab_lock.  That corrupts page counter.

Fix it by moving page->_count out of cmpxchg_double data.  So that slub
does no change it while updating slub meta-data in struct page.

[akpm@linux-foundation.org: use standard comment layout, tweak comment text]
Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub
+++ a/include/linux/mm_types.h
@@ -57,8 +57,18 @@ struct page {
 		};
 
 		union {
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
+#else
+			/*
+			 * Keep _count separate from slub cmpxchg_double data.
+			 * As the rest of the double word is protected by
+			 * slab_lock but _count is not.
+			 */
+			unsigned counters;
+#endif
 
 			struct {
 
_

Patches currently in -mm which might be from pshelar@nicira.com are

origin.patch

