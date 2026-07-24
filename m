Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216A37A848
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871481; cv=none; b=k1/QZVgKzD/oG2SBCoYohEGGNmbwjJZgiD5Y2PCsT3B+/KIJukoHxvCQZ1eUduOqZLMWVYbWtQ/qV7X5j1JctHHObDwpgZU42LfvNTj3DI39qHRdfTW6jo1p4m5+hIexjbU3jksxNbmCR3YoNZiRnfXWPwlHhRu9mJ4MhV8a1Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871481; c=relaxed/simple;
	bh=RTtEFb+JykjMoukUqwmTRG4JYKL3w6vV7OY9u3bs95g=;
	h=Date:To:From:Subject:Message-Id; b=Pt2r1jEJ42hTjJ7QwbxXDRMr6emO0qd1hSCKNK5tUb2xyicFS2glbR1LnhtkON2rmbRmtMZoMXBTrY5NeRivhb6nraBN3gJTbvW1eyrzNKHOfuT7Zcbbyf+HBMV+kb0wjoEboqd0dmB1HopYXQO4hiAvuiEyafF+oQhGgvaBCx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9x1QGL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9x1QGL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D4E1F000E9;
	Fri, 24 Jul 2026 05:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784871479;
	bh=+CwJbBs7DzW34L2MKZrRdaqJsqxS7FbaY1zxk/Qm9qM=;
	h=Date:To:From:Subject;
	b=T9x1QGL/MEHsGxNmouE2WwRC8NaDZOXRdnINNVy2OK1ZGnwQD6qvfMEZJ51Y459ra
	 z3y8ynOfYfW0ogGBZbExiTYA5jis/PlAOxtnTxj6Mn8zfQtzGImDM7vDQ26SmngEuM
	 D0DScLEn2aQ95i+YcKPgQkwUPkuaWaVsVI08Col8=
Date: Thu, 23 Jul 2026 22:37:59 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch added to mm-unstable branch
Message-Id: <20260724053759.86D4E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
Date: Fri, 24 Jul 2026 11:34:33 +0800

It has been observed that per-node proactive reclaim always returns
-EAGAIN when any error occurs.  As discussed in the mailing list [1], the
interface should distinguish between cases where no reclaimable memory is
left and where another entity is concurrently using the same interface. 
Propagate the real error code, consistent with how memcg proactive reclaim
handles errors.

Link: https://lore.kernel.org/20260724033435.2573323-3-ridong.chen@linux.dev
Link: https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim
+++ a/mm/vmscan.c
@@ -8024,7 +8024,7 @@ static ssize_t reclaim_store(struct devi
 	int ret, nid = dev->id;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
-	return ret ? -EAGAIN : count;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_WO(reclaim);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch
mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

