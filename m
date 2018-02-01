From: akpm@linux-foundation.org
Subject: [patch 046/119] mm/page_alloc.c: fix comment in
 __get_free_pages()
Date: Wed, 31 Jan 2018 16:16:52 -0800
Message-ID: <20180201001652.c9NQ6e6AO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBAAQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenjiankang1@huawei.com, guohanjun@huawei.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, wangkefeng.wang@huawei.com, xieyisheng1@huawei.com

From: Jiankang Chen <chenjiankang1@huawei.com>
Subject: mm/page_alloc.c: fix comment in __get_free_pages()

__get_free_pages() will return a virtual address, but it is not just a
32-bit address, for example on a 64-bit system.  And this comment really
confuses new readers of mm.

Link: http://lkml.kernel.org/r/1511780964-64864-1-git-send-email-chenjiankang1@huawei.com
Signed-off-by: Jiankang Chen <chenjiankang1@huawei.com>
Reported-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-comment-is-__get_free_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-comment-is-__get_free_pages
+++ a/mm/page_alloc.c
@@ -4278,7 +4278,7 @@ unsigned long __get_free_pages(gfp_t gfp
 	struct page *page;
 
 	/*
-	 * __get_free_pages() returns a 32-bit address, which cannot represent
+	 * __get_free_pages() returns a virtual address, which cannot represent
 	 * a highmem page
 	 */
 	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
_
