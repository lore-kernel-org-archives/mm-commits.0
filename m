Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21106188904;
	Fri, 15 Nov 2024 06:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653080; cv=none; b=tcEqah6vVh4fm18hJFKE6X7pCu9wGuThu4VgnIE4FiZ2t+qkC1H03FdxIz2okXWtLxpgKg03v3q+5ewC7v2BFximFc4i5n4Zp3lDPemBYQeSb58H7iL7UMog3aEwRKVRP0+IC5CmwaBZf8YpvIkwXWZHG5DsXxLJrgSyROyFNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653080; c=relaxed/simple;
	bh=3j/jlY5NFzGdjz4E1DpM/UlsSNW3iAECaKqzO0hsitQ=;
	h=Date:To:From:Subject:Message-Id; b=Roq9wUWyx7kAnrwjoZeNzo0qJ1sHdfIcHiRGDOH8OIS2VJMbRBrem8+u3sh5QhRoU3XyGHiaOIBmyMjazuqrg4bd1+ofVv65iyNUJ0Ig2Mlh/guqNRX9iN513tkvqAn1JKlUi6/0eUvpQuM3BE6A0df/zW48O5QMOQWJkVvRAbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oC0bLO+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oC0bLO+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F84C4CED0;
	Fri, 15 Nov 2024 06:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653079;
	bh=3j/jlY5NFzGdjz4E1DpM/UlsSNW3iAECaKqzO0hsitQ=;
	h=Date:To:From:Subject:From;
	b=oC0bLO+PpXqYQv8iIzOXDL2EiSIcxYh6/ADtTgMRXFRS0D8xKPmcr/Rky3YlqtRuE
	 Ydw7jn01538x7vH3IF3HiUD53Y7Gh3xje87er0Tqs/R9mc7Pi7POdjucsUDY63N/rt
	 p5KczYKk8e3mFA3N6dp0dIZPvMMa6jwmroCgKoKc=
Date: Thu, 14 Nov 2024 22:44:35 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,sunnanyong@huawei.com,stable@vger.kernel.org,mgorman@techsingularity.net,david@redhat.com,alobakin@pm.me,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch removed from -mm tree
Message-Id: <20241115064439.49F84C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix NULL pointer dereference in alloc_pages_bulk_noprof
has been removed from the -mm tree.  Its filename was
     mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm: fix NULL pointer dereference in alloc_pages_bulk_noprof
Date: Wed, 13 Nov 2024 16:32:35 +0800

We triggered a NULL pointer dereference for ac.preferred_zoneref->zone in
alloc_pages_bulk_noprof() when the task is migrated between cpusets.

When cpuset is enabled, in prepare_alloc_pages(), ac->nodemask may be
&current->mems_allowed.  when first_zones_zonelist() is called to find
preferred_zoneref, the ac->nodemask may be modified concurrently if the
task is migrated between different cpusets.  Assuming we have 2 NUMA Node,
when traversing Node1 in ac->zonelist, the nodemask is 2, and when
traversing Node2 in ac->zonelist, the nodemask is 1.  As a result, the
ac->preferred_zoneref points to NULL zone.

In alloc_pages_bulk_noprof(), for_each_zone_zonelist_nodemask() finds a
allowable zone and calls zonelist_node_idx(ac.preferred_zoneref), leading
to NULL pointer dereference.

__alloc_pages_noprof() fixes this issue by checking NULL pointer in commit
ea57485af8f4 ("mm, page_alloc: fix check for NULL preferred_zone") and
commit df76cee6bbeb ("mm, page_alloc: remove redundant checks from alloc
fastpath").

To fix it, check NULL pointer for preferred_zoneref->zone.

Link: https://lkml.kernel.org/r/20241113083235.166798-1-tujinjiang@huawei.com
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-fix-null-pointer-dereference-in-alloc_pages_bulk_noprof
+++ a/mm/page_alloc.c
@@ -4607,7 +4607,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
-	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+	z = ac.preferred_zoneref;
+	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


