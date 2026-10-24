Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832509;
	b=EyFe+sKU8eLMr/xoLeRHVoAqfOFOrJD5z1LQmKMZtkN+b9bokZlckaFnBrJmfHMhc+5p
	 iISo6oLzVhNBgzdFRlD9Cwd8MntbZTjYZ1lyZRf3SJv37UEgKpb+KY6JIfko5Z/L/TK+w
	 cpH+aP/JVu5+xGmFV1R/t0kMHtegV8mvE4cJ5Oy9zRpTHESHTwPJKDKzJDoIxdxuGf/+x
	 bpLUasz3RfnnYwsdZRgiJZyicNPec5jDPs2RlTJfq1ywUIcAcI+YUISSlZSJBBdOhBwc3
	 CkEUzywnKWZEF4RAZB2kT5b8CUsWnpeljih6Vhdd9aiJXz5L2Ywnn9YWh1FqMvLTSiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832509;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eHjkpEr9oLlcclPn1thOraO4+8omjU4rLZkEzk9l+nE=;
	b=vgX7zYWQGkZMPENfoQMbjm5D6WGeqkCqPNDV8KqeL5lCgC2dk5CwwRq39EeWDL+wckRv
	 XYwMpyJxxMxcSuhYbZg2u99vFtQRlFPzmn8dMsJejKcyk6LVAIEzAA5D9RANItLsQcKmf
	 Dr+T6/2XXNWVsEuUhzBIx7bP59kGsIWYr3qTZqiUhbCJ2mc2plxzO5bCmrpa6fgt0zVwK
	 SeOaVpaOrBp0QH+4C5iOieOkX3ACPev+BoN1HCHxDaXDBKHGNvgt7NFZgkC/DvenEzOJ7
	 H+axebypB/zmbmB/7SA6qUgzV6l5EyQJZN4hwAXZiYRQ24LG9VISnsRH2mSXwTj9/og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CucWtMqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC8606A322;
	Sat, 24 Oct 2026 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CucWtMqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556541F01825;
	Sat, 24 Oct 2026 09:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832509;
	bh=eHjkpEr9oLlcclPn1thOraO4+8omjU4rLZkEzk9l+nE=;
	h=Date:To:From:Subject;
	b=CucWtMqVgipwE1vW2WtIdXEaF/9S6oS2QDjkBa50BLW6k6P/esxGB3guXpfxutXmW
	 aYU930sSzS9yj5plnP3p9TMaWQYrNIFMvbBmDw64SQEgtaNtF8T2BeIORuUGIhe6NC
	 6bKJMbyuCbwG1Qw2eBtXET4a2qdY1IoPbT8a/L+0=
Date: Sat, 24 Oct 2026 02:01:48 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch removed from -mm tree
Message-Id: <20261024090149.556541F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: vmscan: don't count per-node proactive reclaim as memory pressure
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-count-per-node-proactive-reclaim-as-memory-pressure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
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


