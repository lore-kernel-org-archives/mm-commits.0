Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55E80028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVVm+AT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A55AC433C7;
	Tue, 12 Dec 2023 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407595;
	bh=TyHY+MuVuW4T9h+fyOv8tdvC0+CGYJkhHHto1hGamyc=;
	h=Date:To:From:Subject:From;
	b=XVVm+AT4g+OZEZ8sxoR3W2vrjtH6o8UHupZKM797W5naxbu6FbhBFxh4509KBVYaL
	 dfzH3NQQYPCvtXj76+PcUCCOrwLcriaLRXUZIUlW8doUJzaiL29ZRNOx3Mfcoq1RRn
	 LOOIj+tnGaf79oniKlrJwHEV9BCMxaZU+r6h/8Ec=
Date: Tue, 12 Dec 2023 10:59:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,v-songbaohua@oppo.com,shikemeng@huaweicloud.com,mgorman@techsingularity.net,huzhanyuan@oppo.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch removed from -mm tree
Message-Id: <20231212185955.0A55AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: avoid fast_isolate_freepages blindly choose improper pageblock
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm: compaction: avoid fast_isolate_freepages blindly choose improper pageblock
Date: Thu, 7 Dec 2023 00:00:54 +1300

Testing shows fast_isolate_freepages can blindly choose an unsuitable
pageblock from time to time particularly while the min mark is used from
XXX path:

 if (!page) {
         cc->fast_search_fail++;
         if (scan_start) {
                 /*
                  * Use the highest PFN found above min. If one was
                  * not found, be pessimistic for direct compaction
                  * and use the min mark.
                  */
                 if (highest >= min_pfn) {
                         page = pfn_to_page(highest);
                         cc->free_pfn = highest;
                 } else {
                         if (cc->direct_compaction && pfn_valid(min_pfn)) { /* XXX */
                                 page = pageblock_pfn_to_page(min_pfn,
                                         min(pageblock_end_pfn(min_pfn),
                                             zone_end_pfn(cc->zone)),
                                         cc->zone);
                                 cc->free_pfn = min_pfn;
                         }
                 }
         }
 }

The reason is that no code is doing any check on the min_pfn
 min_pfn = pageblock_start_pfn(cc->free_pfn - (distance >> 1));

In contrast, slow path of isolate_freepages() is always skipping
unsuitable pageblocks in a decent way.

This issue doesn't happen quite often.  When running 25 machines with
16GiB memory for one night, most of them can hit this unexpected code
path.  However the frequency isn't like many times per second.  It might
be one time in a couple of hours.  Thus, it is very hard to measure the
visible performance impact in my machines though the affection of choosing
the unsuitable migration_target should be negative in theory.

I feel it's still worth fixing this to at least make the code
theoretically self-explanatory as it is quite odd an unsuitable
migration_target can be still migration_target.

Link: https://lkml.kernel.org/r/20231206110054.61617-1-v-songbaohua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Zhanyuan Hu <huzhanyuan@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/compaction.c~mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock
+++ a/mm/compaction.c
@@ -1611,6 +1611,9 @@ static void fast_isolate_freepages(struc
 						min(pageblock_end_pfn(min_pfn),
 						    zone_end_pfn(cc->zone)),
 						cc->zone);
+					if (page && !suitable_migration_target(cc, page))
+						page = NULL;
+
 					cc->free_pfn = min_pfn;
 				}
 			}
_

Patches currently in -mm which might be from 21cnbao@gmail.com are


