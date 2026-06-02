Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E313B961A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439045; cv=none; b=ab5oss+WPj3zqrPktuUsDtLj2AMTD3R/VTA/DO46KdyHoDYy9P35PHo3zroYulAD6ZAt9Oq9k0hd/5CqzRhtuZpZUUlt3KiONrnK17dEIgFAHxq2WrKLs+Vwkvi0kLSGCzgAXSnrO9GAHmeisjU5gf8ue9Cq58dFUW85dgnMQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439045; c=relaxed/simple;
	bh=boC2DQpDw/EOz0E+9NMO0XBYuhZAWg+sfjNrsfp1VtY=;
	h=Date:To:From:Subject:Message-Id; b=APSaARobZ7lZhA4ECneITb6gIWfzuS+z5fGOaQQmX7/z794RMiPVlF/RcyQufz//iylXtL9DHq2hkBsoL/EuA5TNzqYdJAuSvmdDlUxPumCMidGElpAVamfD5dStcy2smOs9rtzmmZ18jFZru/Wsj6BxBOX6sZEfGBv0K7Lz6sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pH6K+ixV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pH6K+ixV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE07B1F00899;
	Tue,  2 Jun 2026 22:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439042;
	bh=TQrWGUdt7ZrRWkZMqnzUHW5flbmGTT7ZH/zz6xLu/dU=;
	h=Date:To:From:Subject;
	b=pH6K+ixVcGZR4aOrviPwd63AAVMoqPW/6eNkim7DlcuO/YwZgdu19oXAQXNRIgPiJ
	 4OmcVJWsjMn1puhbDtiZC/NgPn16ZIUnjqgK0TLPzeAbjKHDueiateBDaEKrf7k2eG
	 PrYfyLKAASPdeFcaNx0GZkOR8TM6eIai2nJA5Tcg=
Date: Tue, 02 Jun 2026 15:24:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,seanjc@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,itazur@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch removed from -mm tree
Message-Id: <20260602222402.AE07B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_notifier: fix a begin vs. start typo in the invalidate range comment
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Takahiro Itazuri <itazur@amazon.com>
Subject: mm/mmu_notifier: fix a begin vs. start typo in the invalidate range comment
Date: Wed, 13 May 2026 09:35:46 -0700

Fix a goof in the block comment for invalidate_range_{start,end}() where
start() is incorrectly referred to as begin().

No functional change intended.

[seanjc@google.com: split to separate patch, write changelog]
Link: https://lore.kernel.org/20260513163546.1176742-1-seanjc@google.com
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment
+++ a/include/linux/mmu_notifier.h
@@ -134,8 +134,8 @@ struct mmu_notifier_ops {
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
 	 * establishment of sptes is forbidden in the range passed to
-	 * invalidate_range_begin/end for the whole duration of the
-	 * invalidate_range_begin/end critical section.
+	 * invalidate_range_start/end for the whole duration of the
+	 * invalidate_range_start/end critical section.
 	 *
 	 * invalidate_range_start() is called when all pages in the
 	 * range are still mapped and have at least a refcount of one.
_

Patches currently in -mm which might be from itazur@amazon.com are


