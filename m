Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13AFC04A6A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 17:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjHCRnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 13:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjHCRni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 13:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949B410D2
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 10:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273E061E56
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 17:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8E1C433C7;
        Thu,  3 Aug 2023 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691084616;
        bh=Uc37SDsoNUPPbTnNb980YUVXoqu+oxjrg9rhbvH+zNY=;
        h=Date:To:From:Subject:From;
        b=mjvosYPkORvH+00k9K3SXoYQgqXP67lVYzIqpYtAE2RdCKz5bqfmRtqsku6LbGHeA
         BmZM0WlRuetcCmoD4S5Y6JQBbJz4yO9LRikUYwdtXDiifarwlOSAmO8KgtHB+BDEwm
         SCnKZ2rJ68RlKHw5dxTOV3Z35r9bP7Fzh5fN1avk=
Date:   Thu, 03 Aug 2023 10:43:35 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch added to mm-unstable branch
Message-Id: <20230803174336.7D8E1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: merge end_pfn boundary check in isolate_freepages_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: merge end_pfn boundary check in isolate_freepages_range
Date: Thu, 3 Aug 2023 17:48:59 +0800

Merge the end_pfn boundary check for single page block forward and
multiple page blocks forward to avoid do twice boundary check for multiple
page blocks forward.

Link: https://lkml.kernel.org/r/20230803094901.2915942-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range
+++ a/mm/compaction.c
@@ -735,8 +735,6 @@ isolate_freepages_range(struct compact_c
 		/* Protect pfn from changing by isolate_freepages_block */
 		unsigned long isolate_start_pfn = pfn;
 
-		block_end_pfn = min(block_end_pfn, end_pfn);
-
 		/*
 		 * pfn could pass the block_end_pfn if isolated freepage
 		 * is more than pageblock order. In this case, we adjust
@@ -745,9 +743,10 @@ isolate_freepages_range(struct compact_c
 		if (pfn >= block_end_pfn) {
 			block_start_pfn = pageblock_start_pfn(pfn);
 			block_end_pfn = pageblock_end_pfn(pfn);
-			block_end_pfn = min(block_end_pfn, end_pfn);
 		}
 
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
 		if (!pageblock_pfn_to_page(block_start_pfn,
 					block_end_pfn, cc->zone))
 			break;
_

Patches currently in -mm which might be from shikemeng@huawei.com are

mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch
mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch
mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

