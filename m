Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541BDCCA482
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiFFUbg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiFFUbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C212D2A
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46120B81B41
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F3FC3411D;
        Mon,  6 Jun 2022 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654547425;
        bh=seJpJdndtVLGj1Uwpe0IvvaOMDwrJEW5XKUEmlwCc7g=;
        h=Date:To:From:Subject:From;
        b=NUZFO4vmXIfuAXnoGCUW+xhlXFM3TevcSgk14zHafDLoHkyO2Nc1yTtf9bRPiaq5G
         bcfMpGuqsdqqac3TNICcVpjfK7YIUYmnv1MfMYFuMMQXKmEVzJ74DX4ltfECZyxHWZ
         Xn6pN+MxvpNCCa+K2HYWRiVUrciG+woQT+n0YAQ8=
Date:   Mon, 06 Jun 2022 13:30:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, daniel.vetter@intel.com, cl@linux.com,
        daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempool-use-might_alloc.patch added to mm-unstable branch
Message-Id: <20220606203024.D8F3FC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: use might_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempool-use-might_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempool-use-might_alloc.patch

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
Subject: mm/mempool: use might_alloc()
Date: Sun, 5 Jun 2022 17:25:39 +0200

mempool are generally used for GFP_NOIO, so this wont benefit all that
much because might_alloc currently only checks GFP_NOFS.  But it does
validate against mmu notifier pte zapping, some might catch some drivers
doing really silly things, plus it's a bit more meaningful in what we're
checking for here.

Link: https://lkml.kernel.org/r/20220605152539.3196045-3-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-page_alloc-use-might_alloc.patch
mm-slab-delete-cache_alloc_debugcheck_before.patch
mm-mempool-use-might_alloc.patch

