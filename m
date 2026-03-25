Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C8F238166
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450039; cv=none; b=cTQEj1AradJ5cMO4KQKGKx8tXqHPQFK+VEFuMXodtPq4/wlSRKkQsWA7exikL8kEIpySYg6ylWQVef9UpSpHjl4/FH3RnTHCa/nvHGa3rP18yL2nmp3mhwCO7xMypcklb5QqhefJZhNlK1OzBNW6bWyHv6Y4TcXSJdSHbXB2CT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450039; c=relaxed/simple;
	bh=RNBasUUxPNJSPOIr7b4pFHDQPhSotsCzretj3V16wqc=;
	h=Date:To:From:Subject:Message-Id; b=LU1CqyMyWshPs7JAnGvnIduTACebMykOUeavdhOfCB9ZOJfyIThHcrBEIWhx+oVOV2esKlA/USkri/Jj3Mo0Fg11ZC497IUYCOOcdFqFOR64l1QwP5QFxhrl43tixodYCaCF1lTnD0ezc3/uS+XN5KVWuMxafSk5/8+nhWTOh8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GVXe7odO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GVXe7odO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7DFC4CEF7;
	Wed, 25 Mar 2026 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450039;
	bh=RNBasUUxPNJSPOIr7b4pFHDQPhSotsCzretj3V16wqc=;
	h=Date:To:From:Subject:From;
	b=GVXe7odO0liFKFtU1RKv4NIX29ZlbDzR3Lbp7deDFY8UPnEC1vgnVI+SlIYaBGz1I
	 fL79eJ6n9SGRSzM7xn7E2A9tB20J+adQpFz22uOtyvCAt2n69LbCrkj9zYyxEHXc2L
	 csWYiUgPNNYU/4KIgdCa2Rdc0PdFwQ6pT6/D2zEw=
Date: Wed, 25 Mar 2026 07:47:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-zone-lock-to-zone-_lock-fix.patch removed from -mm tree
Message-Id: <20260325144719.1B7DFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-convert-zone-lock-users-to-wrappers-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-zone-lock-to-zone-_lock-fix.patch

This patch was dropped because it was folded into mm-rename-zone-lock-to-zone-_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-zone-lock-users-to-wrappers-fix-fix
Date: Thu Feb 26 01:53:39 PM PST 2026

update comments in mmzone.h

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-zone-lock-to-zone-_lock-fix
+++ a/include/linux/mmzone.h
@@ -1038,12 +1038,12 @@ struct zone {
 	 * Locking rules:
 	 *
 	 * zone_start_pfn and spanned_pages are protected by span_seqlock.
-	 * It is a seqlock because it has to be read outside of zone->lock,
+	 * It is a seqlock because it has to be read outside of zone_lock,
 	 * and it is done in the main allocator path.  But, it is written
 	 * quite infrequently.
 	 *
-	 * The span_seq lock is declared along with zone->lock because it is
-	 * frequently read in proximity to zone->lock.  It's good to
+	 * The span_seq lock is declared along with zone_lock because it is
+	 * frequently read in proximity to zone_lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
@@ -1066,7 +1066,7 @@ struct zone {
 	/*
 	 * Number of isolated pageblock. It is used to solve incorrect
 	 * freepage counting problem due to racy retrieving migratetype
-	 * of pageblock. Protected by zone->lock.
+	 * of pageblock. Protected by zone_lock.
 	 */
 	unsigned long		nr_isolate_pageblock;
 #endif
@@ -1503,7 +1503,7 @@ typedef struct pglist_data {
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
 	 * or CONFIG_DEFERRED_STRUCT_PAGE_INIT.
 	 *
-	 * Nests above zone->lock and zone->span_seqlock
+	 * Nests above zone_lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

