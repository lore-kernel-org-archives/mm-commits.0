Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA23BCD04
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439194; cv=none; b=oifya0EZYc86uqbZzysOEL5qMsX+TpFR0drWR3bMbbRH7z3fba+9OSwQCoHL2ug3FkCeVKmaoRDx3axoecsV2VhQy1Yg7Y5QXu1m7oY6f2vWQl3/kXct99LCAxouyRyODZ2GFVCVIBae4Ujj07ZJw3Qafxa0XriiB4iN0fskqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439194; c=relaxed/simple;
	bh=IvnfivkJO/whPyibiCDyO/5aOm4iEDwYz2j7B4LXY2U=;
	h=Date:To:From:Subject:Message-Id; b=m71XHxu7pN/heUTsU6WeWPWG2EYObnqoAXv3PzWbfN7SC7G1Zxk/50EwfLR6CMKzflBqNu6JP3ah0PUYNrW14EBQzYM6vapYI2tFSJMZ4r3mpBuQXEdbRbhDFwtY2ep5sgfrVpSM2xJ3dL7LdYPO5ZReHYygXhymw0wqueDrWnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f3Bn+Teb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f3Bn+Teb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A777A1F00893;
	Tue,  2 Jun 2026 22:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439193;
	bh=+868oK1ofwB1CqnOC3faI8oGkAI2O6ySLhNCMngFyes=;
	h=Date:To:From:Subject;
	b=f3Bn+Teb5xIZkpejSvu1h/FZrCxNfR4EY3EpEY94JGC2zqKsOqD3XeDYnn2SswFAD
	 vpUve+SZJPB4m3v4TtWDD1IcA7hTI55IhKKnaQf0B16CgAQcggsn/47TfaOXoBLQuP
	 5ZBRgRhcuXNz4Z2q1DFms9Iyd1QlbdCmfJmfvduc=
Date: Tue, 02 Jun 2026 15:26:33 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-sc-file_taken.patch removed from -mm tree
Message-Id: <20260602222633.A777A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove sc->file_taken
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-sc-file_taken.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: remove sc->file_taken
Date: Tue, 28 Apr 2026 02:07:04 +0800

No one is using it now, just remove it.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-13-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-sc-file_taken
+++ a/mm/vmscan.c
@@ -173,7 +173,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2044,8 +2043,6 @@ static unsigned long shrink_inactive_lis
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
_

Patches currently in -mm which might be from kasong@tencent.com are


