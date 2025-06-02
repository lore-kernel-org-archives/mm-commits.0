Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666E8189BB5
	for <mm-commits@vger.kernel.org>; Mon,  2 Jun 2025 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905844; cv=none; b=XE7Gf4sucJreQ3kxh+dYE9AY6xDgRtJw9U3OZ7/a5jVJ4DwNRRzp0r+S5frnKaG+m5sh8oMncI8aI9KhrA21fiepo9MUV5n34KzqXOEiS10/JnnfPfCZ4TTTZBz3+VSHYHIyD1+Nek8xRXX8dzrArmk7JI+OS9ZhGOz4bebkMnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905844; c=relaxed/simple;
	bh=ke5PWxvXzwyLpXe10LSsXu0O1xvOeQFPtmGr81kk0hQ=;
	h=Date:To:From:Subject:Message-Id; b=oIsjLPiH83tk82X38vKyOFyi6Hn9saPFN9Pv9mVAGaM8geClS54GfxKAPB18twyNpu6Am+wSFhfVMIKpelzlsI1yLkdvvK4EOzsG6xz51H7aMlzkXbZ09JODAXn/LSueQgdM3PuyfKUp8a3xc6JJb5rVdChVKz4KkRPyK36kCeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yJs0qLkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJs0qLkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C84C4CEEB;
	Mon,  2 Jun 2025 23:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748905842;
	bh=ke5PWxvXzwyLpXe10LSsXu0O1xvOeQFPtmGr81kk0hQ=;
	h=Date:To:From:Subject:From;
	b=yJs0qLkz37iKAFLlskQFh6JXbgg9dW8t/Mo4rZhXxB7mZpJYiXef8TATQj+p7dF+M
	 YGiPcNMrSjgrHfENPuqBPsLaOUf4uIYdIRZ98nq02ylGJhqO4FGTHNUC8ctffiyxNr
	 WEU1JW+U1FywrbNb/lYmbK7hd8bJvaQu9z4zHebQ=
Date: Mon, 02 Jun 2025 16:10:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lkp@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-skip-unnecessary-synchronize_rcu.patch added to mm-hotfixes-unstable branch
Message-Id: <20250602231042.B4C84C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: Skip unnecessary synchronize_rcu()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: Skip unnecessary synchronize_rcu()
Date: Mon, 2 Jun 2025 09:23:40 -0700

By unconditionally setting wi_state to NULL and conditionally calling
synchronize_rcu(), we can save an unncessary call when there is no
old_wi_state.

Link: https://lkml.kernel.org/r/20250602162345.2595696-2-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
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

mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch
mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

