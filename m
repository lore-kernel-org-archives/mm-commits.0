From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-a-terrible-misleading-comment.patch added to
 -mm tree
Date: Mon, 24 Aug 2015 14:31:28 -0700
Message-ID: <55db8d30.jskH2Zvryn3rURTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbHXVb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 17:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix a misleading comment
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-a-terrible-misleading-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-a-terrible-misleading-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-a-terrible-misleading-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc.c: fix a misleading comment

The comment says that the per-cpu batchsize and zone watermarks are
determined by present_pages which is definitely wrong, they are both
calculated from managed_pages.  Fix it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-a-terrible-misleading-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-a-terrible-misleading-comment
+++ a/mm/page_alloc.c
@@ -6022,7 +6022,7 @@ void __init mem_init_print_info(const ch
  * set_dma_reserve - set the specified number of pages reserved in the first zone
  * @new_dma_reserve: The number of pages to mark reserved
  *
- * The per-cpu batchsize and zone watermarks are determined by present_pages.
+ * The per-cpu batchsize and zone watermarks are determined by managed_pages.
  * In the DMA zone, a significant percentage may be consumed by kernel image
  * and other unfreeable allocations which can skew the watermarks badly. This
  * function may optionally be used to account for unfreeable pages in the
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-page_alloc-fix-a-terrible-misleading-comment.patch

