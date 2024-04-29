Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05CE85C41
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411151; cv=none; b=G4xaDMn6nEASdc73I2xY70qPSViG0MM6IUYeeKsPSIpLcsQ03WhGy3ltnX1cjepIyrYQZZG6BpuxlQjuNuY28EZsEs2g0AsnoAwG8QkreZPpQ57Bu+mabxCdQ2ZCnxYrFedqffix8c1bCbLWw09fBND3+J8Bibs+lR+IW5M0kDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411151; c=relaxed/simple;
	bh=yC7xigGhCttZtqNBWUP+cB6HlVBg4d9UOca+iz1uubk=;
	h=Date:To:From:Subject:Message-Id; b=jwy7sbFaszSOHh1kXr9Q1cHlfev/3T9wO0k1jYXfHvXY1ikB4aRLij6iDtEP0VWKxeZqTP44gsZNSBJCfqi8SSWkO6dKCXuBNAndCWGaJs3y4m17j60dogzMFDfx9ViSSzOEgAY6HNKV82XmtQHCR/275PToKFhHYUJLoE3knNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zst475n7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zst475n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24214C4AF14;
	Mon, 29 Apr 2024 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714411149;
	bh=yC7xigGhCttZtqNBWUP+cB6HlVBg4d9UOca+iz1uubk=;
	h=Date:To:From:Subject:From;
	b=zst475n7jzxhbGwBpowRFJbLNk8MaubOWXfA+Il5MfjwvInW8lbqZ5Ha8CZnltKNA
	 Hv+lo1+krLIRhJWhQ1PtOA+WSo/idiIjsQfFWaMiNuP0elgcJtOEkFPulhuNh8m1ls
	 /V/3H8SEV2Ll9LLElRu5dkh7a60X1LyV0xakEGIs=
Date: Mon, 29 Apr 2024 10:19:07 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-reduce-memory-size-of-mem_cgroup_events_index.patch added to mm-unstable branch
Message-Id: <20240429171909.24214C4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: reduce memory size of mem_cgroup_events_index
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-reduce-memory-size-of-mem_cgroup_events_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-reduce-memory-size-of-mem_cgroup_events_index.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: reduce memory size of mem_cgroup_events_index
Date: Fri, 26 Apr 2024 17:37:27 -0700

Patch series "memcg: reduce memory consumption by memcg stats", v2.

Most of the memory overhead of a memcg object is due to memcg stats
maintained by the kernel.  Since stats updates happen in performance
critical codepaths, the stats are maintained per-cpu and numa specific
stats are maintained per-node * per-cpu.  This drastically increase the
overhead on large machines i.e.  large of CPUs and multiple numa nodes. 
This patch series tries to reduce the overhead by at least not allocating
the memory for stats which are not memcg specific.

The main change from the v1 is the indirection approach used in this
patchset instead of rearranging the members of node_stat_item.  


This patch (of 7):

mem_cgroup_events_index is a translation table to get the right index of
the memcg relevant entry for the general vm_event_item.  At the moment, it
is defined as integer array.  However on a typical system the max entry of
vm_event_item (NR_VM_EVENT_ITEMS) is 113, so we don't need to use int as
storage type of the array.  For now just use int8_t as type and add a
BUILD_BUG_ON() and will switch to short once NR_VM_EVENT_ITEMS touches
127.

Link: https://lkml.kernel.org/r/20240427003733.3898961-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240427003733.3898961-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-reduce-memory-size-of-mem_cgroup_events_index
+++ a/mm/memcontrol.c
@@ -606,11 +606,14 @@ static const unsigned int memcg_vm_event
 };
 
 #define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
-static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+static int8_t mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
 
 static void init_memcg_events(void)
 {
-	int i;
+	int8_t i;
+
+	/* Switch to short once this failure occurs. */
+	BUILD_BUG_ON(NR_VM_EVENT_ITEMS >= 127 /* INT8_MAX */);
 
 	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
 		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
memcg-pr_warn_once-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch

