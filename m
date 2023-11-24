Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED75C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 18:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjKXSlT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 13:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjKXSlR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 13:41:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9D219D
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 10:41:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A836C433C7;
        Fri, 24 Nov 2023 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700851283;
        bh=I0+GZPq51f5+DNRNNVQe6fm+LyvWGr2AO5mpxoPGtLQ=;
        h=Date:To:From:Subject:From;
        b=xbsgGbBFZqkhvTAZ9YA3RZQT8/jeAxYdBtJ6TCfwHDGXIrCAA/q2AZKnCuuUQBIVe
         N7w8sy1KLDJWAIhHiuQrOD9O92UqUAPzDg8LLyqdE2AHYmUHWrzX0RpS9lLQ+VsRy8
         au/NQES3+BIvCtcXSfuzWCvEuBkrvShb3m3KgjBA=
Date:   Fri, 24 Nov 2023 10:41:22 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch added to mm-unstable branch
Message-Id: <20231124184123.1A836C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: enforce minimum zone size to do high atomic reserves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch

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
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: page_alloc: enforce minimum zone size to do high atomic reserves
Date: Fri, 24 Nov 2023 16:35:53 +0530

Highatomic reserves are set to roughly 1% of zone for maximum and a
pageblock size for minimum.  Encountered a system with the below
configuration:
Normal free:7728kB boost:0kB min:804kB low:1004kB high:1204kB
reserved_highatomic:8192KB managed:49224kB

On such systems, even a single pageblock makes highatomic reserves are set
to ~8% of the zone memory.  This high value can easily exert pressure on
the zone.

Per discussion with Michal and Mel, it is not much useful to reserve the
memory for highatomic allocations on such small systems[1].  Since the
minimum size for high atomic reserves is always going to be a pageblock
size and if 1% of zone managed pages is going to be below pageblock size,
don't reserve memory for high atomic allocations.  Thanks Michal for this
suggestion[2].

Since no memory is being reserved for high atomic allocations and if
respective allocation failures are seen, this patch can be reverted.

[1] https://lore.kernel.org/linux-mm/20231117161956.d3yjdxhhm4rhl7h2@techsingularity.net/
[2] https://lore.kernel.org/linux-mm/ZVYRJMUitykepLRy@tiehlicka/

Link: https://lkml.kernel.org/r/c3a2a48e2cfe08176a80eaf01c110deb9e918055.1700821416.git.quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves
+++ a/mm/page_alloc.c
@@ -1881,9 +1881,12 @@ static void reserve_highatomic_pageblock
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
-	 * roughly 1% of a zone.
+	 * roughly 1% of a zone. But if 1% of a zone falls below a
+	 * pageblock size, then don't reserve any pageblocks.
 	 * Check is race-prone but harmless.
 	 */
+	if ((zone_managed_pages(zone) / 100) < pageblock_nr_pages)
+		return;
 	max_managed = ALIGN((zone_managed_pages(zone) / 100), pageblock_nr_pages);
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch
mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch
mm-page_alloc-correct-high-atomic-reserve-calculations.patch
mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch

