From: akpm@linux-foundation.org
Subject: [patch 037/131] mm, page_alloc: fail has_unmovable_pages
 when seeing reserved pages
Date: Wed, 15 Nov 2017 17:33:30 -0800
Message-ID: <20171116013330.1uSVrNjrB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPBdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, qiuxishi@huawei.com, torvalds@linux-foundation.org, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: fail has_unmovable_pages when seeing reserved pages

Reserved pages should be completely ignored by the core mm because they
have a special meaning for their owners.  has_unmovable_pages doesn't
check those so we rely on other tests (reference count, or PageLRU) to
fail on such pages.  Althought this happens to work it is safer to simply
check for those explicitly and do not rely on the owner of the page to
abuse those fields for special purposes.

Please note that this is more of a further fortification of the code
rahter than a fix of an existing issue.

Link: http://lkml.kernel.org/r/20171013120756.jeopthigbmm3c7bl@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages
+++ a/mm/page_alloc.c
@@ -7383,6 +7383,9 @@ bool has_unmovable_pages(struct zone *zo
 
 		page = pfn_to_page(check);
 
+		if (PageReserved(page))
+			return true;
+
 		/*
 		 * Hugepages are not in LRU lists, but they're movable.
 		 * We need not scan over tail pages bacause we don't
_
