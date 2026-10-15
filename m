Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9B735957;
	Thu, 15 Oct 2026 00:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023272; cv=none; b=iQYFLakh1TsCFhnrLxNHoDCkvKd/xLvZP2uULgs65aY4uLkgeDJTXOe9763UXxj6kjLLlcJbhEdf5QFizc9cJY8Nb+/Xr1GBfDzbTwzeExW5Z6QrAJRr6r67Kak4clkrww768T2V8r8aKdU2qGrxo+Sm6Jrwqrt28PCn64pnRBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023272; c=relaxed/simple;
	bh=9j9QwpDgyrXtFTHOsY15ySBN6ynUN3YDGYhlNL63myE=;
	h=Date:To:From:Subject:Message-Id; b=Orn+vQny53eQ5iycvgf7PYwCPGG/xTIm6IuqA7HMsh0RxSBSa+Lel0sCrWLkxM2Qi7LdoMg9rmckSa0Kyl0JC3SqddMKGr8zwM4wSq9C5u/s9X7TYA+sUewzPiTuBYsykdIJ9qbBApZ3ah07gk6TJNNtHLY/HlfmFvK2tXvuUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GqJ17zVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GqJ17zVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0201F000C4;
	Thu, 15 Oct 2026 00:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792023271;
	bh=VV5nwcAKt/FhchLwlW3xCzUga6eRby73KFyJSdBvCXg=;
	h=Date:To:From:Subject;
	b=GqJ17zVbWiuNcFhj/HSR7eXYv4NPVycDHgk+7nK+P4dr0pOMEqgWAw8wg1izSP1Vz
	 ROQCJoRvJIIS//lK1UTbqDN4ELN0cGVtoe9q//3yPPg7I8jtIwY7wlqZ3w9pbinahu
	 0cz1dbdh8SwLuY5+/4eZDN110aJ4XpRSS+7HdNj8=
Date: Wed, 14 Oct 2026 17:14:30 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch added to mm-unstable branch
Message-Id: <20261015001431.3B0201F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: don't count per-node proactive reclaim as memory pressure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: vmscan: don't count per-node proactive reclaim as memory pressure
Date: Mon, 12 Oct 2026 10:29:17 +0800

When the cgroup has no memory pressure at all, writing to
/sys/devices/system/nodeX/reclaim triggers proactive reclaim on
NUMA node, causing increase in the writer cgroup's memory PSI.

Due to this reclaim is performed in the context of the write(),
accounted as memory pressure on the writer, like
commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
as memory pressure"). This is unexpected, the similar scenarios (e.g.
senpai) will continue to occur, only this time it is for the
/sys/devices/system/nodeX/reclaim knob.

The Documentation/ABI/stable/sysfs-devices-node documentation also
notes that "This interface is equivalent to the memcg variant."

This patch unifies the semantics of the memcg and node interfaces:
per-node proactive reclaim is no longer counted as memory pressure,
and the per-node proactive reclaim interface no longer produces
phantom pressure.

I ran demo[1] that performs per-node proactive reclaim 10000 times
in qemu, writer cgroup memory.pressure as follows:

without patch:

some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985

with patch:

some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221


Link: https://lore.kernel.org/20261012022917.1102467-1-vernon2gm@gmail.com
Link: https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure
+++ a/mm/vmscan.c
@@ -7998,7 +7998,8 @@ static unsigned long __node_reclaim(stru
 					   sc->gfp_mask);
 
 	cond_resched();
-	psi_memstall_enter(&pflags);
+	if (!sc->proactive)
+		psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
 	fs_reclaim_acquire(sc->gfp_mask);
 	/*
@@ -8015,7 +8016,8 @@ static unsigned long __node_reclaim(stru
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
-	psi_memstall_leave(&pflags);
+	if (!sc->proactive)
+		psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch

