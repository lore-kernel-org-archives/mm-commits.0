From: akpm@linux-foundation.org
Subject: [merged] mm-make-vb_alloc-more-foolproof.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:27 -0700
Message-ID: <20120801201127.AA5AC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAUL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:28 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make vb_alloc() more foolproof
has been removed from the -mm tree.  Its filename was
     mm-make-vb_alloc-more-foolproof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: make vb_alloc() more foolproof

If someone calls vb_alloc() (or vm_map_ram() for that matter) to allocate
0 bytes (0 pages), get_order() returns BITS_PER_LONG - PAGE_CACHE_SHIFT
and interesting stuff happens.  So make debugging such problems easier and
warn about 0-size allocation.

[akpm@linux-foundation.org: use WARN_ON-return-value feature]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmalloc.c~mm-make-vb_alloc-more-foolproof mm/vmalloc.c
--- a/mm/vmalloc.c~mm-make-vb_alloc-more-foolproof
+++ a/mm/vmalloc.c
@@ -904,6 +904,14 @@ static void *vb_alloc(unsigned long size
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
+	if (WARN_ON(size == 0)) {
+		/*
+		 * Allocating 0 bytes isn't what caller wants since
+		 * get_order(0) returns funny result. Just warn and terminate
+		 * early.
+		 */
+		return NULL;
+	}
 	order = get_order(size);
 
 again:
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch

