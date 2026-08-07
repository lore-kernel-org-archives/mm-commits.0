Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D83603C0
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068102; cv=none; b=quWhwxId/f6sTeMYD1sI54q7xX7plPAnh+plQnzzJLMS37+uOgil/PrmZe3sPEsly8J98XKD3ejp1V4M+um0Kwp+20aKJxjw8AG/OLDFla07RBX0Xhp9p68+ZreJX152sruIKJj7eSu0IgkS29O54vobxgVbVxlODhekTl1A8EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068102; c=relaxed/simple;
	bh=Ar87IKexYkanw+xX8ngHXma5MwpUN5MKHDMBrELjBT8=;
	h=Date:To:From:Subject:Message-Id; b=liUz/t93o2tOfOKjLxHWNsJEaj+YCnhNkAVRsVnbmv7Z1ZKbDvIlZR3Zf6GJUHZ01YPj4Wz+apDDGUbTCRXj9ffPi/+mobLpdyiFSZOTHIxE6SQOfiL404eJ/3CPj/i9zip0lTyrx1uKt5N6fiG3Vbg/hSSLoAZnOKEdo5JgXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xF966lkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xF966lkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F269F1F000E9;
	Fri,  7 Aug 2026 02:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068101;
	bh=tuURAgdjKSWNSvALn6RjXp4VVMfHlcF7JUqg2vRDhsI=;
	h=Date:To:From:Subject;
	b=xF966lkTnmfZ0NrlPisgusEqf/Ikba4wdp99MgpXmoT7iliR0zXdK7siHtWqJy3Pf
	 qWpMbyTLP6RAOYzhW547+2Z/PQ2VCwfRZiies6mo27x23j/nR8eAN9Qv7PVe9jaDFK
	 9q7ckSDQgm/ltvpZk+1hbs/n0fOwQA0BEvb6p3NQ=
Date: Thu, 06 Aug 2026 19:01:40 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch removed from -mm tree
Message-Id: <20260807020140.F269F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim
+++ a/mm/vmscan.c
@@ -8026,7 +8026,7 @@ static ssize_t reclaim_store(struct devi
 	int ret, nid = dev->id;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
-	return ret ? -EAGAIN : count;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_WO(reclaim);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

