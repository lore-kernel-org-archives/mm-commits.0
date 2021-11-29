Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD22C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhK2Wl4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhK2WlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:41:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005EAC0E2ECA
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 13:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7881B81643
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 21:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D73C53FC7;
        Mon, 29 Nov 2021 21:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638221258;
        bh=bqw2r6tyQsZ3ZXF2kc90uMNe+2K2P4QMFIE+zBh8kls=;
        h=Date:From:To:Subject:From;
        b=sXFcqK0QiWi6x46JxqiuoU1Cf74q6dEbxtwbeyqYdgA15kGDKyB55sEA9W0pW6rmy
         jUbz4wHD99fSsZMC7J/J0zhi3mkvkAqKcDMqF3e7ld5nHYSSj0gtagCjI1z/h6Jd+C
         aA0l9FQYKACG9+elf+yd9HdIPyoXTuINRTt+Rrzo=
Date:   Mon, 29 Nov 2021 13:27:37 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, david@fromorbit.com, dchinner@redhat.com,
        hch@lst.de, idryomov@gmail.com, jlayton@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        urezki@gmail.com, vbabka@suse.cz
Subject:  +
 mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch added to
 -mm tree
Message-ID: <20211129212737.GICERW5JR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make slab and vmalloc allocators __GFP_NOLOCKDEP aware
has been added to the -mm tree.  Its filename is
     mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch

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
Subject: mm: make slab and vmalloc allocators __GFP_NOLOCKDEP aware

sl?b and vmalloc allocators reduce the given gfp mask for their internal
needs.  For that they use GFP_RECLAIM_MASK to preserve the reclaim
behavior and constrains.

__GFP_NOLOCKDEP is not a part of that mask because it doesn't really
control the reclaim behavior strictly speaking.  On the other hand it
tells the underlying page allocator to disable reclaim recursion detection
so arguably it should be part of the mask.

Having __GFP_NOLOCKDEP in the mask will not alter the behavior in any form
so this change is safe pretty much by definition.  It also adds a support
for this flag to SL?B and vmalloc allocators which will in turn allow its
use to kvmalloc as well.  A lack of the support has been noticed recently
in http://lkml.kernel.org/r/20211119225435.GZ449541@dread.disaster.area

Link: https://lkml.kernel.org/r/YZ9XtLY4AEjVuiEI@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware
+++ a/mm/internal.h
@@ -21,7 +21,7 @@
 #define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC|\
-			__GFP_ATOMIC)
+			__GFP_ATOMIC|__GFP_NOLOCKDEP)
 
 /* The GFP flags allowed during early boot */
 #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
mm-vmalloc-add-support-for-__gfp_nofail.patch
mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
mm-allow-gfp_kernel-allocations-for-kvmalloc.patch
mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch
mm-drop-node-from-alloc_pages_vma.patch

