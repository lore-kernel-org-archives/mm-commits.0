Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4629821C17D
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756786140; cv=none; b=nr5yKD5F6OQE4u4eSlvcYv63Rs0QYqKhy0O94sj3mWh0s7v7VjCdO5WwyOK0bP0xjG8ya30Z00EAKTVsXqb7wXkpafQWXXhjuibAdvRqOft6RwJoFxVotlE7asVQESNc1Hss/Tzn0nDkdfnqeza3DziPIKYxxTIpDlJOPSQINl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756786140; c=relaxed/simple;
	bh=1JgaEm8PgpsHBVFGyh2jd+bEtHYqjbQ0RYW6Mltuo0w=;
	h=Date:To:From:Subject:Message-Id; b=eP6tY4hHx+1sGAxq77/7T/90iQk3Pe4qbuEDZZ75UcW9wHfFv6BBmbDpRv+qYTGCoZWgm4WsC2uewba/LevVsiOROv7wpB0EAZYz+4h2888lVb6p4CROynhamxZJlu9Wx1WwyJZzl4lTRHZgOY4wo3w79fYMDQDtSsNaUQ/vcqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB94TuzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB94TuzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9311BC4CEFB;
	Tue,  2 Sep 2025 04:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756786139;
	bh=1JgaEm8PgpsHBVFGyh2jd+bEtHYqjbQ0RYW6Mltuo0w=;
	h=Date:To:From:Subject:From;
	b=BB94TuzLWbR7cDfoSbfXzUq59pxLlVDejxdG+PZ4SeD9Nv/iJPrW6oqUTJpRrW9j7
	 3/rplFp9PPwS40NpGgp+1yrAhgE6MKswyLCLsQMavOg22SPAKH0HBnbUbtgxfLTFt5
	 GXBzE28z/t4TeQpCfEdFXBaHRMPxVnr4r9iI/dFM=
Date: Mon, 01 Sep 2025 21:08:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,cascardo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-show_mem-show-number-of-zspages-in-show_free_areas.patch removed from -mm tree
Message-Id: <20250902040859.9311BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: show_mem: show number of zspages in show_free_areas
has been removed from the -mm tree.  Its filename was
     mm-show_mem-show-number-of-zspages-in-show_free_areas.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: mm: show_mem: show number of zspages in show_free_areas
Date: Mon, 1 Sep 2025 15:37:28 -0300

When OOM is triggered, it will show where the pages might be for each
zone.  When using zram, it might look like lots of pages are missing. 
After this patch, zspages are shown as below.

[   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   48.792962] lowmem_reserve[]: 0 956 956 956 956
[   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
[   48.793118] lowmem_reserve[]: 0 0 0 0 0

Link: https://lkml.kernel.org/r/20250901183729.3900578-1-cascardo@igalia.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/show_mem.c~mm-show_mem-show-number-of-zspages-in-show_free_areas
+++ a/mm/show_mem.c
@@ -310,6 +310,7 @@ static void show_free_areas(unsigned int
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" writepending:%lukB"
+			" zspages:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -332,6 +333,7 @@ static void show_free_areas(unsigned int
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
+			K(zone_page_state(zone, NR_ZSPAGES)),
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
_

Patches currently in -mm which might be from cascardo@igalia.com are

mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch

