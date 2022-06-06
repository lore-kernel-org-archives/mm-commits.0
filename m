Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D61C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbiFFUb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiFFUbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B462F01E
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C11936152C
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C6CC34115;
        Mon,  6 Jun 2022 20:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654547421;
        bh=v1YrfOSPlICt6vLWulsAE1mN78FPp0x7q/jZ6H7Ykx8=;
        h=Date:To:From:Subject:From;
        b=uY+gRZIvlIDYvrmSl5Vm5a83lnQ5zCXGWcHNVF5QDnEQyjxTlLaYcZC3jhGDrFNyX
         1r9Mg/a0RA7BYkaLv/gqAD6BgBKIIc6E6Eegn/JlvY8zjwJiN6qm3VJGiDhPaq+04e
         Oub/Sw7lE6vvkGGv0qHFsx8F0o5CV9Ed8RDDDN+g=
Date:   Mon, 06 Jun 2022 13:30:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, daniel.vetter@intel.com, cl@linux.com,
        daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-might_alloc.patch added to mm-unstable branch
Message-Id: <20220606203021.20C6CC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use might_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-might_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-might_alloc.patch

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
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/page_alloc: use might_alloc()
Date: Sun, 5 Jun 2022 17:25:37 +0200

...  instead of open coding it.  Completely equivalent code, just a notch
more meaningful when reading.

Link: https://lkml.kernel.org/r/20220605152539.3196045-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-might_alloc
+++ a/mm/page_alloc.c
@@ -5270,10 +5270,7 @@ static inline bool prepare_alloc_pages(g
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

mm-page_alloc-use-might_alloc.patch
mm-slab-delete-cache_alloc_debugcheck_before.patch
mm-mempool-use-might_alloc.patch

