Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D3880022
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oyvUOcBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31897C433C8;
	Tue, 12 Dec 2023 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407562;
	bh=Y5xRgTURsPiKnPIYnI54V6Xpde+ln6Hz0qqwXX46opw=;
	h=Date:To:From:Subject:From;
	b=oyvUOcBmt7HFP5C4T0HUupZJs1XjUyQtFzE8qwozuOVCh1N7LzjdBdFYgn2qb24vC
	 nlKd4DXUGMwrQSTWPH9+e6M45vYll85IMIRGHvUGNLzDF3uUcCyHvfRAvO0xmRta+f
	 Z0Qt7wyAOZ3FuuyLT7vNRcaYUEvy0TVqCLmb0a9I=
Date: Tue, 12 Dec 2023 10:59:21 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,bagasdotme@gmail.com,cerasuolodomenico@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-per-memcg-zswap-writeback-stat.patch removed from -mm tree
Message-Id: <20231212185922.31897C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add per-memcg zswap writeback stat
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-per-memcg-zswap-writeback-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: memcg: add per-memcg zswap writeback stat
Date: Thu, 30 Nov 2023 11:40:21 -0800

Since zswap now writes back pages from memcg-specific LRUs, we now need a
new stat to show writebacks count for each memcg.

[nphamcs@gmail.com: rename ZSWP_WB to ZSWPWB]
  Link: https://lkml.kernel.org/r/20231205193307.2432803-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20231130194023.4102148-5-nphamcs@gmail.com
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/memcontrol.c               |    1 +
 mm/vmstat.c                   |    1 +
 mm/zswap.c                    |    4 ++++
 4 files changed, 7 insertions(+)

--- a/include/linux/vm_event_item.h~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/include/linux/vm_event_item.h
@@ -142,6 +142,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_ZSWAP
 		ZSWPIN,
 		ZSWPOUT,
+		ZSWPWB,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
--- a/mm/memcontrol.c~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/mm/memcontrol.c
@@ -703,6 +703,7 @@ static const unsigned int memcg_vm_event
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	ZSWPIN,
 	ZSWPOUT,
+	ZSWPWB,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
--- a/mm/vmstat.c~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/mm/vmstat.c
@@ -1401,6 +1401,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_ZSWAP
 	"zswpin",
 	"zswpout",
+	"zswpwb",
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
--- a/mm/zswap.c~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/mm/zswap.c
@@ -760,6 +760,10 @@ static enum lru_status shrink_memcg_cb(s
 	}
 	zswap_written_back_pages++;
 
+	if (entry->objcg)
+		count_objcg_event(entry->objcg, ZSWPWB);
+
+	count_vm_event(ZSWPWB);
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are


