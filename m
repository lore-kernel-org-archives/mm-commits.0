From: akpm@linux-foundation.org
Subject: [merged] rmap-recompute-pgoff-for-unmapping-huge-page.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:35 -0700
Message-ID: <20130430184435.7974B5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:43085 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760836Ab3D3Sog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:36 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so84512ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, mhocko@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: recompute pgoff for unmapping huge page
has been removed from the -mm tree.  Its filename was
     rmap-recompute-pgoff-for-unmapping-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: rmap: recompute pgoff for unmapping huge page

We have to recompute pgoff if the given page is huge, since result based
on HPAGE_SIZE is not approapriate for scanning the vma interval tree, as
shown by commit 36e4f20af833 ("hugetlb: do not use vma_hugecache_offset()
for vma_prio_tree_foreach").

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/rmap.c~rmap-recompute-pgoff-for-unmapping-huge-page mm/rmap.c
--- a/mm/rmap.c~rmap-recompute-pgoff-for-unmapping-huge-page
+++ a/mm/rmap.c
@@ -1513,6 +1513,9 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
+	if (PageHuge(page))
+		pgoff = page->index << compound_order(page);
+
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch

