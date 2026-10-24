Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832507;
	b=YFNXFnkJLWdyPUfg5Gom0FRX7SRenYhT41kWiiYSQ7heoB55qncyNETC9ChpavmUM4aO
	 87qU3IzTPxiJdxPHdXdUOsePqF1r503artzG7VsmIOvkDqRcnRh3i/h1yXqk0QKk/AeNr
	 TEo/5Xk4LvDDJPEZU/U9BIXWGTmUwaRVU6SHwD8k0RVOChJinqfNRbQkBCAoEt9VYJwZY
	 Ic3C0hBTjJIGX7dB38bqhTYdVBjYxxKxRTG/RtDBCBbCr/uVtscGh4t6SzMtZS2UpyrQa
	 iLF9T+XOfK2cBxdc2+iNYTElPuGB8Q8SL1TQIqLEVIBw4JWOHmcbzuUjoKUdmzR4OVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832507;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cr4Uq+2sVP1fxSWdSjcQ7CkBD2YSBorvt9Ks5g5np/0=;
	b=05LSIkYPO/qkBvL+3/j6FEr9tIGvUrwYA8mTMsReRobCJsIkELyHmhSXUNtwvDBjGkPk
	 z2CCnyANvQnQLGGe3f4wCTAOkjRcz3oNl5Mtq1C8z5Z9ZIWCpo+FxUeO9G1z5YU09IOoq
	 hyhy0SUbHKZ58K8moB9dJYbLUw1/UnQHn0hRI7XRozG4AdkAWCXLbKDliVIfUdIiOJWXa
	 mnxZ3ERnA32HP71w2b8YgdtgSIMxBWo80pUWEDLcE3RdoQCf//ZcMKS1y76ABInlKiK2h
	 6/5By70EycFpmeA7b3sb4+QQf5Bf3gSGo+/8QvJfWIK/43PStvCOF43trO5rttuGWfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="NX/HWkdi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B76606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NX/HWkdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5701F01825;
	Sat, 24 Oct 2026 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832507;
	bh=cr4Uq+2sVP1fxSWdSjcQ7CkBD2YSBorvt9Ks5g5np/0=;
	h=Date:To:From:Subject;
	b=NX/HWkdi2ngw7bAOea4c7xqG10dsmD4lZQBSVYsp+xmjbYV55gmAGqhlBPFuLNQUJ
	 Q8rO5a5pjtCHrY+3jhycHQDHWEmmXJWba9sW0KsZApEJfzBiJJBuGuBWF9aAQ+p9U2
	 fSi2BGNbDJjJSGRg8WRWpFpb7CDSbPHsntuEXkpg=
Date: Sat, 24 Oct 2026 02:01:46 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch removed from -mm tree
Message-Id: <20261024090147.3D5701F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Wed, 14 Oct 2026 17:00:23 +0800

MGLRU evict_folios() isolates folios from the LRU without updating the
NR_ISOLATED_ANON/FILE counters, unlike the legacy shrink_inactive_list()
path.  This causes compaction's too_many_isolated() check to under-count
isolated pages when MGLRU reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using the
existing nr_isolated which holds the original isolated count.

Link: https://lore.kernel.org/141901355a7d9e4bbca5c4840ae32ea5c65fe3b6.1791968227.git.zhuhui@kylinos.cn
Link: https://lore.kernel.org/cover.1791968227.git.zhuhui@kylinos.cn
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path
+++ a/mm/vmscan.c
@@ -5081,6 +5081,9 @@ static int evict_folios(unsigned long nr
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -5149,6 +5152,8 @@ retry:
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


