Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5F3E866B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313503; cv=none; b=MUyL572utyNcPGq/3RWeB68xCDpc5Kt8GTUU3+7tmo3ymMyDknOjIH8J9mDUEkp+dldOhHH0ZIApCavHUTVCTbyrX46OBHZ5ZIVcgXq15Ro2Jb5G2zcbx9w8GqtKnnCaeOdLPnNbzsgSNiRtR5GNOKp4wKKwrrBeVj5mi518Dz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313503; c=relaxed/simple;
	bh=4jTBh5iKioEnqf3sN7CY+PV/zIYWgCWA0E8vt1G6qXw=;
	h=Date:To:From:Subject:Message-Id; b=ZL2+6DvO3OipheexbxJxEAVVDPLonrWE2SVjm7d+rISQ8W4+WrwGJ56EfCJx0h9ms/w0fPSS3MMZR3IwQ46TBlODp+TjM+w/PKrlMVyTNbMbtNet2WTJPFPRIzuvb7CottEEXhLEbZio+1rNkjHBHUrNh8WjzNgUcQxmM5Rb1F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNFI0JJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNFI0JJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F9C19425;
	Mon, 27 Apr 2026 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313503;
	bh=4jTBh5iKioEnqf3sN7CY+PV/zIYWgCWA0E8vt1G6qXw=;
	h=Date:To:From:Subject:From;
	b=gNFI0JJP0kUc+x5mcXx9G+TSEepxU660y0mygJOSxDsZRf5vsMa2z5lMO9gnd1SKV
	 kzg5beCbYdxWoge9gc7gmr7citxXrQdRoHOH1n8mQKd9rUWRaGXZiTas6uSt8LwBNQ
	 QZaskZjFzoCY4KfijdubOiXakU6+j5mIZNcHfVXM=
Date: Mon, 27 Apr 2026 11:11:42 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-remove-sc-unqueued_dirty.patch removed from -mm tree
Message-Id: <20260427181143.6F7F9C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove sc->unqueued_dirty
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-sc-unqueued_dirty.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: remove sc->unqueued_dirty
Date: Fri, 24 Apr 2026 01:43:24 +0800

No one is using it now, just remove it.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-13-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-sc-unqueued_dirty
+++ a/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_lis
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

