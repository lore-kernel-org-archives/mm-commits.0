Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE21C6FF8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274663; cv=none; b=EsxnP5+2Dw+8Xx4hxibFMthzTplBUn0bwHRN02i3CI41au6RxuMiOn1oKYOlbKTu0NqiV1wD1FAhlkhFK4NQlbmJD6CN6zGW6pZs1Hir3+8I7mbcGpAHF3cUexVPjV13IUyFk/kNri3NlGLqQLtUS14n/1svmv4ILsoiEOmVgRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274663; c=relaxed/simple;
	bh=eTZqoRcmTOCI2kQl3zTezz+/QmfawnIld/m2OHNn0Tw=;
	h=Date:To:From:Subject:Message-Id; b=DrzVRg+xBx2H3BqaLg+kZvI8ro56ASgoL06VkT1ghqrUSyseWM6RJBW/A+q1Qps1/Tivd4z+kco+XVcJV+vKgjai6jzg8WuldHDAcAGcTW6g7CWdAWnCaBSurJvSCT0HTyZ+Lxp2rHRv0gL8iREOatYLCK5Qsy0xieXoslu0yZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HfWyLuAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HfWyLuAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31A3C4CEDD;
	Tue, 18 Mar 2025 05:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274663;
	bh=eTZqoRcmTOCI2kQl3zTezz+/QmfawnIld/m2OHNn0Tw=;
	h=Date:To:From:Subject:From;
	b=HfWyLuAFev8DQgrgSIvKZAJqbw37Yz0pFqxjMAT9sjZBzu4IldEf3gfsM4ra9pVwF
	 toJyWMGEoHh6xQFsgAoQxuuQY/ta0Dixj0bKf2RMtbFTzYcgFNRViZV5dmYwpUSUFa
	 53W7TD32uhVfpz6wcroe5j/YiuX9GGKsr9MUUAzQ=
Date: Mon, 17 Mar 2025 22:11:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch removed from -mm tree
Message-Id: <20250318051102.E31A3C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: trace type pollution from compaction capturing
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: trace type pollution from compaction capturing
Date: Thu, 13 Mar 2025 17:05:33 -0400

When the page allocator places pages of a certain migratetype into blocks
of another type, it has lasting effects on the ability to compact and
defragment down the line.  For improving placement and compaction,
visibility into such events is crucial.

The most common case, allocator fallbacks, is already annotated, but
compaction capturing is also allowed to grab pages of a different type. 
Extend the tracepoint to cover this case.

Link: https://lkml.kernel.org/r/20250313210647.1314586-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-trace-type-pollution-from-compaction-capturing
+++ a/mm/page_alloc.c
@@ -614,6 +614,10 @@ compaction_capture(struct capture_contro
 	    capc->cc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
+	if (migratetype != capc->cc->migratetype)
+		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
+					    capc->cc->migratetype, migratetype);
+
 	capc->page = page;
 	return true;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


