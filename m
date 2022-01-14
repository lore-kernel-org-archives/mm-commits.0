Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10545C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiANWHN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWHN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11623C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7EF61FE2
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBD8C36AED;
        Fri, 14 Jan 2022 22:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198032;
        bh=GQEP01sTsyUivJvV23Ywfkcnu0Wj9586sffJkfCEypg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=suHldoq+aVi67LkoPuPNMGgo+CsjKGB1bjP3Y2BytubngNtVwrJA4nylCPdGeZuAO
         EVNRTEmv7bSEodCIXArl/0fD8iCQzt8wtE5/oI+MMK3Kh/COSD11fDAYg9iEOXmqxj
         hBC/PePUcjIriTnQAJgXag9Z8pC1iWJsPs9daPnE=
Date:   Fri, 14 Jan 2022 14:07:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        david@fromorbit.com, dchinner@redhat.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz
Subject:  [patch 077/146] mm: make slab and vmalloc allocators
 __GFP_NOLOCKDEP aware
Message-ID: <20220114220711.IJjDTpdMu%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
