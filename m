Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E293A1DA
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720823826; cv=none; b=Bssa4nShpesGTNDEiVyzxQRbNxGZFBOi/mjyTPPwpKOBqgd0oxzhEwYyoZQaXoOpfNFrOXZ17PTkBHMgspYVy3j8Rfyd2SzApbQ0SuzViSkYqItF3n9Xq5643ZQ3K0zsxEfxcbo6aBtj2pOWBt7EsY1ul8runru7Iy2SmBQpROM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720823826; c=relaxed/simple;
	bh=6zd/rtt2ZxwJzKJ/Rm6k3c+WnR+e7PMZgIerVcmhTJk=;
	h=Date:To:From:Subject:Message-Id; b=iaE2LVUj9r44fS2nvvv3tFScQRVkHIbx1sbrVWAdtpwAz3pNzxEKOsHI5ONcr+fx/T+WMSq/PcnGLwU5zSj3IwqnkpPWgMVYf25D33Wfkw62lHcAF1u2vKU1i9ehzB9ucfZNwH5JqasRaje8XEflYGPZNq3rPvMkpYRKC6YJmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGNOOG+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGNOOG+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D081C32782;
	Fri, 12 Jul 2024 22:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720823826;
	bh=6zd/rtt2ZxwJzKJ/Rm6k3c+WnR+e7PMZgIerVcmhTJk=;
	h=Date:To:From:Subject:From;
	b=ZGNOOG+kZCWAv2710X1rsLXzW2mkAAOJlB8e5R5Xi+JunE5MQP1bqorWiF4vwsBKg
	 Dw9EGKHqAvkvlGqEbbxmQMUWLieZnLKIi6p2lKMClCCxjr8vhJLy12rbJTOFrUYcpU
	 pv2vTkWkaWVhoGGdxoGapy7e3z52v7XnihfVnMBs=
Date: Fri, 12 Jul 2024 15:37:05 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,quic_jjohnson@quicinc.com,mhocko@suse.com,maarten.lankhorst@linux.intel.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch added to mm-unstable branch
Message-Id: <20240712223706.1D081C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_counter-move-calculating-protection-values-to-page_counter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch
mm-migrate-putback-split-folios-when-numa-hint-migration-fails-fix.patch

