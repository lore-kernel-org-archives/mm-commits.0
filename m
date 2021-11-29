Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA855C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhK2Wl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhK2WlJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:41:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036AFC0E2EC9
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 13:27:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A4D2CE16C0
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 21:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8B3C53FC7;
        Mon, 29 Nov 2021 21:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638221252;
        bh=I4u2Xf/c0Ktc5KoZs8FHnVCkZ3Ouz6EKiWX1Dtv1Syc=;
        h=Date:From:To:Subject:From;
        b=f455UzqHDhdTLxIrySLsA9zTEF0jinTxh50GBjsMMXou6SWO+ffXegI1pqhm2bZs+
         NZZ8dKKS3VQzLm401a2HRTsD+1lne1GoV7jigal3aXEB1pf1tOpqoNsxwecnIOj7od
         kDyOauvFcETCNOfjhCNeeGeHcVyryvnJMQmWSW8Q=
Date:   Mon, 29 Nov 2021 13:27:31 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, david@fromorbit.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, urezki@gmail.com,
        vbabka@suse.cz
Subject:  +
 mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch added to -mm
 tree
Message-ID: <20211129212731.esTDx2l-z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: be more explicit about supported gfp flags.
has been added to the -mm tree.  Its filename is
     mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/vmalloc: be more explicit about supported gfp flags.

b7d90e7a5ea8 ("mm/vmalloc: be more explicit about supported gfp flags")
has been merged prematurely without the rest of the series and without
addressed review feedback from Neil.  Fix that up now.  Only wording is
changed slightly.

Link: https://lkml.kernel.org/r/20211122153233.9924-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-be-more-explicit-about-supported-gfp-flags
+++ a/mm/vmalloc.c
@@ -3021,12 +3021,14 @@ fail:
  *
  * Allocate enough pages to cover @size from the page level
  * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL would be a preferred allocation mode
- * but GFP_NOFS and GFP_NOIO are supported as well. Zone modifiers are not
- * supported. From the reclaim modifiers__GFP_DIRECT_RECLAIM is required (aka
- * GFP_NOWAIT is not supported) and only __GFP_NOFAIL is supported (aka
- * __GFP_NORETRY and __GFP_RETRY_MAYFAIL are not supported).
- * __GFP_NOWARN can be used to suppress error messages about failures.
+ * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
+ * supported.
+ * Zone modifiers are not supported. From the reclaim modifiers
+ * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
+ * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
+ * __GFP_RETRY_MAYFAIL are not supported).
+ *
+ * __GFP_NOWARN can be used to suppress failures messages.
  *
  * Map them into contiguous kernel virtual space, using a pagetable
  * protection of @prot.
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
mm-vmalloc-add-support-for-__gfp_nofail.patch
mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
mm-allow-gfp_kernel-allocations-for-kvmalloc.patch
mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch
mm-drop-node-from-alloc_pages_vma.patch

