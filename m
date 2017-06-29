From: akpm@linux-foundation.org
Subject: + mm-balloon-enqueue-zero-page-to-balloon-device.patch added to
 -mm tree
Date: Thu, 29 Jun 2017 14:45:47 -0700
Message-ID: <5955750b.Ih1+ygwPLzQtCs/W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753799AbdF2Vps (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenwei.pi@youruncloud.com, aquini@redhat.com, gi-oh.kim@profitbricks.com, k.khlebnikov@samsung.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction.c: enqueue zero page to balloon device
has been added to the -mm tree.  Its filename is
     mm-balloon-enqueue-zero-page-to-balloon-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon-enqueue-zero-page-to-balloon-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon-enqueue-zero-page-to-balloon-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "zhenwei.pi" <zhenwei.pi@youruncloud.com>
Subject: mm/balloon_compaction.c: enqueue zero page to balloon device

presently pages in the balloon device have random value, and these pages
will be scanned by ksmd on the host.  They usually cannot be merged. 
Enqueue zero pages will resolve this problem.

Link: http://lkml.kernel.org/r/1498698637-26389-1-git-send-email-zhenwei.pi@youruncloud.com
Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/balloon_compaction.c~mm-balloon-enqueue-zero-page-to-balloon-device mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon-enqueue-zero-page-to-balloon-device
+++ a/mm/balloon_compaction.c
@@ -24,7 +24,7 @@ struct page *balloon_page_enqueue(struct
 {
 	unsigned long flags;
 	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-					__GFP_NOMEMALLOC | __GFP_NORETRY);
+					__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_ZERO);
 	if (!page)
 		return NULL;
 
_

Patches currently in -mm which might be from zhenwei.pi@youruncloud.com are

mm-balloon-enqueue-zero-page-to-balloon-device.patch

