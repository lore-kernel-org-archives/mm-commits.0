Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC6A42078
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664150; cv=none; b=FijaFsN9FQsCIOZc9PRWY1NcAdxZqBtg5hS5DwzP53LgMXUDziP+DV0IEjqWx+inNVjO3c9sEFeiUJHDLCkgHD39CFLQ+RLtFK1rwdwN4bo40rFEYgqGTPuUYaZwYJdYhH3gciwA9mmE+/8chTGv2lEKe397qJIZ2mSuwKpzvX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664150; c=relaxed/simple;
	bh=21LZLDGlp/y7vOtp4262+xKtW9DyFN5dWTYeelvEJ1o=;
	h=Date:To:From:Subject:Message-Id; b=MQtHiBCFakD+7VXeu5+4NoflaiHvaTwXJ6KTa7bPuRzqAMyi7hHkjdEIF7BPg5+eJMP4cptuZhSzIHHPPjmbiWzADz475nVKz341FYnF7Ej4fAU7ewz59lL/qoberQWWb2PUqVn4glBSsaqm3Rb5FrotxSUNjmWfj29+wXh3vP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=meqk5PRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="meqk5PRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0334AC113CC;
	Thu,  2 May 2024 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664150;
	bh=21LZLDGlp/y7vOtp4262+xKtW9DyFN5dWTYeelvEJ1o=;
	h=Date:To:From:Subject:From;
	b=meqk5PRP97zryvaqgE2a1esFhFvO71Jh784Dq5gyjqarlsNP6+tCpdigLo+0fNq14
	 /M6G/ycNMdjXWqSSQofBB/XYLUCRv32ZAbPLL03ie0c56GmpR393Z0sm72wjs6TL1I
	 7k3uV50TNJuc25Ml7L78spqGiKdxYtpcmgU8mtTw=
Date: Thu, 02 May 2024 08:35:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-reduce-memory-size-of-mem_cgroup_events_index.patch added to mm-unstable branch
Message-Id: <20240502153550.0334AC113CC@smtp.kernel.org>
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
Date: Wed, 1 May 2024 10:26:10 -0700

Patch series "memcg: reduce memory consumption by memcg stats", v4.

Most of the memory overhead of a memcg object is due to memcg stats
maintained by the kernel.  Since stats updates happen in performance
critical codepaths, the stats are maintained per-cpu and numa specific
stats are maintained per-node * per-cpu.  This drastically increase the
overhead on large machines i.e.  large of CPUs and multiple numa nodes. 
This patch series tries to reduce the overhead by at least not allocating
the memory for stats which are not memcg specific.  


This patch (of 8):

mem_cgroup_events_index is a translation table to get the right index of
the memcg relevant entry for the general vm_event_item.  At the moment, it
is defined as integer array.  However on a typical system the max entry of
vm_event_item (NR_VM_EVENT_ITEMS) is 113, so we don't need to use int as
storage type of the array.  For now just use int8_t as type and add a
BUILD_BUG_ON().

Another benefit of this change is that the translation table fits in 2
cachelines while previously it would require 8 cachelines (assuming 64
bytes cacheline).

Link: https://lkml.kernel.org/r/20240501172617.678560-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240501172617.678560-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-reduce-memory-size-of-mem_cgroup_events_index
+++ a/mm/memcontrol.c
@@ -606,11 +606,13 @@ static const unsigned int memcg_vm_event
 };
 
 #define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
-static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+static int8_t mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
 
 static void init_memcg_events(void)
 {
-	int i;
+	int8_t i;
+
+	BUILD_BUG_ON(NR_VM_EVENT_ITEMS >= S8_MAX);
 
 	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
 		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch
memcg-warn-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch

