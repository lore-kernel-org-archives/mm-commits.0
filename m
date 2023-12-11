Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DA5CBB
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1bzvNNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A060C433C7;
	Mon, 11 Dec 2023 00:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256124;
	bh=eubUSwUrXSMooTNGKrzyX0TVX5GRQrgFl6MBiVhmXAY=;
	h=Date:To:From:Subject:From;
	b=O1bzvNNoAAjN6uq8YHes53N90fX66hnnFTPqT267WQ/AtFGn9e4wUqE6/Rv6gCx63
	 DPrfdF+GCPHxb9Q3EZK8Np+lnaP/n80QQd4+l3/opWWh7ZYJyfYxlyFwTkbfS0sCDY
	 k7DlDjzoNGTr2/rpkY6631lZnHDsjyBIYwyQD3S4=
Date: Sun, 10 Dec 2023 16:55:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,quic_pkondeti@quicinc.com,mhocko@suse.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,quic_charante@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch removed from -mm tree
Message-Id: <20231211005524.3A060C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: enforce minimum zone size to do high atomic reserves
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Rientjes <rientjes@google.com>
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

