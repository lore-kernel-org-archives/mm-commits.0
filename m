Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832536;
	b=QV2nkHNTrZg1Wi2SKmdCJsSMeBf/14RUrnbyPO2qrCqCrdgQwa9maereE+IKIzPpZ1PT
	 yBheEHUBJWFiHvBzuURZ/lSqHCwEvYdC6H+FBprazNJcOfkUfIdQvo2UIULe8HMxb8Et1
	 gW7wzWnsB5VtNWm4Ekj5UJbR1tLEGaA2qoSZ79EqBT0/M0LZ8sWCbcsDue7maG8LuFlBe
	 9WLjBU8RVDYISEXVxoAptXXdIfGVo/qCS5dXgGVG1a/TicmmLYSSZmTd/boaItTckDYr+
	 s14JzQTFPMEalehtQ1yYMOJGKSST9qEunaImDgG7r/VkMNPK35gfVPkBoBf7EGTdQdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832536;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=t1ZF/cMTKV8qZUMFwsn2fVP6Iwax8aFWWy75lCTv0HY=;
	b=irCHx+pWIEnIRoAEyR4pOaHyacCg6fiACwO7E9esbeS2XwUwKeN4Dl/219pxvHzkIv+6
	 2Q7bmPbGVuvDMKjIgdLB6u8dFAPS2lq243xLx6JjVyxdQr5szz5bZR0T8Nhd7JgG7wi5f
	 UX9vvnvQwXpJFiIRB69uUJ68yFW5OhcjzEcvtoNswdC2OpIitP1/ZiIq4qm4+0FOV1GYd
	 wvMTEI4mKXispB5IvcvzvRjh5BqQ6qVhpDECA+SBMtf+nj+640GXwOhrotkjgHOLUe5w9
	 xcYR0+Csohxf3EgrNUq5iynNmOjxEn6gNyPpSYUFH3SEE02hBcVxvfidJIA/n+03xag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Jxiv/hGv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AB9606A320;
	Sat, 24 Oct 2026 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jxiv/hGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4381F01825;
	Sat, 24 Oct 2026 09:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832535;
	bh=t1ZF/cMTKV8qZUMFwsn2fVP6Iwax8aFWWy75lCTv0HY=;
	h=Date:To:From:Subject;
	b=Jxiv/hGvovj4gCFOJzeJNEAQsJim8WEUikSY5fmldcHH2/9o0dsJpb6jMmwpCb8bp
	 BElH8gEQkfuGmNottQFPQNDtOWG3og2ZElmzg6gqR+1w23TsnGpJtfqmLlMzF3324A
	 3N/d2MYbVlMhn4Bv6d6It2Kj9HURKxgKuaJ5h+LI=
Date: Sat, 24 Oct 2026 02:02:15 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yosry@kernel.org,xueyuan.chen21@gmail.com,weixugc@google.com,vishal.moola@gmail.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,axelrasmussen@google.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch removed from -mm tree
Message-Id: <20261024090215.AD4381F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmscan: reclaim every zone in per-node proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Mon, 19 Oct 2026 14:50:02 -0400

user_proactive_reclaim() limits per-node reclaim to
gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
folio, so writing to /sys/devices/system/node/nodeN/reclaim never
reclaims a node's movable memory. A movable-only node, such as dax/kmem
or hotplugged memory onlined movable, reclaims nothing and fails with
-EAGAIN.

To reproduce, fill a movable-only node with clean page cache and write
200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
cache stays. The same write to a ZONE_NORMAL node frees 200MB.

Scan every zone, as memory.reclaim does.

Link: https://lore.kernel.org/20261019185002.3428594-1-gourry@gourry.net
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim
+++ a/mm/vmscan.c
@@ -8185,7 +8185,7 @@ int user_proactive_reclaim(char *buf,
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-				.reclaim_idx = gfp_zone(gfp_mask),
+				.reclaim_idx = MAX_NR_ZONES - 1,
 				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
 				.priority = DEF_PRIORITY,
 				.may_writepage = 1,
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

