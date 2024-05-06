Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4293038F94
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957148; cv=none; b=UGrj0la1UFOgJAaoIAT3JEjbALzRVKNuygil9gcOBOwgiwlCfIYJ2u9UpoW8st2Hg5mQ+CgyciiAq8RnCKQkut2ggOMpGpCrmsXuNO3FmEWYYMVMf+thtDj7IupDNeb6mGwcCuj4vnL4qTT35k/SQDbYvozoseBhOEVH2i1wJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957148; c=relaxed/simple;
	bh=tuerGVa2mdgSvIEcmInVPTNhNW5BhTimHseyBnNykmI=;
	h=Date:To:From:Subject:Message-Id; b=VMsZmMfDKBHcrCCprYlhlK7iXgJ/20/rbU6//L65tchHuYffyJmGpDeHaTfhLZijw3EDh3fwSSWBC+fBEHumjtWO8caqEcSzqBeGlAR49odCOwSC09Yv/WLqSsk21HfwcVYH2Z/iYwYgZEKmOx/XCsvnHJPTEt47gZO7PsfKx6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mY+lm2+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mY+lm2+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1221EC113CC;
	Mon,  6 May 2024 00:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957148;
	bh=tuerGVa2mdgSvIEcmInVPTNhNW5BhTimHseyBnNykmI=;
	h=Date:To:From:Subject:From;
	b=mY+lm2+ozN04sR0KQZvvIyRkDL3ik2Rll2oG//DXjAPFpvlv1+Py9OO0zY0nUcLS/
	 cSrqT0o95EcK0ZpxOkEreXL6OJAoIkVCYckh1gCifAGEoqGEVVPFfbpXJzYuKeVzJu
	 x6ov4sT7bCddBzMcleLKoq24043l5rWtox+uIlwI=
Date: Sun, 05 May 2024 17:59:07 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-reduce-memory-size-of-mem_cgroup_events_index.patch removed from -mm tree
Message-Id: <20240506005908.1221EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: reduce memory size of mem_cgroup_events_index
has been removed from the -mm tree.  Its filename was
     memcg-reduce-memory-size-of-mem_cgroup_events_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


