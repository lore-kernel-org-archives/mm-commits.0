Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5337E33F588
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772491074; cv=none; b=JR1HcVW/Izc8t9xf8wfbCHIhhiu9qmOlYrl8qS1rrIjNXVwSDkWaACHpC/jlHrsTGnmFJFoSQ8ufcyUk9vuQtE/Krcs6mCMufmMoZPFdr0Tg6P7yOlrmV49VqEMFYvOVDhbG6eezdMFhJOX+Jv3+mgNkr5cFy6BVADvpUR1P+kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772491074; c=relaxed/simple;
	bh=p8eeNN1f/3youTEEZ4qyzXktAWlJbPs2sapUTsi/dgs=;
	h=Date:To:From:Subject:Message-Id; b=kPm2YtmQIjAODhwQjyYMfLQAs1pF+MzR/ajq3aEwS2vEBVnGGw7pk4UJAF3PG8j+3gxSK5wHejEPHHb9UuYYb/jzuwrFblSM9MjQp8Yp2E3OkxwEgfceJVdhCqT4TCwXzbEan6ahlj8U6yBuT9J7ZZwpVHQc/Om/dRZux3PG8t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n6/Hil/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n6/Hil/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1650C19423;
	Mon,  2 Mar 2026 22:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772491073;
	bh=p8eeNN1f/3youTEEZ4qyzXktAWlJbPs2sapUTsi/dgs=;
	h=Date:To:From:Subject:From;
	b=n6/Hil/LEtKnc5Wl2s8gH335zLgHqsCxV7Hfap/tWD/fYDuQmLL3P7Vq2tKTyJjLM
	 lfUFotmnD4FqCY8IQJj4cCPWdXOFnYlR0rE44gaiHUHz6+Yg7eU1PraUOvubASotE/
	 KpoXBPyo48VLLUYvMRPSgzyTn0YG3W/sSpwjsMsA=
Date: Mon, 02 Mar 2026 14:37:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-zone-lock-to-zone-_lock-fix.patch added to mm-new branch
Message-Id: <20260302223753.D1650C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-zone-lock-users-to-wrappers-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-zone-lock-to-zone-_lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-zone-lock-to-zone-_lock-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -1037,12 +1037,12 @@ struct zone {
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
@@ -1065,7 +1065,7 @@ struct zone {
 	/*
 	 * Number of isolated pageblock. It is used to solve incorrect
 	 * freepage counting problem due to racy retrieving migratetype
-	 * of pageblock. Protected by zone->lock.
+	 * of pageblock. Protected by zone_lock.
 	 */
 	unsigned long		nr_isolate_pageblock;
 #endif
@@ -1502,7 +1502,7 @@ typedef struct pglist_data {
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

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

