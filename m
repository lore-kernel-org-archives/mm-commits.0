Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5F428DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489857; cv=none; b=ooB0N0Qx2qhPgW+pr/YxDm/jyz45C0ieuTOD0TPLJ9FXUEp0gTsV2BgxgR9nlStHJteZmhnnaCUr9Fafrf6d2HfffCJoeemKjoaJeGjMo9SaTyxwZpKXsHHCeMuOhaVETQbTzjrtvmLQQ2FGhRnwFYh0FaCQtoiI3a+TFl/aJEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489857; c=relaxed/simple;
	bh=8/s1BtFDfl2CrI7XFAg0xE5bWbbmpys0OWp6QqvgZOo=;
	h=Date:To:From:Subject:Message-Id; b=CwI4X2ZOPdYAk0ox5nxI5/pQFbxO8Y7ljiMaxdod9MMOBB4BINsIwZouVPZrzz884ASN7u7ZQ0Vj+/6xakIFahhFeNEYwopjr8G1Z42/IF1hZRpB3VHxUvQv9r+CTTJDvKbJvAgqqJa2KXnSYdvtaPPoAsqXGstIbZ3xSN5Epco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LIsDizMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LIsDizMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308CEC4CEE7;
	Sun, 21 Sep 2025 21:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489857;
	bh=8/s1BtFDfl2CrI7XFAg0xE5bWbbmpys0OWp6QqvgZOo=;
	h=Date:To:From:Subject:From;
	b=LIsDizMBYeq0uycNoRbv0YBc+41XdGrfMGVcK8Pfnt7I7roCk/ZSSJsDYLxAIYOgQ
	 mbs09kNvyPHSxB96IQAdZ66O+gbtl4CBITalwH4kFfWaaKL30i5Q1XjzeQBnAxFAmk
	 q9PJFSiRCNSRyYTYbxCdrcAoFwXN7VWCYU/7VDB4=
Date: Sun, 21 Sep 2025 14:24:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,cascardo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-show-number-of-zspages-in-show_free_areas.patch removed from -mm tree
Message-Id: <20250921212417.308CEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: show_mem: show number of zspages in show_free_areas
has been removed from the -mm tree.  Its filename was
     mm-show_mem-show-number-of-zspages-in-show_free_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: mm: show_mem: show number of zspages in show_free_areas
Date: Tue, 2 Sep 2025 09:49:21 -0300

When OOM is triggered, it will show where the pages might be for each
zone.  When using zram or zswap, it might look like lots of pages are
missing.  After this patch, zspages are shown as below.

[   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   48.792962] lowmem_reserve[]: 0 956 956 956 956
[   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
[   48.793118] lowmem_reserve[]: 0 0 0 0 0

Link: https://lkml.kernel.org/r/20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
@@ -332,6 +333,11 @@ static void show_free_areas(unsigned int
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
+#if IS_ENABLED(CONFIG_ZSMALLOC)
+			K(zone_page_state(zone, NR_ZSPAGES)),
+#else
+			0UL,
+#endif
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
_

Patches currently in -mm which might be from cascardo@igalia.com are


