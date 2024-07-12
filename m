Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832DC5BACF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824428; cv=none; b=AA7guXH/Y60iNsLwlfxWt8uXVKDM+nc5EsUbXcj0KTxVSHWurOcr8KljpqIEYZxn9KjXFmLR1ly1fsW48VuXs2ucMnRPVPjTEw5tASaK8sfh9hra8+3UuqXVtNfrbo9Vk50tCwNhINFlaqCpMSTZjuqWkO7+d+pX6soWSGSd6w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824428; c=relaxed/simple;
	bh=wKYbX980dDMRH+8kGZ/sBdKulvPLx6wOVsZiip45/a4=;
	h=Date:To:From:Subject:Message-Id; b=QWhkMchMtbwdPBBCkKgP97boHNreyPacXoC/VFi4AuDqOPZfk2eMztqYurbFFwLpdVx8SzhndOR0kNmaVQWXYI9pyHWSYy0D0a75axARtOePB5eUwUezkela7yqT5v66ushlk1FFte33l328oEKwUxj/GONQBmrIBmx+Prqt/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fxly0hCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fxly0hCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F5FC32782;
	Fri, 12 Jul 2024 22:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824428;
	bh=wKYbX980dDMRH+8kGZ/sBdKulvPLx6wOVsZiip45/a4=;
	h=Date:To:From:Subject:From;
	b=Fxly0hCutGRceIcPbhlIohWDYvmYbggfPLKGjgWOfkFm7w+RSuntMrF121TJeLWw5
	 eESJr1ScVQSbLXJRam347MlzHAylgzzR5ECQnPggL7wfI8YTvv72y8uSrITSzYeHua
	 ImeSTEQevjDdLfzS19UiLBli5WQ8BzXYZx9YA0n0=
Date: Fri, 12 Jul 2024 15:47:07 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,quic_jjohnson@quicinc.com,mhocko@suse.com,maarten.lankhorst@linux.intel.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch removed from -mm tree
Message-Id: <20240712224708.55F5FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_counter-move-calculating-protection-values-to-page_counter-fix
has been removed from the -mm tree.  Its filename was
     mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch

This patch was dropped because it was folded into mm-page_counter-move-calculating-protection-values-to-page_counter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_counter-move-calculating-protection-values-to-page_counter-fix
Date: Fri Jul 12 03:34:32 PM PDT 2024

fix kerneldoc, per Jeff Johnson

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-move-calculating-protection-values-to-page_counter-fix
+++ a/mm/page_counter.c
@@ -386,7 +386,7 @@ static unsigned long effective_protectio
 /**
  * page_counter_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
- * @memcg: the memory cgroup to check
+ * @counter: the page_counter the counter to update
  * @recursive_protection: Whether to use memory_recursiveprot behavior.
  *
  * Calculates elow/emin thresholds for given page_counter.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlbc-undo-errant-change.patch
mm-page_counter-move-calculating-protection-values-to-page_counter.patch
mm-migrate-putback-split-folios-when-numa-hint-migration-fails-fix.patch

