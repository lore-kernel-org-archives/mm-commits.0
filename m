From: akpm@linux-foundation.org
Subject: [patch 048/102] mm: remove unncessary ret in
 page_referenced
Date: Wed, 03 May 2017 14:54:00 -0700
Message-ID: <20170503215400.fBrSRB-ma%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdECVya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove unncessary ret in page_referenced

Nobody uses ret variable. Remove it.

Link: http://lkml.kernel.org/r/1489555493-14659-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-remove-unncessary-ret-in-page_referenced mm/rmap.c
--- a/mm/rmap.c~mm-remove-unncessary-ret-in-page_referenced
+++ a/mm/rmap.c
@@ -812,7 +812,6 @@ int page_referenced(struct page *page,
 		    struct mem_cgroup *memcg,
 		    unsigned long *vm_flags)
 {
-	int ret;
 	int we_locked = 0;
 	struct page_referenced_arg pra = {
 		.mapcount = total_mapcount(page),
@@ -846,7 +845,7 @@ int page_referenced(struct page *page,
 		rwc.invalid_vma = invalid_page_referenced_vma;
 	}
 
-	ret = rmap_walk(page, &rwc);
+	rmap_walk(page, &rwc);
 	*vm_flags = pra.vm_flags;
 
 	if (we_locked)
_
