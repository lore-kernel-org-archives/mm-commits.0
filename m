Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2CDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiDVW3i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiDVW2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:28:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD21E2B21A2
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 566A1B83296
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C209C385B4;
        Fri, 22 Apr 2022 21:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650662597;
        bh=TFnMBJep0ClVWI6tlOhWP6plalQSw7x0v0aTs5qjTRg=;
        h=Date:To:From:Subject:From;
        b=Q8+4x6+WKlbDGOKuydSRPcG9NqZtwuevFUyJIhFxZJuVScj+oMEssuVIZH3oCUzgu
         yHrpoh3hQczpQwKRaa90liSXiUblMDboUNqCyMLWIjJs6RdQrW5WuItuN0bytASnyL
         58Xn5vG0KTiugh8J/iWSBPjJ+Z7D/9aKARmUFrNw=
Date:   Fri, 22 Apr 2022 14:23:16 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        dchinner@redhat.com, david@redhat.com, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-do-not-call-add_nr_deferred-with-zero-deferred.patch removed from -mm tree
Message-Id: <20220422212317.0C209C385B4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not call add_nr_deferred() with zero deferred
has been removed from the -mm tree.  Its filename was
     mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

This patch was dropped because it was withdrawn

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
Acked-by: David Hildenbrand <david@redhat.com>
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
@@ -797,7 +797,10 @@ static unsigned long do_shrink_slab(stru
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

kselftests-memcg-update-the-oom-group-leaf-events-test.patch
kselftests-memcg-speed-up-the-memoryhigh-test.patch
maintainers-add-corresponding-kselftests-to-cgroup-entry.patch
maintainers-add-corresponding-kselftests-to-memcg-entry.patch

