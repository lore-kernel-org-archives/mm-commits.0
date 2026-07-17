Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62643F08B
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784318023; cv=none; b=aTb9iMVRuOCVbT7FG5XlyoPF5f6PHiJWnZJYAChInV2MSj1az/vHm3moG3BgwvJHhiwWpjoX2VzQ07FyY6nm4CKxcV6saMgh/WQh1oxAEeq6FBxW27lZDXa0Hx7A1Y8mVBX+T1i2lmfjapB2G6NCjTeoM+btqKH/e1G0CA3eZp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784318023; c=relaxed/simple;
	bh=wqznOiKIrV6q5Hf0/Qk0STc9CaRlc86+2JSSet0L/JI=;
	h=Date:To:From:Subject:Message-Id; b=rIOZzproij2qKUfDglVOn7GezaEITv6lzcYLCUS5cEIzYbmKTDdSZLTk3n6/TnnDd/c3K1BLyJRpn0eePzDxZSdKjeqYPGt45UZqabg/GADmz8Q5M6rJkvp/OtiVZIVYdZjvtVSt+AIVxcvlyFU6mNagIwdgJf64tn1gm0vUeOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wemWQuSS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wemWQuSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B611F000E9;
	Fri, 17 Jul 2026 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784318021;
	bh=VZyH1g+sx9UOASoRFBx7WN+m0TXbfKafRDNKQ6UbiuU=;
	h=Date:To:From:Subject;
	b=wemWQuSSccqxJtKraQ7b9sy9SbGjzWUmMKsMvIXE0h+x7LgyRiMYNYc1hZUcjBJzc
	 YOltsVAjUaaFN0pZh2MNJFf8tH66KxPNtKMpcZUHHnrnO1QgOJ0fHyz56QZyD0OkFh
	 1odxNV3zPtNJg4Fka8XJABB5tcBYofXN/phnl25I=
Date: Fri, 17 Jul 2026 12:53:41 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch added to mm-new branch
Message-Id: <20260717195341.70B611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Fri, 17 Jul 2026 19:32:59 +0800

It has been observed that per-node proactive reclaim always returns
-EAGAIN when any error occurs.  As discussed in the mailing list [1], the
interface should distinguish between cases where no reclaimable memory is
left and where another entity is concurrently using the same interface. 
Propagate the real error code, consistent with how memcg proactive reclaim
handles errors.

Link: https://lore.kernel.org/20260717113300.214717-3-ridong.chen@linux.dev
Link: https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
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
@@ -8008,7 +8008,7 @@ static ssize_t reclaim_store(struct devi
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

