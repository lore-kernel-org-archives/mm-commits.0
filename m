Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A971FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186176; cv=none; b=eH1x8VnlEq6Lq+86m7pjdrgEVPW91haSs2xSdcAmeDN1bXnU7MVFa6WSwwOpduLO9y0aEgKyz89cO4qVusN3Rfxh5aLzkoRHW0D0RUY77qphwh8Rm5uEjImPch451/HmHZ6DaplYud5d7BddS1kcffQu0P5p+nkvWTgeQhAcK+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186176; c=relaxed/simple;
	bh=VIOd7V8USImMWM3cX7qpkt0b1/QKczDfwfnMuLCTc2s=;
	h=Date:To:From:Subject:Message-Id; b=tmVudFO4pvxhhN2hldaiKIYT6pcUNxbv+j8oAHYqNaf6zg+LRuccyj/DHXLvztJ4Y6/7mjahAWYLEMDm8YoCbOmSPavOxQRTKegyERHXLwRYeMX3SdA0Kv7OjgQ2rXW/RAiL8V+R9L1+uYgDfkAB9XELq/DZPZG62af4HPP0zLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2mk4IX1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2mk4IX1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBB5C4CEEB;
	Fri,  6 Jun 2025 05:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186175;
	bh=VIOd7V8USImMWM3cX7qpkt0b1/QKczDfwfnMuLCTc2s=;
	h=Date:To:From:Subject:From;
	b=2mk4IX1D7jLELwWtWKIwjGSuiWs5wUxskf1gyflIx2vDWP5IylVKZ4ra9uWr26JfK
	 4U1fcpbQAbdaJoNQMPksFFHU8KkBcvNCF36cvhm1bD0OGB5MsZUFMOnrl4rBnbaUgL
	 l1dGS+WOxj568RtUxteGAAEW4/684hWQQ3oFSuKs=
Date: Thu, 05 Jun 2025 22:02:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lkp@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch removed from -mm tree
Message-Id: <20250606050255.6BBB5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix incorrect freeing of wi_kobj
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: fix incorrect freeing of wi_kobj
Date: Mon, 2 Jun 2025 09:23:39 -0700

We should not free wi_group->wi_kobj here.  In the error path of
add_weighted_interleave_group() where this snippet is called from,
kobj_{del, put} is immediately called right after this section.  Thus, it
is not only unnecessary but also incorrect to free it here.

Link: https://lkml.kernel.org/r/20250602162345.2595696-1-joshua.hahnjy@gmail.com
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506011545.Fduxqxqj-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-incorrect-freeing-of-wi_kobj
+++ a/mm/mempolicy.c
@@ -3708,15 +3708,13 @@ static void wi_state_free(void)
 			lockdep_is_held(&wi_state_lock));
 	if (!old_wi_state) {
 		mutex_unlock(&wi_state_lock);
-		goto out;
+		return;
 	}
 
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
 	synchronize_rcu();
 	kfree(old_wi_state);
-out:
-	kfree(&wi_group->wi_kobj);
 }
 
 static struct kobj_attribute wi_auto_attr =
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

