Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27DDC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbjHKXNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbjHKXNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A0044B0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A166666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F9AC433C8;
        Fri, 11 Aug 2023 23:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794943;
        bh=hJrIXbx1JrVuJaUxDyOqJDwuM3mswGZ9fzu+yYxuNN4=;
        h=Date:To:From:Subject:From;
        b=QAquryr9ZfBPdQiN0YhEq3wc27oLey2W4GXMghjVwseB7rhhe4uSDL7olBcmFhjI0
         siCbVNgyQ39LZ+01pWgv6O18LLjtrmKdK3TiCu4NjEDOAtpGgoQ9syoB54kx71+4bo
         i8WwH1yHnr8ptq1Mhc3trOD2UQKUXY2D9uQb6hrY=
Date:   Fri, 11 Aug 2023 16:02:23 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch removed from -mm tree
Message-Id: <20230811230223.B0F9AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correct comment of candidate pfn in fast_isolate_freepages
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: correct comment of candidate pfn in fast_isolate_freepages
Date: Fri, 21 Jul 2023 23:09:56 +0800

Patch series "Two minor cleanups for compaction", v2.

This series contains two random cleanups for compaction.


This patch (of 2):

If no preferred one was not found, we will use candidate page with maximum
pfn > min_pfn which is saved in high_pfn.  Correct "minimum" to "maximum
candidate" in comment.

Link: https://lkml.kernel.org/r/20230721150957.2058634-1-shikemeng@huawei.com
Link: https://lkml.kernel.org/r/20230721150957.2058634-2-shikemeng@huawei.com
Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages
+++ a/mm/compaction.c
@@ -1554,7 +1554,7 @@ static void fast_isolate_freepages(struc
 				break;
 		}
 
-		/* Use a minimum pfn if a preferred one was not found */
+		/* Use a maximum candidate pfn if a preferred one was not found */
 		if (!page && high_pfn) {
 			page = pfn_to_page(high_pfn);
 
_

Patches currently in -mm which might be from shikemeng@huawei.com are

mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

