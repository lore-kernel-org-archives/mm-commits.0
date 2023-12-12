Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5EC210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qPTbu9t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8125C433C8;
	Tue, 12 Dec 2023 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407020;
	bh=MRmzlQGk69a8wwnusNIg+3y/gg/vX7Px9HhnYM7M7SM=;
	h=Date:To:From:Subject:From;
	b=qPTbu9t3GXLYnDVDgnOAmDDk2AQ0ocYQZNNL3i6psVZBmivAR3Xp8uMflNpzUpC2I
	 2QfRmCgvMmkWC5WwynHzQNKcdg/urwXQBa8DKxdSG+HDbZb8oMMxbkaeF4oa3aWzpQ
	 4ykQfF+FFKLhR2B8a+rd0LsKewddM1kRP0oYy/0k=
Date: Tue, 12 Dec 2023 10:50:19 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch removed from -mm tree
Message-Id: <20231212185019.E8125C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add per-memcg zswap writeback stat (fix)
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch

This patch was dropped because it was folded into mm-memcg-add-per-memcg-zswap-writeback-stat.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm: memcg: add per-memcg zswap writeback stat (fix)
Date: Tue, 5 Dec 2023 11:33:07 -0800

Rename ZSWP_WB to ZSWPWB to better match the existing counters naming
scheme.

Link: https://lkml.kernel.org/r/20231205193307.2432803-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 +-
 mm/memcontrol.c               |    2 +-
 mm/vmstat.c                   |    2 +-
 mm/zswap.c                    |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/vm_event_item.h~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/include/linux/vm_event_item.h
@@ -142,7 +142,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_ZSWAP
 		ZSWPIN,
 		ZSWPOUT,
-		ZSWP_WB,
+		ZSWPWB,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
--- a/mm/memcontrol.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/memcontrol.c
@@ -703,7 +703,7 @@ static const unsigned int memcg_vm_event
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	ZSWPIN,
 	ZSWPOUT,
-	ZSWP_WB,
+	ZSWPWB,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
--- a/mm/vmstat.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/vmstat.c
@@ -1401,7 +1401,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_ZSWAP
 	"zswpin",
 	"zswpout",
-	"zswp_wb",
+	"zswpwb",
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
--- a/mm/zswap.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/zswap.c
@@ -761,9 +761,9 @@ static enum lru_status shrink_memcg_cb(s
 	zswap_written_back_pages++;
 
 	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWP_WB);
+		count_objcg_event(entry->objcg, ZSWPWB);
 
-	count_vm_event(ZSWP_WB);
+	count_vm_event(ZSWPWB);
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
mm-memcg-add-per-memcg-zswap-writeback-stat.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch
zswap-memcontrol-implement-zswap-writeback-disabling.patch

