Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64FD6FA9
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DfOSeFeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2025AC433C8;
	Mon, 11 Dec 2023 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256123;
	bh=uicRQI8fcd/e9PhwaxvA/HFzW9KC/OqL7G6A8TKfmQs=;
	h=Date:To:From:Subject:From;
	b=DfOSeFeXCLlKFTVewOlPdzTkXE7muSujR8WcbAEhVOaHrQEAolLNGl2JksWvP3dEC
	 C1AN3hT0whAhd8LESnXvIoblj4Ej+KCaM1Rjln82PiH8tITM+P37lqGqvbi34wGF+q
	 yeDmN38+13EN0n+Cp37QCt8NYKyZ9ki/C0WlyNag=
Date: Sun, 10 Dec 2023 16:55:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,quic_pkondeti@quicinc.com,mhocko@suse.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,quic_charante@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-correct-high-atomic-reserve-calculations.patch removed from -mm tree
Message-Id: <20231211005523.2025AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: correct high atomic reserve calculations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-correct-high-atomic-reserve-calculations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: page_alloc: correct high atomic reserve calculations
Date: Fri, 24 Nov 2023 16:35:52 +0530

Patch series "mm: page_alloc: fixes for high atomic reserve
caluculations", v3.

The state of the system where the issue exposed shown in oom kill logs:

[  295.998653] Normal free:7728kB boost:0kB min:804kB low:1004kB high:1204kB reserved_highatomic:8192KB active_anon:4kB inactive_anon:0kB active_file:24kB inactive_file:24kB unevictable:1220kB writepending:0kB present:70732kB managed:49224kB mlocked:0kB bounce:0kB free_pcp:688kBlocal_pcp:492kB free_cma:0kB
[  295.998656] lowmem_reserve[]: 0 32
[  295.998659] Normal: 508*4kB (UMEH) 241*8kB (UMEH) 143*16kB (UMEH)
33*32kB (UH) 7*64kB (UH) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7752kB

From the above, it is seen that ~16MB of memory reserved for high atomic
reserves against the expectation of 1% reserves which is fixed in the 1st
patch.

Don't reserve the high atomic page blocks if 1% of zone memory size is
below a pageblock size.


This patch (of 2):

reserve_highatomic_pageblock() aims to reserve the 1% of the managed pages
of a zone, which is used for the high order atomic allocations.

It uses the below calculation to reserve:
static void reserve_highatomic_pageblock(struct page *page, ....) {

   .......
   max_managed = (zone_managed_pages(zone) / 100) + pageblock_nr_pages;

   if (zone->nr_reserved_highatomic >= max_managed)
       goto out;

   zone->nr_reserved_highatomic += pageblock_nr_pages;
   set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
   move_freepages_block(zone, page, MIGRATE_HIGHATOMIC, NULL);

out:
   ....
}

Since we are always appending the 1% of zone managed pages count to
pageblock_nr_pages, the minimum it is turning into 2 pageblocks as the
nr_reserved_highatomic is incremented/decremented in pageblock sizes.

Encountered a system(actually a VM running on the Linux kernel) with the
below zone configuration:
Normal free:7728kB boost:0kB min:804kB low:1004kB high:1204kB
reserved_highatomic:8192KB managed:49224kB

The existing calculations making it to reserve the 8MB(with pageblock size
of 4MB) i.e.  16% of the zone managed memory.  Reserving such high amount
of memory can easily exert memory pressure in the system thus may lead
into unnecessary reclaims till unreserving of high atomic reserves.

Since high atomic reserves are managed in pageblock size granules, as
MIGRATE_HIGHATOMIC is set for such pageblock, fix the calculations for
high atomic reserves as, minimum is pageblock size , maximum is
approximately 1% of the zone managed pages.

Link: https://lkml.kernel.org/r/cover.1700821416.git.quic_charante@quicinc.com
Link: https://lkml.kernel.org/r/1660034138397b82a0a8b6ae51cbe96bd583d89e.1700821416.git.quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-high-atomic-reserve-calculations
+++ a/mm/page_alloc.c
@@ -1880,10 +1880,11 @@ static void reserve_highatomic_pageblock
 	unsigned long max_managed, flags;
 
 	/*
-	 * Limit the number reserved to 1 pageblock or roughly 1% of a zone.
+	 * The number reserved as: minimum is 1 pageblock, maximum is
+	 * roughly 1% of a zone.
 	 * Check is race-prone but harmless.
 	 */
-	max_managed = (zone_managed_pages(zone) / 100) + pageblock_nr_pages;
+	max_managed = ALIGN((zone_managed_pages(zone) / 100), pageblock_nr_pages);
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch
mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch

