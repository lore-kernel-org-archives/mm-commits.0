Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4BEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379804AbiFQCtn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379806AbiFQCta (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1165418
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBEA4B825FA
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E498C3411A;
        Fri, 17 Jun 2022 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434167;
        bh=+371EeRtFvFZl/YOTQUamMiWcW/Xp1o1qljdc5pXo8M=;
        h=Date:To:From:Subject:From;
        b=lUAeJrhOKZCwjkmX3RjawZ/h+gEEy5kFA4xbqm1TWFhXZOl6/5dUghJxhlQQxIkca
         XmSHLdk9zAxLfAoLWyvKz0Wlpq3iDDsKBUhfdjoewrGj0/bwKMz0Fq5j2wQI49Xb/V
         SrfB79BgwtiwBZUVfSq6wO8Xys8vzi5YO2TO3kO4=
Date:   Thu, 16 Jun 2022 19:49:26 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, david@redhat.com, daniel.vetter@intel.com,
        cl@linux.com, daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-might_alloc.patch removed from -mm tree
Message-Id: <20220617024927.7E498C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use might_alloc()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-might_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/page_alloc: use might_alloc()
Date: Sun, 5 Jun 2022 17:25:37 +0200

...  instead of open coding it.  Completely equivalent code, just a notch
more meaningful when reading.

Link: https://lkml.kernel.org/r/20220605152539.3196045-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-might_alloc
+++ a/mm/page_alloc.c
@@ -5197,10 +5197,7 @@ static inline bool prepare_alloc_pages(g
 			*alloc_flags |= ALLOC_CPUSET;
 	}
 
-	fs_reclaim_acquire(gfp_mask);
-	fs_reclaim_release(gfp_mask);
-
-	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
+	might_alloc(gfp_mask);
 
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


