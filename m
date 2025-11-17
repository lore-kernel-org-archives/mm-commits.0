Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C381F4262
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343097; cv=none; b=Xmn+eKjcwkAFK4LqiQleENqtIO8B2L4Q5AevemL7AVngEEPNeZZYdvGQiNIZ7xeWjaou+CHl5scQ3YjIIh5TUwhGdIWFHLsubMbhAMqCFfgM08ifi2oeIaa+XjbNaSgjSLp8VvStaOBL1WjBcp0l70wwl7JlZD1Pc3uLb+ZmsT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343097; c=relaxed/simple;
	bh=TGdDOUs7LePr98+sa1jecvn5cssjHPVrAXiFtoTU8yg=;
	h=Date:To:From:Subject:Message-Id; b=nhIIw98IerUxoeVqsZ65iqtF2TSqJ923iEqNBXKQvihaLSO+sCC37LLt/Qd2LTZLRHynPPSVEPjLvROkM0rX3olUbqcYHpV0apR5H9OM3Dan5I3pdQ6Q1wJnn9e5L1ETMHMN5bFs71nlE4WqVRa/ekxudp3PAuuhw4LY6kMAGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYH2WgqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYH2WgqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289E0C116D0;
	Mon, 17 Nov 2025 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343097;
	bh=TGdDOUs7LePr98+sa1jecvn5cssjHPVrAXiFtoTU8yg=;
	h=Date:To:From:Subject:From;
	b=EYH2WgqVQbDhxsgzWHAG89jdXIfPI+0kahpMseShtl4IYN8wW2mfW1NVmsQhkeuEo
	 baAM1oIQRctYAHqEym1Ybzu8N4FRdcc57sQ7g9DMeEZFUB+JotzA9aigTKiVjxNG0f
	 ANNGV5Wcav6y1U/A7FcYeh3V/FcgTOVZk4j3JXVs=
Date: Sun, 16 Nov 2025 17:31:36 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-redundant-__gfp_nowarn.patch removed from -mm tree
Message-Id: <20251117013137.289E0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove redundant __GFP_NOWARN
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-redundant-__gfp_nowarn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fushuai Wang <wangfushuai@baidu.com>
Subject: mm/vmscan: remove redundant __GFP_NOWARN
Date: Mon, 6 Oct 2025 09:49:48 +0800

The __GFP_NOWARN flag was included in GFP_NOWAIT since commit 16f5dfbc851b
("gfp: include __GFP_NOWARN in GFP_NOWAIT").  So remove the redundant
__GFP_NOWARN flag.

Link: https://lkml.kernel.org/r/20251006014948.44695-1-wangfushuai@baidu.com
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-remove-redundant-__gfp_nowarn
+++ a/mm/vmscan.c
@@ -1054,7 +1054,7 @@ static unsigned int demote_folio_list(st
 		 * When this happens, 'page' will likely just be discarded
 		 * instead of migrated.
 		 */
-		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
 		.nmask = &allowed_mask,
_

Patches currently in -mm which might be from wangfushuai@baidu.com are


