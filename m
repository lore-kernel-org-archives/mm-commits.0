Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BBC176FCE
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729985279; cv=none; b=d2IPcEimsWhrlz3/Um0Zw2nOFapCL50sltrESOOHfVuPw979s+yupYLtv8hZFMkha0f4LwMW7aWe1eeA8eiXRDrq90Vj+rwdHTiZF73+MdrKLNTLuIOr1KDwwEw+ayIFeFQL4l2ev9OuZ6jtt1AKF8Ixk8jldTI4HCtTdJk7cSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729985279; c=relaxed/simple;
	bh=KbwqKA+w7hmFp3j76GRv5DScvenJPODX5vyoNuGtmcM=;
	h=Date:To:From:Subject:Message-Id; b=khyfWtX5z9VKM4v4kNbZ5kU4gT2HmQ1U+TZfpPojeZbMMTpS3gdkMbQbwzvVha0CWMSLNey/jPHFM2oLCi8qd8BVNiCI770e0RCINH0IhXdoLTX1VhCpy6h2r6kN9BKfH6KYdBclA3J0p9enF4PJ1ccId3HL2maavpXKguCMcMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYreI8uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYreI8uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E10EC4CEC6;
	Sat, 26 Oct 2024 23:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729985278;
	bh=KbwqKA+w7hmFp3j76GRv5DScvenJPODX5vyoNuGtmcM=;
	h=Date:To:From:Subject:From;
	b=dYreI8ucsng/0NXqwSZEugOnZN6bzXDvFJcbBKyePD+2+WS2kvloK9dKLV0d/xMV5
	 x8hGBrlKryAqgTmwL4TgfF9pX+y/2Ci6HCOpF/vdDMo1zVC9vbgDweKVjZjkwAIXXR
	 CC88vOLTCc05Q2lIdd8ctZ4J132FkKqgkndlwuL0=
Date: Sat, 26 Oct 2024 16:27:57 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch added to mm-unstable branch
Message-Id: <20241026232758.5E10EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
Date: Fri, 25 Oct 2024 23:34:34 -0700

folio_rcu() fixup, per Yu Zhao

Link: https://lkml.kernel.org/r/iwmabnye3nl4merealrawt3bdvfii2pwavwrddrqpraoveet7h@ezrsdhjwwej7
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
+++ a/mm/vmscan.c
@@ -3353,7 +3353,7 @@ static struct folio *get_pfn_folio(unsig
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
-	if (folio_memcg_rcu(folio) != memcg)
+	if (folio_memcg(folio) != memcg)
 		return NULL;
 
 	/* file VMAs can contain anon pages from COW */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch
memcg-v1-remove-memcg-move-locking-code.patch
memcg-workingset-remove-folio_memcg_rcu-usage.patch

