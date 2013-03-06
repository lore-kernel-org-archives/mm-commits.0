From: akpm@linux-foundation.org
Subject: + rmap-recompute-pgoff-for-unmapping-huge-page.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:23:07 -0800
Message-ID: <20130306222307.729D531C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36567 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3CFWXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:23:09 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so924994vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:23:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, mhocko@suse.cz, walken@google.com


The patch titled
     From: Hillf Danton <dhillf@gmail.com>
has been added to the -mm tree.  Its filename is
     rmap-recompute-pgoff-for-unmapping-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mempolicyc-fix-wrong-sp_node-insertion.patch
mm-mempolicyc-fix-sp_node_init-argument-ordering.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch

