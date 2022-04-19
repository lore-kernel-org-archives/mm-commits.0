Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC0AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiDSEZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiDSEZP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2417B1FA6C
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 21:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CC0611B6
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 04:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B7C385A5;
        Tue, 19 Apr 2022 04:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650342153;
        bh=bv3Upjwt4jtAazmUbsPY1IG49eANudZxJlC/5hlYubo=;
        h=Date:To:From:Subject:From;
        b=QA37rFstZYl+eWquhVO1/R7yuRG7SDFU35q57+L+m/dYtj8czigZQdSET+C3jLNYY
         sau581vw/zmIvk/1QTvFGQjh0y2SaLW+So9znA5bFYi+9V8rABE0TcT7czmM7sjC6h
         RZldouxa6qffY/8jGNfgygggTrv/Xte0Yj9Kk+Z4=
Date:   Mon, 18 Apr 2022 21:22:32 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        dchinner@redhat.com, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-call-add_nr_deferred-with-zero-deferred.patch added to -mm tree
Message-Id: <20220419042232.E40B7C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not call add_nr_deferred() with zero deferred
has been added to the -mm tree.  Its filename is
     mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-call-add_nr_deferred-with-zero-deferred.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: do not call add_nr_deferred() with zero deferred

add_nr_deferred() is often called with next_deferred equal to 0.
For instance, it's happening under low memory pressure for any
shrinkers with a low number of cached objects. A corresponding trace
looks like:
  <...>-619914 [005] .... 467456.345160: mm_shrink_slab_end: \
  super_cache_scan+0x0/0x1a0 0000000087027f06: nid: 1	     \
  unused scan count 0 new scan count 0 total_scan 0	     \
  last shrinker return val 0

  <...>-619914 [005] .... 467456.345371: mm_shrink_slab_end: \
  super_cache_scan+0x0/0x1a0 0000000087027f06: nid: 1	     \
  unused scan count 0 new scan count 0 total_scan 0	     \
  last shrinker return val 0

  <...>-619914 [005] .... 467456.345380: mm_shrink_slab_end: \
  super_cache_scan+0x0/0x1a0 0000000087027f06: nid: 1 unused \
  scan count 0 new scan count 0 total_scan 0	             \
  last shrinker return val 0

This lead to unnecessary checks and atomic operations, which can be
avoided by checking next_deferred for not being zero before calling
add_nr_deferred().  In this case the mm_shrink_slab_end trace point will
get a potentially slightly outdated "new scan count" value, but it's
totally fine.

Link: https://lkml.kernel.org/r/20220416004104.4089743-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-do-not-call-add_nr_deferred-with-zero-deferred
+++ a/mm/vmscan.c
@@ -808,7 +808,10 @@ static unsigned long do_shrink_slab(stru
 	 * move the unused scan count back into the shrinker in a
 	 * manner that handles concurrent updates.
 	 */
-	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
+	if (next_deferred)
+		new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
+	else
+		new_nr = nr;
 
 	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
 	return freed;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

