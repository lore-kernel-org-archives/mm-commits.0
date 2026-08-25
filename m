Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3C377ABE
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622953; cv=none; b=XOZaMJYXSCKzKpouxqUyAYJ6h9IQtfnvfbiboihf9xAOZQwB/kzs23R159pvcwNwtE2vi2XuTJbYKZWt2ex14wLy24oHymCjQiXbQKBPvuKjw/4z5gEJPkoXgQtLkup4+52YjwIQjBh+YNY9oV57kbkurjBKNW8+SW5q0GvGZT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622953; c=relaxed/simple;
	bh=H1/ZKp4W/IYsZnrkGJ2ePwnl0F2fqUPtifMhQiCkJIk=;
	h=Date:To:From:Subject:Message-Id; b=N8/lQ9fx5OBraY8UBznR0Mi95hVUjKx+zo8eWWVLaq3RTqQjsmXo8RYXSwbhC4fQvUBDLI6RhliheQN8MOxq3KZR/BqKRT7iQr0f9aLLECXZaW2wr1TLarwll8YSrevuewo+V9Vk1XocpFVQHzA7IomfDn2v1tG/ncMnXTEsX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSPEPKn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSPEPKn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D211F00A3D;
	Tue, 25 Aug 2026 01:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622951;
	bh=fbzUDzs1kw9rlpMbRTJEIYU+fvSbkDpd+sSz1Eo8VcM=;
	h=Date:To:From:Subject;
	b=bSPEPKn+rgLLFODwpDos74yqH/4EAk6hVPQNwZmcGnNOX11cjwOvswy9D/PoEi8eQ
	 iwQoU1fo2cTR4xbr40gU8hlAIPtRPzN4Cj1fjsT2fIXmQZmEOV+yECw541uK90NNqa
	 9GiR0aJdT8g+eMDXKXm/AG5dSYNDYo6Ez8YQKtGo=
Date: Mon, 24 Aug 2026 18:55:51 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch removed from -mm tree
Message-Id: <20260825015551.96D211F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: avoid false sharing between vmstats and events
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/memcontrol: avoid false sharing between vmstats and events
Date: Mon, 17 Aug 2026 03:38:35 -0700

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank struct
vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.  This
moved memory_events_local[MEMCG_SWAP_FAIL] and the hot vmstats_percpu
pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap disabled,
generating about 20 million MEMCG_SWAP_FAIL updates per 60-second run on a
176-CPU test system.  Those writes bounce the line while memcg statistics
paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the test
system with one socket.  The patched kernel brings the performance to
within 0.5% of the parent which is within the observed boot-to-boot spread
(up to 1.2%).

Link: https://lore.kernel.org/20260817103835.2937733-1-usama.arif@linux.dev
Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Tested-by: kernel test robot <yi1.lai@intel.com>
  Link: http://lore.kernel.org/aoAABX59IzUXz/Rv@ly-workstation
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-avoid-false-sharing-between-vmstats-and-events
+++ a/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-huge_memory-transfer-the-pmd-dirty-bit-to-the-folio-on-zap.patch

