From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-comment-is-__get_free_pages.patch added to
 -mm tree
Date: Mon, 27 Nov 2017 15:32:05 -0800
Message-ID: <5a1ca075.kzuGcdE3bHa7nGG0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753324AbdK0XcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenjiankang1@huawei.com, guohanjun@huawei.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, wangkefeng.wang@huawei.com, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix comment in __get_free_pages()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-comment-is-__get_free_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-comment-is-__get_free_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-comment-is-__get_free_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -4267,7 +4267,7 @@ unsigned long __get_free_pages(gfp_t gfp
 	struct page *page;
 
 	/*
-	 * __get_free_pages() returns a 32-bit address, which cannot represent
+	 * __get_free_pages() returns a virtual address, which cannot represent
 	 * a highmem page
 	 */
 	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
_

Patches currently in -mm which might be from chenjiankang1@huawei.com are

mm-page_alloc-fix-comment-is-__get_free_pages.patch

