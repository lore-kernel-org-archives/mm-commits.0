Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC81258CFA
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877926; cv=none; b=jdC9ndhWSDA72ma1zCZxniwuOg38ZyQZWy74QLV8ljiTo3wrwETFvxSkCgzKx+ypLqUw0I3D5MlWs6NhlBS/kkuOkgtagUnGBnwfHEoh7g/DXeE0ijfFW/1LhNQZLx2MgrPegx0cxRCMx9A5BBNywrVw5ozUhMhP/D6ILrWC2Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877926; c=relaxed/simple;
	bh=g4vrDd6MNCnjNXLa+9+CAj1Hf2ptbU6+7kLXoghrJQo=;
	h=Date:To:From:Subject:Message-Id; b=MUqtuJjMuEFKTtaGdi2KvI2IJeNRbAVYKz6CM3LR8txmZuNQ36Hzom2Xdtki7nPlcEEdFenGL1JWcydB3bnp+7NWwS41WUulP6iVD4qoou1TwLXx14baKIUqb5wk15d6V5S9yMJOi5+AfDDGANZA71qxLH5iuruBpWEMgD4710o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BcT2itGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BcT2itGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62366C4CEF1;
	Tue,  7 Oct 2025 22:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759877925;
	bh=g4vrDd6MNCnjNXLa+9+CAj1Hf2ptbU6+7kLXoghrJQo=;
	h=Date:To:From:Subject:From;
	b=BcT2itGlUKpFYLotNu5sPPYVwzrYrbWYq5pDalxHTN2ARvIFMfx6q08KB4xq8aiwy
	 KobsqtS2fyvMbhR3lGWlCADnY5Im4FOsSSZum8sNrWUmoew79JyPxEUpVKoIlPdCQr
	 j1xVx8lKgKJhyZYfdehABduAdffX20BuTQM//8Lk=
Date: Tue, 07 Oct 2025 15:58:44 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-redundant-__gfp_nowarn.patch added to mm-new branch
Message-Id: <20251007225845.62366C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: remove redundant __GFP_NOWARN
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-remove-redundant-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-redundant-__gfp_nowarn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
@@ -1032,7 +1032,7 @@ static unsigned int demote_folio_list(st
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

mm-vmscan-remove-redundant-__gfp_nowarn.patch

