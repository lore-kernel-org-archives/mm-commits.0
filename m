Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405154A04
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 00:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729901545; cv=none; b=cVJuTFp9hHHtBH00qfzz6DR2dzIMfJYcIu4R0ihEEvYXUEXphfdbQptxujeFEn3Kb2LmIWGQXvfd34DIr90/QF0MCXc6AS9z4XgU+zdhcfO6nJF8FW4eK+0TB/0euIPb5ayMBoqKtnUmk4TWJlCoRVG3R9L7aLhyqN3OxvQyljM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729901545; c=relaxed/simple;
	bh=qOSI30uXd8l+GbZ+lYmM7SJAro4xwaKK+cdjNVzVhzQ=;
	h=Date:To:From:Subject:Message-Id; b=YtXRQ16OmDjZc5wVP7vk6kpVb0RYgTR/MqnO9w4v71NuBRBmpvuH07XCZOxwTfyF+Jh022K+7TZDT/GDt/gRaYneFJ/dXYLHMekRbcZ/GMxDioMjaPDIrJqCMqOrkcS8+HmoV6MKpuTmpzDUCxVPcG8be10lidYtB40LbzSq8fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RlbZSYlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RlbZSYlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33ACC4CECD;
	Sat, 26 Oct 2024 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729901544;
	bh=qOSI30uXd8l+GbZ+lYmM7SJAro4xwaKK+cdjNVzVhzQ=;
	h=Date:To:From:Subject:From;
	b=RlbZSYlp7e9f1WWjE+DNTuKwIrgCtHpGpfRw3TZBGTq28FB1gtX3wM1z7MzbLJ5zT
	 FOz0Enf2d5L3HfZxbAsrYQAnQhyXkLgtqkTahBmXowEAtEpxgAni3lGykVoMlV81bu
	 WjeynDrSmNDbAZnxI/4DlNY2GbAME17J6QfxFR/w=
Date: Fri, 25 Oct 2024 17:12:24 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,liyangouwen1@oppo.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch removed from -mm tree
Message-Id: <20241026001224.C33ACC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: wake_up only when swapcache_wq waitqueue is active
has been removed from the -mm tree.  Its filename was
     mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch

This patch was dropped because it was folded into mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: wake_up only when swapcache_wq waitqueue is active
Date: Tue, 8 Oct 2024 20:18:27 +0800

wake_up() will acquire spinlock even waitqueue is empty. This might
involve cache sync overhead. Let's only call wake_up() when waitqueue
is active.

Link: https://lkml.kernel.org/r/20241008130807.40833-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oven Liyang <liyangouwen1@oppo.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix
+++ a/mm/memory.c
@@ -4611,7 +4611,8 @@ out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
 	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
-		wake_up(&swapcache_wq);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
 	}
 	if (si)
 		put_swap_device(si);
@@ -4629,7 +4630,8 @@ out_release:
 	}
 	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
-		wake_up(&swapcache_wq);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
 	}
 	if (si)
 		put_swap_device(si);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch
mm-fix-pswpin-counter-for-large-folios-swap-in.patch

