Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2579A284B3F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126251; cv=none; b=tZUuFpoTWcvOCGYvxGicA3fhp8W8SBwHHvhrIW7sjHyjMZ6udFVUiP5u8e6DktVSVIS/VpPPbuMXMl7x1QejpyQh36PCCFidQMDLbYA2UzEKh0k4WuhkJ/Y/Ipg9lpa1v9OuQiqwN4c6h1RhrKUQpyTC5DFmkIS/zfbWkynFBIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126251; c=relaxed/simple;
	bh=96jWmQarMRdhJJFAgAI6J1eXbGO27I8wsA33FyeP8zs=;
	h=Date:To:From:Subject:Message-Id; b=m3QkEtrwNkx65EL3lCgpkhMujVFcsOvfuhIvbZJHe4kj/sNI2Wd3eaN8H//DlNtTQ5Nw/z1jQGIvEKFE8PN51x7sxV3leO7NG5i8uvKbjnxUaG/pJ9M03cDOKMQHiEjIFAoQAVV4e5u4EX0gFg+NWn8CHpm5H6leqEPtXn1uUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WSXXlGku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WSXXlGku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A8FC4CEE3;
	Thu, 10 Jul 2025 05:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126251;
	bh=96jWmQarMRdhJJFAgAI6J1eXbGO27I8wsA33FyeP8zs=;
	h=Date:To:From:Subject:From;
	b=WSXXlGkusbYsMm4E+R4o23T76tvEHqnwD4O49AIxQ7fXttvmF1SMFgyA4aH6GIXQC
	 degwbqyATiezegXp6OJGHUdDZIQINr/7agYTNtdZ/XQOJJv+Yqh+c+/EaMmvtWBJs+
	 z0jXzJqga02t5qKLA3ysH97M0Q2Qr+cZjjmvn7zg=
Date: Wed, 09 Jul 2025 22:44:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lkp@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-skip-unnecessary-synchronize_rcu.patch removed from -mm tree
Message-Id: <20250710054410.E4A8FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: skip unnecessary synchronize_rcu()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: skip unnecessary synchronize_rcu()
Date: Mon, 2 Jun 2025 09:23:40 -0700

By unconditionally setting wi_state to NULL and conditionally calling
synchronize_rcu(), we can save an unncessary call when there is no
old_wi_state.

Link: https://lkml.kernel.org/r/20250602162345.2595696-2-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-skip-unnecessary-synchronize_rcu
+++ a/mm/mempolicy.c
@@ -3703,18 +3703,15 @@ static void wi_state_free(void)
 	struct weighted_interleave_state *old_wi_state;
 
 	mutex_lock(&wi_state_lock);
-
 	old_wi_state = rcu_dereference_protected(wi_state,
 			lockdep_is_held(&wi_state_lock));
-	if (!old_wi_state) {
-		mutex_unlock(&wi_state_lock);
-		return;
-	}
-
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
-	synchronize_rcu();
-	kfree(old_wi_state);
+
+	if (old_wi_state) {
+		synchronize_rcu();
+		kfree(old_wi_state);
+	}
 }
 
 static struct kobj_attribute wi_auto_attr =
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


