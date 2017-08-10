From: akpm@linux-foundation.org
Subject: [patch 17/21] mm/balloon_compaction.c: don't zero ballooned pages
Date: Thu, 10 Aug 2017 15:24:21 -0700
Message-ID: <598cdd15.eMYvcCicH8AR8Dir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdHJWYW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wei.w.wang@intel.com, david@redhat.com, mhocko@suse.com, mst@redhat.com, zhenwei.pi@youruncloud.com

From: Wei Wang <wei.w.wang@intel.com>
Subject: mm/balloon_compaction.c: don't zero ballooned pages

Revert of bb01b64cfab7 ("mm/balloon_compaction.c: enqueue zero page to
balloon device")'

Zeroing ballon pages is rather time consuming, especially when a lot of
pages are in flight. E.g. 7GB worth of ballooned memory takes 2.8s with
__GFP_ZERO while it takes ~491ms without it.

The original commit argued that zeroing will help ksmd to merge these
pages on the host but this argument is assuming that the host actually
marks balloon pages for ksm which is not universally true.  So we pay
performance penalty for something that even might not be used in the end
which is wrong.  The host can zero out pages on its own when there is a
need.

[mhocko@kernel.org: new changelog text]
Link: http://lkml.kernel.org/r/1501761557-9758-1-git-send-email-wei.w.wang@intel.com
Fixes: bb01b64cfab7 ("mm/balloon_compaction.c: enqueue zero page to balloon device")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: zhenwei.pi <zhenwei.pi@youruncloud.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/balloon_compaction.c~mm-dont-zero-ballooned-pages mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-dont-zero-ballooned-pages
+++ a/mm/balloon_compaction.c
@@ -24,7 +24,7 @@ struct page *balloon_page_enqueue(struct
 {
 	unsigned long flags;
 	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-				__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_ZERO);
+				       __GFP_NOMEMALLOC | __GFP_NORETRY);
 	if (!page)
 		return NULL;
 
_
