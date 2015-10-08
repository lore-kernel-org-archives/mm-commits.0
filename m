From: akpm@linux-foundation.org
Subject: + mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch
 added to -mm tree
Date: Thu, 08 Oct 2015 15:26:38 -0700
Message-ID: <5616ed9e./rk9GjxWjaod98ke%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbbJHW0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:26:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, tangchen@cn.fujitsu.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: skip ZONE_MOVABLE if required_kernelcore is larger than totalpages
has been added to the -mm tree.  Its filename is
     mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/page_alloc.c: skip ZONE_MOVABLE if required_kernelcore is larger than totalpages

If kernelcore was not specified, or the kernelcore size is zero
(required_movablecore >= totalpages), or the kernelcore size is larger
than totalpages, there is no ZONE_MOVABLE.  We should fill the zone with
both kernel memory and movable memory.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "David Rientjes" <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-skip-if-required_kernelcore-is-larger-than-totalpages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-skip-if-required_kernelcore-is-larger-than-totalpages
+++ a/mm/page_alloc.c
@@ -5495,8 +5495,11 @@ static void __init find_zone_movable_pfn
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
-	if (!required_kernelcore)
+	/*
+	 * If kernelcore was not specified or kernelcore size is larger
+	 * than totalpages, there is no ZONE_MOVABLE.
+	 */
+	if (!required_kernelcore || required_kernelcore >= totalpages)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch
mm-skip-if-required_kernelcore-is-larger-than-totalpages.patch
kasan-use-is_aligned-in-memory_is_poisoned_8.patch

