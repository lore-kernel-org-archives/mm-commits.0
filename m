Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D45CCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379829AbiFQCto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379809AbiFQCtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCFF65419
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5305A61D26
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA32EC3411A;
        Fri, 17 Jun 2022 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434169;
        bh=KpXYlJRXBmE4rQVeYvLgZuOVH8Ae98A3i+x6Bdj+YkI=;
        h=Date:To:From:Subject:From;
        b=CDy0LIRYVbAfiyQ2L6yHdor1YS2K94iFrvhrnfEijuS+2QM/0F4LcXWh9+CFyG7u1
         8olVJZ31opsgBaRiv+eQGpOcISlQXo1BprbL/V9DUjrIbgf51FZkj9OYejlECGdMjd
         kJrmheEJHJvML5a8p1VhBzXixd+ZdRheV+OyW48Y=
Date:   Thu, 16 Jun 2022 19:49:29 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, daniel.vetter@intel.com, cl@linux.com,
        daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempool-use-might_alloc.patch removed from -mm tree
Message-Id: <20220617024929.AA32EC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempool: use might_alloc()
has been removed from the -mm tree.  Its filename was
     mm-mempool-use-might_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/mempool: use might_alloc()
Date: Sun, 5 Jun 2022 17:25:39 +0200

mempool are generally used for GFP_NOIO, so this wont benefit all that
much because might_alloc currently only checks GFP_NOFS.  But it does
validate against mmu notifier pte zapping, some might catch some drivers
doing really silly things, plus it's a bit more meaningful in what we're
checking for here.

Link: https://lkml.kernel.org/r/20220605152539.3196045-3-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mm-mempool-use-might_alloc
+++ a/mm/mempool.c
@@ -379,7 +379,7 @@ void *mempool_alloc(mempool_t *pool, gfp
 	gfp_t gfp_temp;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
-	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
+	might_alloc(gfp_mask);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


