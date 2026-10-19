Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792444744;
	b=nUFbngOt/ky4XFQahqWV+SVf8wTnZTN5ELsaHjr7vj/YOmb91JRHGSd7Y7UFQQpgRasC
	 g7POhJ/K1+SYioZplFhbib2I/lqGehROgscXtvKpZWkqPcZV/G/8fKBUgMtLHFaN6wsYJ
	 SZuewJoY/69m4SdMQv5TNNNBr4cJkhfU5Jv2UT1QbviEOrA+ot5CXRZjT0xwo+mYlhFxV
	 hUS/f4+d6SqFt7HdYE9jZa/FvefmyJgh37SQgiAVo7G74GgFD3lnHwgQZvOKon4YcusR4
	 OK+LM+FTPT7dVTNuaA2X2szgIQoLPL4Uid6gb4IJX7O8yC4myZUOL2kzVNnMmr2tCMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792444744;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xh41lh1kvknW52XJBgJ0zeRzfch/nnYuyiDuJxdWWxY=;
	b=kSu0qNm3MsQ/nPkc8r6GXUnXZiR9QrbIGG9cxn8LTCVdAHRG/K29Sb6j0DXZsIPLFcz2
	 Ug9W6aRrXPX5ORkUyhRijf7xjvpUj0eQjsxF50P+zaOojZ3MOfcfB97hBU8yFK7vjIQZr
	 CnOyDd/7daSJ7MByHg/uWmo79e0SCwjCTfSpyDdTDZHG1kszsSV/x0K5eirzAzoVh1VFX
	 kkXuVowiJga4xXwuuIVr7jIBgux3TMC/Q0uqFQI67lNRN1xEB1bH4Suln60HzXgjPPtCu
	 GT5fWWhGjJrjkwFuTlPeQTegt1n+3xoE257+he4lbV6Vpavcr+BwKC+7b3yKQaRzzaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PB5J2HyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBC2606A319;
	Mon, 19 Oct 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PB5J2HyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF61F000C5;
	Mon, 19 Oct 2026 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792444743;
	bh=xh41lh1kvknW52XJBgJ0zeRzfch/nnYuyiDuJxdWWxY=;
	h=Date:To:From:Subject;
	b=PB5J2HyBBG35Az70zTneynSfZeFSS5qjglvdJMQEhF0JiuEmoaTC2E3oX9Bnml00a
	 +PBGRd5Zhfu2Ts5m1jV++vmgDKhuFNnj/5YnCqGbXQxloYLuwPXUf080D2mDOAJ/eD
	 LU9o0um6hQJBsDlTWQIlzEyMpAm77I+CY9b0d07E=
Date: Mon, 19 Oct 2026 14:19:02 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch added to mm-unstable branch
Message-Id: <20261019211903.5EFF61F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmscan: reclaim every zone in per-node proactive reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch

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
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
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

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch
mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch

